import { jest } from "@jest/globals";
import request from "supertest";

process.env.NODE_ENV = "test";
process.env.JWT_SECRET = "test_jwt_secret";
process.env.REFRESH_SECRET = "test_refresh_secret";
process.env.GOOGLE_AUTH_CLIENT_ID = "test-google-client-id";

const mockBcrypt = {
  genSalt: jest.fn().mockResolvedValue("salt"),
  hash: jest.fn().mockResolvedValue("hashed-password"),
  compare: jest.fn().mockResolvedValue(true),
};

jest.unstable_mockModule("bcryptjs", () => ({
  default: mockBcrypt,
}));

const usersById = new Map();
const usersByEmail = new Map();
let idCounter = 1;

const makeId = () => String(idCounter++).padStart(24, "0");

const makeQuery = (user) => {
  return {
    select: async () => {
      if (!user) return null;
      return {
        _id: user._id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        authProvider: user.authProvider,
        googleSub: user.googleSub,
        picture: user.picture,
      };
    },
    then: (resolve, reject) => Promise.resolve(user).then(resolve, reject),
  };
};

class MockUser {
  static findOne = async (query) => {
    if (!query) return null;
    if (query.email) {
      return usersByEmail.get(String(query.email).toLowerCase()) ?? null;
    }
    if (query.refreshToken) {
      const token = String(query.refreshToken);
      for (const user of usersById.values()) {
        if (
          Array.isArray(user.refreshToken) &&
          user.refreshToken.includes(token)
        ) {
          return user;
        }
      }
      return null;
    }
    return null;
  };

  static findById = (id) => {
    const user = usersById.get(String(id)) ?? null;
    return makeQuery(user);
  };

  constructor(data) {
    this._id = data?._id ?? makeId();
    this.firstName = data?.firstName;
    this.lastName = data?.lastName;
    this.email = data?.email;
    this.password = data?.password ?? null;
    this.authProvider = data?.authProvider ?? "local";
    this.googleSub = data?.googleSub;
    this.picture = data?.picture;
    this.refreshToken = data?.refreshToken ?? [];
  }

  save = async () => {
    usersById.set(this._id, this);
    if (this.email) {
      usersByEmail.set(String(this.email).toLowerCase(), this);
    }
    return this;
  };
}

jest.unstable_mockModule("../src/models/User.js", () => ({
  User: MockUser,
}));

const verifyIdToken = jest.fn();

jest.unstable_mockModule("google-auth-library", () => ({
  OAuth2Client: class {
    verifyIdToken = verifyIdToken;
  },
}));

const { app } = await import("../src/app.js");

