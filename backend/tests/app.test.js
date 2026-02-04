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

jest.unstable_mockModule("bcryptjs", () => ({ default: mockBcrypt }));

const usersById = new Map();
const usersByEmail = new Map();
let idCounter = 1;

const makeId = () => String(idCounter++).padStart(24, "0");

const makeQueryChain = (data) => {
  const queryObj = {
    then: (resolve) => Promise.resolve(data).then(resolve),
    sort: (criteria) => {
      if (criteria.points === -1) {
        data.sort((a, b) => (b.points || 0) - (a.points || 0));
      }
      return queryObj;
    },
    limit: (n) => {
      data = data.slice(0, n);
      return queryObj;
    },
    select: (fields) => queryObj,
  };
  return queryObj;
};

const makeSingleQuery = (user) => {
  return {
    select: () => makeSingleQuery(user),
    then: (resolve) => Promise.resolve(user).then(resolve),
  };
};

class MockUser {
  static findOne = async (query) => {
    if (!query) return null;
    if (query.email) {
      return usersByEmail.get(String(query.email).toLowerCase()) ?? null;
    }
    if (query.refreshToken) {
      for (const user of usersById.values()) {
        if (
          Array.isArray(user.refreshToken) &&
          user.refreshToken.includes(query.refreshToken)
        ) {
          return user;
        }
      }
    }
    return null;
  };

  static findById = (id) => {
    const user = usersById.get(String(id)) ?? null;
    return makeSingleQuery(user);
  };

  static find = () => {
    const allUsers = Array.from(usersById.values());
    return makeQueryChain(allUsers);
  };

  static countDocuments = async (query) => {
    if (query.points && query.points.$gt !== undefined) {
      const threshold = query.points.$gt;
      return Array.from(usersById.values()).filter(
        (u) => (u.points || 0) > threshold,
      ).length;
    }
    return 0;
  };

  constructor(data) {
    this._id = data?._id ?? makeId();
    Object.defineProperty(this, "id", { get: () => this._id });
    this.firstName = data?.firstName;
    this.lastName = data?.lastName;
    this.email = data?.email;
    this.password = data?.password ?? null;
    this.authProvider = data?.authProvider ?? "local";
    this.googleSub = data?.googleSub;
    this.picture = data?.picture;
    this.refreshToken = data?.refreshToken ?? [];
    this.points = data?.points ?? 0;
  }

  save = async () => {
    usersById.set(this._id, this);
    if (this.email) {
      usersByEmail.set(String(this.email).toLowerCase(), this);
    }
    return this;
  };
}

jest.unstable_mockModule("../src/models/User.js", () => ({ User: MockUser }));

const verifyIdToken = jest.fn();
jest.unstable_mockModule("google-auth-library", () => ({
  OAuth2Client: class {
    verifyIdToken = verifyIdToken;
  },
}));

const { app } = await import("../src/app.js");

