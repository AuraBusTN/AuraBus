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

  static find = (query = {}) => {
    const allUsers = Array.from(usersById.values());
    return makeQueryChain(allUsers);
  };

  static countDocuments = async (query) => {
    if (query?.points?.$gt !== undefined) {
      const threshold = query.points.$gt;
      return Array.from(usersById.values()).filter(
        (u) => (u.points || 0) > threshold,
      ).length;
    }
    return usersById.size;
  };

  static findByIdAndUpdate = async (id, update, options) => {
    const user = usersById.get(String(id));
    if (!user) return null;

    if (update.favoriteRoutes !== undefined) {
      user.favoriteRoutes = update.favoriteRoutes;
    }
    if (update.$pull?.refreshToken) {
      const tokenToRemove = update.$pull.refreshToken;
      user.refreshToken = user.refreshToken.filter((t) => t !== tokenToRemove);
    }

    if (options?.select === "favoriteRoutes") {
      return { favoriteRoutes: user.favoriteRoutes };
    }

    return user;
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

describe("UserController - Edge Cases and Error Handling", () => {
  let authToken;
  let testUserId;

  beforeEach(async () => {
    jest.clearAllMocks();
    usersById.clear();
    usersByEmail.clear();
    idCounter = 1;
    mockRedisClient.get.mockResolvedValue(null);

    const signupRes = await request(app).post("/auth/signup").send({
      firstName: "Test",
      lastName: "User",
      email: "test@example.com",
      password: "Password123",
    });

    authToken = signupRes.body.accessToken;
    testUserId = Array.from(usersById.keys())[0];

    const user = usersById.get(testUserId);
    user.points = 100;
    user.favoriteRoutes = [1, 2, 3];
  });

  describe("GET /users/leaderboard - Error Cases", () => {
    it("should return 404 if current user not found in database", async () => {
      usersById.clear();

      const res = await request(app)
        .get("/users/leaderboard")
        .set("Authorization", `Bearer ${authToken}`);

      expect(res.statusCode).toBe(404);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toBe("User not found");
    });
  });

  describe("GET /users/favorite-routes - Redis Cache Handling", () => {
    it("should fallback to DB when Redis read fails", async () => {
      mockRedisClient.get.mockRejectedValueOnce(new Error("Redis error"));

      const res = await request(app)
        .get("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`);

      expect(res.statusCode).toBe(200);
      expect(res.body.success).toBe(true);
      expect(Array.isArray(res.body.favoriteRoutes)).toBe(true);
    });

    it("should handle Redis cache write failure gracefully", async () => {
      mockRedisClient.setEx.mockRejectedValueOnce(new Error("Redis error"));

      const res = await request(app)
        .get("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`);

      expect(res.statusCode).toBe(200);
      expect(res.body.success).toBe(true);
    });

    it("should return 404 if user not found", async () => {
      usersById.delete(testUserId);

      const res = await request(app)
        .get("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`);

      expect(res.statusCode).toBe(404);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toBe("User not found");
    });
  });

  describe("POST /users/favorite-routes - Validation and Error Handling", () => {
    it("should return 400 if favoriteRoutes field is missing", async () => {
      const res = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({});

      expect(res.statusCode).toBe(400);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toBe("favoriteRoutes field is required");
    });

    it("should return 400 if favoriteRoutes is not an array", async () => {
      const res = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes: "not-an-array" });

      expect(res.statusCode).toBe(400);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toBe("favoriteRoutes must be an array");
    });

    it("should return 400 if route IDs are not positive integers", async () => {
      const res = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes: [1, -2, 3] });

      expect(res.statusCode).toBe(400);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toBe("Each route ID must be a positive integer");
    });

    it("should return 400 if route IDs contain floats", async () => {
      const res = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes: [1.5, 2, 3] });

      expect(res.statusCode).toBe(400);
      expect(res.body.success).toBe(false);
    });

    it("should return 400 if route IDs contain zero", async () => {
      const res = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes: [0, 1, 2] });

      expect(res.statusCode).toBe(400);
      expect(res.body.success).toBe(false);
    });

    it("should return 404 if user not found during update", async () => {
      usersById.delete(testUserId);

      const res = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes: [1, 2, 3] });

      expect(res.statusCode).toBe(404);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toBe("User not found");
    });

    it("should handle Redis delete failure gracefully", async () => {
      mockRedisClient.del.mockRejectedValueOnce(new Error("Redis error"));

      const res = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes: [4, 5, 6] });

      expect(res.statusCode).toBe(200);
      expect(res.body.success).toBe(true);
    });
  });
});