describe("Integration Test: Auth API", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    mockBcrypt.compare.mockResolvedValue(true);

    usersById.clear();
    usersByEmail.clear();
    idCounter = 1;
  });

  const signup = async (override = {}) => {
    const payload = {
      firstName: "Mario",
      lastName: "Rossi",
      email: "mario@example.com",
      password: "Password123",
      ...override,
    };
    return request(app).post("/auth/signup").send(payload);
  };

  const login = async (override = {}) => {
    const payload = {
      email: "mario@example.com",
      password: "Password123",
      ...override,
    };
    return request(app).post("/auth/login").send(payload);
  };

  it("GET / responds with health status", async () => {
    const res = await request(app).get("/");
    expect(res.statusCode).toBe(200);
    expect(res.body).toEqual({
      status: "OK",
      message: "AuraBus API is alive!",
    });
  });

  it("POST /auth/signup validates request", async () => {
    const res = await request(app).post("/auth/signup").send({});
    expect(res.statusCode).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.message).toBeDefined();
  });

  it("POST /auth/signup creates user and returns tokens", async () => {
    const res = await signup();

    expect(res.statusCode).toBe(201);
    expect(res.body.success).toBe(true);
    expect(typeof res.body.accessToken).toBe("string");
    expect(typeof res.body.refreshToken).toBe("string");
    expect(res.body.user.email).toBe("mario@example.com");
  });

  it("POST /auth/login rejects unknown user", async () => {
    const res = await login({ email: "missing@example.com" });

    expect(res.statusCode).toBe(404);
    expect(res.body.success).toBe(false);
    expect(res.body.message).toBe("User not found");
  });

  it("POST /auth/login rejects wrong password", async () => {
    await new MockUser({
      firstName: "Mario",
      lastName: "Rossi",
      email: "mario@example.com",
      password: "hashed-password",
    }).save();
    mockBcrypt.compare.mockResolvedValue(false);

    const res = await login({ password: "WrongPassword" });

    expect(res.statusCode).toBe(401);
    expect(res.body.success).toBe(false);
    expect(res.body.message).toBe("Wrong password");
  });

  it("POST /auth/login rejects password login for google-only account", async () => {
    await new MockUser({
      firstName: "Google",
      lastName: "User",
      email: "google@example.com",
      password: null,
      authProvider: "google",
      googleSub: "google-sub-123",
    }).save();

    const res = await request(app).post("/auth/login").send({
      email: "google@example.com",
      password: "doesnt-matter",
    });

    expect(res.statusCode).toBe(401);
    expect(res.body.success).toBe(false);
    expect(res.body.message).toBe(
      "This account does not support password login"
    );
  });

  it("POST /auth/google exchanges idToken for app tokens", async () => {
    verifyIdToken.mockResolvedValue({
      getPayload: () => ({
        email: "guser@example.com",
        email_verified: true,
        sub: "google-sub-123",
        given_name: "Google",
        family_name: "User",
        picture: "https://example.com/p.png",
      }),
    });

    const res = await request(app).post("/auth/google").send({
      idToken: "fake-google-id-token",
    });

    expect(res.statusCode).toBe(200);
    expect(res.body.success).toBe(true);
    expect(typeof res.body.accessToken).toBe("string");
    expect(typeof res.body.refreshToken).toBe("string");
    expect(res.body.user.email).toBe("guser@example.com");
  });

  it("GET /auth/me returns the current user with a valid access token", async () => {
    const signupRes = await signup();
    expect(signupRes.statusCode).toBe(201);

    const meRes = await request(app)
      .get("/auth/me")
      .set("Authorization", `Bearer ${signupRes.body.accessToken}`);

    expect(meRes.statusCode).toBe(200);
    expect(meRes.body.email).toBe("mario@example.com");
  });

  it("POST /auth/signup rejects duplicate email", async () => {
    const first = await signup();
    expect(first.statusCode).toBe(201);

    const second = await signup();
    expect(second.statusCode).toBe(400);
    expect(second.body.success).toBe(false);
    expect(second.body.message).toBe("Email already in use");
  });

  it("POST /auth/login returns tokens for valid credentials", async () => {
    const signupRes = await signup();
    expect(signupRes.statusCode).toBe(201);

    mockBcrypt.compare.mockResolvedValue(true);
    const res = await login();
    expect(res.statusCode).toBe(200);
    expect(res.body.success).toBe(true);
    expect(typeof res.body.accessToken).toBe("string");
    expect(typeof res.body.refreshToken).toBe("string");
    expect(res.body.user.email).toBe("mario@example.com");
  });

  it("POST /auth/refresh-token validates request", async () => {
    const res = await request(app).post("/auth/refresh-token").send({});
    expect(res.statusCode).toBe(400);
    expect(res.body.success).toBe(false);
    expect(res.body.message).toBe("Refresh Token is required");
  });

  it("POST /auth/refresh-token rotates refresh tokens and revokes the old one", async () => {
    const signupRes = await signup();
    expect(signupRes.statusCode).toBe(201);

    const oldRefresh = signupRes.body.refreshToken;
    const refreshRes = await request(app)
      .post("/auth/refresh-token")
      .send({ refreshToken: oldRefresh });

    expect(refreshRes.statusCode).toBe(200);
    expect(refreshRes.body.success).toBe(true);
    expect(typeof refreshRes.body.accessToken).toBe("string");
    expect(typeof refreshRes.body.refreshToken).toBe("string");

    const revokedRes = await request(app)
      .post("/auth/refresh-token")
      .send({ refreshToken: oldRefresh });

    expect(revokedRes.statusCode).toBe(403);
    expect(revokedRes.body.success).toBe(false);
    expect(revokedRes.body.message).toBe("Invalid Refresh Token (Revoked)");
  });

  it("POST /auth/logout removes the refresh token", async () => {
    const signupRes = await signup();
    expect(signupRes.statusCode).toBe(201);

    const refreshToken = signupRes.body.refreshToken;
    const logoutRes = await request(app)
      .post("/auth/logout")
      .send({ refreshToken });

    expect(logoutRes.statusCode).toBe(204);

    const refreshRes = await request(app)
      .post("/auth/refresh-token")
      .send({ refreshToken });
    expect(refreshRes.statusCode).toBe(403);
    expect(refreshRes.body.success).toBe(false);
    expect(refreshRes.body.message).toBe("Invalid Refresh Token (Revoked)");
  });

  it("POST /auth/google rejects unverified email", async () => {
    verifyIdToken.mockResolvedValue({
      getPayload: () => ({
        email: "guser@example.com",
        email_verified: false,
        sub: "google-sub-123",
      }),
    });

    const res = await request(app).post("/auth/google").send({
      idToken: "fake-google-id-token",
    });

    expect(res.statusCode).toBe(401);
    expect(res.body.success).toBe(false);
    expect(res.body.message).toBe("Google email is not verified");
  });

  it("POST /auth/google rejects mismatched googleSub for existing email", async () => {
    await new MockUser({
      firstName: "Existing",
      lastName: "User",
      email: "guser@example.com",
      authProvider: "google",
      googleSub: "google-sub-ORIGINAL",
      password: null,
    }).save();

    verifyIdToken.mockResolvedValue({
      getPayload: () => ({
        email: "guser@example.com",
        email_verified: true,
        sub: "google-sub-DIFFERENT",
      }),
    });

    const res = await request(app).post("/auth/google").send({
      idToken: "fake-google-id-token",
    });

    expect(res.statusCode).toBe(403);
    expect(res.body.success).toBe(false);
    expect(res.body.message).toBe("Google account mismatch for this email");
  });
});
