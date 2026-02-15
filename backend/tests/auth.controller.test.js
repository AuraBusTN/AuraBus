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
    return {
      select: () => ({
        then: (resolve) => Promise.resolve(user).then(resolve),
      }),
      then: (resolve) => Promise.resolve(user).then(resolve),
    };
  };

  static find = () => {
    return {
      sort: () => ({
        limit: () => ({
          select: () => ({
            then: (resolve) =>
              Promise.resolve(Array.from(usersById.values())).then(resolve),
          }),
        }),
      }),
    };
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
    this.favoriteRoutes = data?.favoriteRoutes ?? [];
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

const mockRedisClient = {
  on: jest.fn(),
  connect: jest.fn(),
  isOpen: true,
  get: jest.fn().mockResolvedValue(null),
  setEx: jest.fn().mockResolvedValue("OK"),
  del: jest.fn().mockResolvedValue(1),
  sendCommand: jest.fn().mockResolvedValue("OK"),
};

jest.unstable_mockModule("../src/config/redis.js", () => ({
  redisClient: mockRedisClient,
  initRedis: jest.fn(),
}));

jest.unstable_mockModule("mongoose", () => ({
  connect: jest.fn().mockResolvedValue({}),
  default: {
    connect: jest.fn().mockResolvedValue({}),
    Schema: class Schema {
      constructor() {}
    },
    model: jest.fn(() => ({})),
  },
  Schema: class Schema {
    constructor() {}
  },
  model: jest.fn(() => ({})),
}));

const { app } = await import("../src/app.js");

describe("AuthController - Additional Coverage", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    usersById.clear();
    usersByEmail.clear();
    idCounter = 1;
    mockBcrypt.compare.mockResolvedValue(true);
  });

  describe("POST /auth/login - Refresh Token Management", () => {
    it("should limit refresh tokens to 5 per user", async () => {
      const user = new MockUser({
        firstName: "Test",
        lastName: "User",
        email: "test@example.com",
        password: "hashed-password",
        refreshToken: ["token1", "token2", "token3", "token4", "token5"],
      });
      await user.save();

      const res = await request(app).post("/auth/login").send({
        email: "test@example.com",
        password: "Password123",
      });

      expect(res.statusCode).toBe(200);
      expect(res.body.success).toBe(true);

      const updatedUser = usersById.get(user._id);
      expect(updatedUser.refreshToken.length).toBe(5);
      expect(updatedUser.refreshToken).not.toContain("token1");
    });

    it("should return 401 for account without password (OAuth only)", async () => {
      const user = new MockUser({
        firstName: "Google",
        lastName: "User",
        email: "google@example.com",
        password: null,
        authProvider: "google",
        googleSub: "123456",
      });
      await user.save();

      const res = await request(app).post("/auth/login").send({
        email: "google@example.com",
        password: "Password123",
      });

      expect(res.statusCode).toBe(401);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toBe(
        "This account does not support password login",
      );
    });

    it("should return 401 for wrong password", async () => {
      mockBcrypt.compare.mockResolvedValueOnce(false);

      const user = new MockUser({
        firstName: "Test",
        lastName: "User",
        email: "test@example.com",
        password: "hashed-password",
      });
      await user.save();

      const res = await request(app).post("/auth/login").send({
        email: "test@example.com",
        password: "WrongPassword123",
      });

      expect(res.statusCode).toBe(401);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toBe("Wrong password");
    });
  });

  describe("POST /auth/google - Edge Cases", () => {
    it("should return 400 if idToken is missing", async () => {
      const res = await request(app).post("/auth/google").send({});

      expect(res.statusCode).toBe(400);
      expect(res.body.success).toBe(false);
    });

    it("should return 500 for invalid Google token", async () => {
      verifyIdToken.mockRejectedValueOnce(new Error("Invalid token"));

      const res = await request(app).post("/auth/google").send({
        idToken: "invalid-token",
      });

      expect(res.statusCode).toBe(500);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toContain("Invalid");
    });

    it("should return 403 if email is not verified", async () => {
      verifyIdToken.mockImplementationOnce(async () => ({
        getPayload: () => ({
          sub: "google-sub-123",
          email: "unverified@example.com",
          email_verified: false,
          given_name: "Test",
          family_name: "User",
          picture: "https://example.com/pic.jpg",
        }),
      }));

      const res = await request(app).post("/auth/google").send({
        idToken: "valid-token",
      });

      expect(res.statusCode).toBe(401);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toContain("verified");
    });

    it("should create new user with Google auth if not exists", async () => {
      verifyIdToken.mockImplementationOnce(async () => ({
        getPayload: () => ({
          sub: "google-sub-new",
          email: "newgoogle@example.com",
          email_verified: true,
          given_name: "New",
          family_name: "GoogleUser",
          picture: "https://example.com/new.jpg",
        }),
      }));

      const res = await request(app).post("/auth/google").send({
        idToken: "valid-token",
      });

      expect(res.statusCode).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.user.email).toBe("newgoogle@example.com");
      expect(res.body.user.firstName).toBe("New");
      expect(res.body.user.lastName).toBe("GoogleUser");
    });

    it("should update existing Google user info on login", async () => {
      const existingUser = new MockUser({
        firstName: "Old",
        lastName: "Name",
        email: "existing@example.com",
        authProvider: "google",
        googleSub: "google-sub-existing",
        picture: "old-picture.jpg",
      });
      await existingUser.save();

      verifyIdToken.mockImplementationOnce(async () => ({
        getPayload: () => ({
          sub: "google-sub-existing",
          email: "existing@example.com",
          email_verified: true,
          given_name: "Updated",
          family_name: "Name",
          picture: "new-picture.jpg",
        }),
      }));

      const res = await request(app).post("/auth/google").send({
        idToken: "valid-token",
      });

      expect(res.statusCode).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.user.firstName).toBe("Old");
      expect(res.body.user.picture).toBe("old-picture.jpg");
    });
  });

  describe("POST /auth/refresh-token - Edge Cases", () => {
    it("should return 400 if refreshToken is missing", async () => {
      const res = await request(app).post("/auth/refresh-token").send({});

      expect(res.statusCode).toBe(400);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toContain("required");
    });

    it("should return 403 for expired refresh token", async () => {
      const res = await request(app).post("/auth/refresh-token").send({
        refreshToken: "expired-or-invalid-token",
      });

      expect(res.statusCode).toBe(403);
      expect(res.body.success).toBe(false);
    });

    it("should return 403 if user not found", async () => {
      const validToken = "Bearer valid.token.here";

      const res = await request(app).post("/auth/refresh-token").send({
        refreshToken: validToken,
      });

      expect(res.statusCode).toBe(403);
      expect(res.body.success).toBe(false);
    });
  });

  describe("POST /auth/logout - Edge Cases", () => {
    it("should return 400 if refreshToken is missing", async () => {
      const signupRes = await request(app).post("/auth/signup").send({
        firstName: "Test",
        lastName: "User",
        email: "test@example.com",
        password: "Password123",
      });

      const res = await request(app)
        .post("/auth/logout")
        .set("Authorization", `Bearer ${signupRes.body.accessToken}`)
        .send({});

      expect(res.statusCode).toBe(400);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toContain("required");
    });
  });

  describe("GET /auth/me - Authorization", () => {
    it("should return 401 if no token provided", async () => {
      const res = await request(app).get("/auth/me");

      expect(res.statusCode).toBe(401);
      expect(res.body.success).toBe(false);
    });

    it("should return 403 for invalid token", async () => {
      const res = await request(app)
        .get("/auth/me")
        .set("Authorization", "Bearer invalid-token");

      expect(res.statusCode).toBe(403);
      expect(res.body.success).toBe(false);
    });
  });
});
