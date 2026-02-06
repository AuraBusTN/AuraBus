import { jest } from "@jest/globals";
import request from "supertest";

process.env.NODE_ENV = "test";
process.env.JWT_SECRET = "test_jwt_secret";
process.env.REFRESH_SECRET = "test_refresh_secret";
process.env.GOOGLE_AUTH_CLIENT_ID = "test_google_client_id";

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
  toJSON() {
    return {
      id: this.id,
      firstName: this.firstName,
      lastName: this.lastName,
      email: this.email,
      authProvider: this.authProvider,
      googleSub: this.googleSub,
      picture: this.picture,
      points: this.points,
      favoriteRoutes: this.favoriteRoutes,
    };
  }

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

const { app } = await import("../src/app.js");

describe("Users API - Leaderboard", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    mockBcrypt.compare.mockResolvedValue(true);
    usersById.clear();
    usersByEmail.clear();
    idCounter = 1;
  });

  const login = async (email, password = "Password123") => {
    return request(app).post("/auth/login").send({ email, password });
  };

  describe("GET /users/leaderboard", () => {
    it("should return sorted top users", async () => {
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

      const loginRes = await login("me@t.com", "pwd");
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
      expect(top[1]).toHaveProperty("rank", 2);
    });

    it("should return current user when not in top 10", async () => {
      for (let i = 0; i < 10; i++) {
        await new MockUser({
          firstName: `User${i}`,
          lastName: "Top",
          email: `user${i}@test.com`,
          points: 1000 - i * 10,
        }).save();
      }

      await new MockUser({
        firstName: "Current",
        lastName: "User",
        email: "current@test.com",
        points: 50,
        password: "hashed",
      }).save();

      const loginRes = await login("current@test.com");
      const token = loginRes.body.accessToken;

      const res = await request(app)
        .get("/users/leaderboard")
        .set("Authorization", `Bearer ${token}`);

      expect(res.statusCode).toBe(200);
      expect(res.body.topUsers).toHaveLength(10);
      expect(res.body.me).not.toBeNull();
      expect(res.body.me.firstName).toBe("Current");
      expect(res.body.me.rank).toBe(11);
    });

    it("should return null for me when current user is in top 10", async () => {
      await new MockUser({
        firstName: "Current",
        lastName: "User",
        email: "current@test.com",
        points: 2000,
        password: "hashed",
      }).save();

      for (let i = 0; i < 5; i++) {
        await new MockUser({
          firstName: `User${i}`,
          lastName: "Other",
          email: `user${i}@test.com`,
          points: 1000 - i * 100,
        }).save();
      }

      const loginRes = await login("current@test.com");
      const token = loginRes.body.accessToken;

      const res = await request(app)
        .get("/users/leaderboard")
        .set("Authorization", `Bearer ${token}`);

      expect(res.statusCode).toBe(200);
      expect(res.body.me).toBeNull();
      expect(res.body.topUsers.some((u) => u.firstName === "Current")).toBe(
        true,
      );
    });

    it("should require authentication", async () => {
      const res = await request(app).get("/users/leaderboard");

      expect(res.statusCode).toBe(401);
      expect(res.body.success).toBe(false);
    });

    it("should handle user with 0 points", async () => {
      await new MockUser({
        firstName: "Zero",
        lastName: "Points",
        email: "zero@test.com",
        points: 0,
        password: "hashed",
      }).save();

      const loginRes = await login("zero@test.com");
      const token = loginRes.body.accessToken;

      const res = await request(app)
        .get("/users/leaderboard")
        .set("Authorization", `Bearer ${token}`);

      expect(res.statusCode).toBe(200);
      expect(res.body.success).toBe(true);
    });

    it("should include rank for each user in top 10", async () => {
      for (let i = 0; i < 5; i++) {
        await new MockUser({
          firstName: `User${i}`,
          lastName: "Test",
          email: `user${i}@test.com`,
          points: 500 - i * 50,
          password: i === 0 ? "hashed" : null,
        }).save();
      }

      const loginRes = await login("user0@test.com");
      const token = loginRes.body.accessToken;

      const res = await request(app)
        .get("/users/leaderboard")
        .set("Authorization", `Bearer ${token}`);

      expect(res.statusCode).toBe(200);
      const topUsers = res.body.topUsers;

      topUsers.forEach((user, index) => {
        expect(user.rank).toBe(index + 1);
      });
    });

    it("should not expose sensitive user data", async () => {
      await new MockUser({
        firstName: "Test",
        lastName: "User",
        email: "test@test.com",
        points: 100,
        password: "super-secret-hash",
      }).save();

      const loginRes = await login("test@test.com");
      const token = loginRes.body.accessToken;

      const res = await request(app)
        .get("/users/leaderboard")
        .set("Authorization", `Bearer ${token}`);

      expect(res.statusCode).toBe(200);

      res.body.topUsers.forEach((user) => {
        expect(user).not.toHaveProperty("password");
        expect(user).not.toHaveProperty("refreshToken");
        expect(user).not.toHaveProperty("_id");
      });
    });

    it("should return 404 if current user not found", async () => {
      const jwt = await import("jsonwebtoken");
      const fakeToken = jwt.default.sign(
        { id: "999999999999999999999999" },
        process.env.JWT_SECRET,
        { expiresIn: "1h" },
      );

      const res = await request(app)
        .get("/users/leaderboard")
        .set("Authorization", `Bearer ${fakeToken}`);

      expect(res.statusCode).toBe(404);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toBe("User not found");
    });
  });
});