describe("Integration Test: API", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    mockBcrypt.compare.mockResolvedValue(true);
    usersById.clear();
    usersByEmail.clear();
    idCounter = 1;
  });

  const signup = async (override = {}) => {
    return request(app)
      .post("/auth/signup")
      .send({
        firstName: "Mario",
        lastName: "Rossi",
        email: "mario@example.com",
        password: "Password123",
        ...override,
      });
  };

  const login = async (override = {}) => {
    return request(app)
      .post("/auth/login")
      .send({
        email: "mario@example.com",
        password: "Password123",
        ...override,
      });
  };

  it("GET / responds with health status", async () => {
    const res = await request(app).get("/");
    expect(res.statusCode).toBe(200);
    expect(res.body).toEqual({
      status: "OK",
      message: "AuraBus API is alive!",
    });
  });

  describe("Auth: Local Registration", () => {
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

    it("POST /auth/signup rejects duplicate email", async () => {
      const first = await signup();
      expect(first.statusCode).toBe(201);

      const second = await signup();
      expect(second.statusCode).toBe(400);
      expect(second.body.success).toBe(false);
      expect(second.body.message).toBe("Email already in use");
    });
  });

  describe("Auth: Local Login", () => {
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
        "This account does not support password login",
      );
    });

    it("POST /auth/login returns tokens for valid credentials", async () => {
      await signup();
      mockBcrypt.compare.mockResolvedValue(true);
      const res = await login();
      expect(res.statusCode).toBe(200);
      expect(res.body.success).toBe(true);
    });

    it("POST /auth/login returns user points", async () => {
      const user = new MockUser({
        firstName: "Pro",
        lastName: "Gamer",
        email: "pro@test.com",
        password: "hashed",
        points: 2500,
      });
      await user.save();

      const res = await login({ email: "pro@test.com", password: "password" });

      expect(res.statusCode).toBe(200);
      expect(res.body.user.points).toBe(2500);
    });
  });

  describe("Auth: Google", () => {
    it("POST /auth/google exchanges idToken for app tokens", async () => {
      verifyIdToken.mockResolvedValue({
        getPayload: () => ({
          email: "guser@example.com",
          email_verified: true,
          sub: "google-sub-123",
          given_name: "G",
          family_name: "U",
        }),
      });
      const res = await request(app)
        .post("/auth/google")
        .send({ idToken: "fake" });

      expect(res.statusCode).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.user.email).toBe("guser@example.com");
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

  describe("Auth: Token Management & Me", () => {
    it("GET /auth/me returns the current user with a valid access token", async () => {
      const signupRes = await signup();
      expect(signupRes.statusCode).toBe(201);

      const meRes = await request(app)
        .get("/auth/me")
        .set("Authorization", `Bearer ${signupRes.body.accessToken}`);

      expect(meRes.statusCode).toBe(200);
      expect(meRes.body.user.email).toBe("mario@example.com");
    });

    it("POST /auth/refresh-token validates request", async () => {
      const res = await request(app).post("/auth/refresh-token").send({});
      expect(res.statusCode).toBe(400);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toBe("Refresh Token is required");
    });

    it("POST /auth/refresh-token rotates refresh tokens and revokes the old one", async () => {
      const signupRes = await signup();
      const oldRefresh = signupRes.body.refreshToken;

      const refreshRes = await request(app)
        .post("/auth/refresh-token")
        .send({ refreshToken: oldRefresh });

      expect(refreshRes.statusCode).toBe(200);
      expect(refreshRes.body.success).toBe(true);
      expect(typeof refreshRes.body.accessToken).toBe("string");
      expect(typeof refreshRes.body.refreshToken).toBe("string");
      expect(refreshRes.body.refreshToken).not.toBe(oldRefresh);

      const revokedRes = await request(app)
        .post("/auth/refresh-token")
        .send({ refreshToken: oldRefresh });

      expect(revokedRes.statusCode).toBe(403);
      expect(revokedRes.body.success).toBe(false);
      expect(revokedRes.body.message).toMatch(/Invalid Refresh Token/);
    });

    it("POST /auth/logout removes the refresh token", async () => {
      const signupRes = await signup();
      const refreshToken = signupRes.body.refreshToken;

      const logoutRes = await request(app)
        .post("/auth/logout")
        .send({ refreshToken });

      expect(logoutRes.statusCode).toBe(204);

      const refreshRes = await request(app)
        .post("/auth/refresh-token")
        .send({ refreshToken });

      expect(refreshRes.statusCode).toBe(403);
    });
  });

  describe("Users: Leaderboard", () => {
    it("GET /users/leaderboard returns sorted top users", async () => {
      await new MockUser({
        firstName: "Top",
        lastName: "1",
        email: "1@t.com",
        points: 3000,
      }).save();
      await new MockUser({
        firstName: "Mid",
        lastName: "2",
        email: "2@t.com",
        points: 1500,
      }).save();

      await new MockUser({
        firstName: "Me",
        lastName: "3",
        email: "me@t.com",
        points: 100,
        password: "hashed",
      }).save();

      const loginRes = await login({ email: "me@t.com", password: "pwd" });
      const token = loginRes.body.accessToken;

      const res = await request(app)
        .get("/users/leaderboard")
        .set("Authorization", `Bearer ${token}`);

      expect(res.statusCode).toBe(200);
      expect(res.body.success).toBe(true);

      const top = res.body.topUsers;
      expect(top.length).toBeGreaterThanOrEqual(3);
      expect(top[0].points).toBe(3000);
      expect(top[1].points).toBe(1500);
      expect(top[0]).toHaveProperty("rank", 1);
    });
  });
});
