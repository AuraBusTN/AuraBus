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

const { app } = await import("../src/app.js");

describe("User Favorite Routes API", () => {
  let authToken;
  let testUserId;

  beforeEach(async () => {
    jest.clearAllMocks();
    usersById.clear();
    usersByEmail.clear();
    idCounter = 1;

    const testUser = new MockUser({
      firstName: "Test",
      lastName: "User",
      email: "testfav@example.com",
      password: "hashed-password",
      authProvider: "local",
    });
    await testUser.save();
    testUserId = testUser._id;

    const jwt = await import("jsonwebtoken");
    authToken = jwt.default.sign({ id: testUserId }, process.env.JWT_SECRET, {
      expiresIn: "1h",
    });
  });

  describe("GET /users/favorite-routes", () => {
    it("should return empty array for new user", async () => {
      const response = await request(app)
        .get("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.favoriteRoutes).toEqual([]);
    });

    it("should return existing favorite routes", async () => {
      const user = usersById.get(testUserId);
      user.favoriteRoutes = [101, 202, 303];

      const response = await request(app)
        .get("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.favoriteRoutes).toEqual([101, 202, 303]);
    });
  });

  describe("POST /users/favorite-routes", () => {
    it("should update favorite routes successfully with integers", async () => {
      const favoriteRoutes = [101, 202, 303];

      const response = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.message).toBe(
        "Favorite routes updated successfully",
      );
      expect(response.body.favoriteRoutes).toEqual(favoriteRoutes);
    });

    it("should remove duplicates from favorite routes", async () => {
      const favoriteRoutesWithDuplicates = [101, 202, 101, 303, 202];

      const response = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes: favoriteRoutesWithDuplicates });

      expect(response.status).toBe(200);
      expect(response.body.favoriteRoutes).toHaveLength(3);
      expect(new Set(response.body.favoriteRoutes).size).toBe(3);
      expect(response.body.favoriteRoutes).toContain(101);
      expect(response.body.favoriteRoutes).toContain(202);
      expect(response.body.favoriteRoutes).toContain(303);
    });

    it("should reject non-array input", async () => {
      const response = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes: "not-an-array" });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
      expect(response.body.message).toBe("favoriteRoutes must be an array");
    });

    it("should reject non-integer values", async () => {
      const favoriteRoutes = [101, "string", 303];

      const response = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
      expect(response.body.message).toBe("Each route ID must be an integer");
    });

    it("should reject floating point numbers", async () => {
      const favoriteRoutes = [101, 202.5, 303];

      const response = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes });

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
      expect(response.body.message).toBe("Each route ID must be an integer");
    });

    it("should allow exactly 20 routes", async () => {
      const favoriteRoutes = Array.from({ length: 20 }, (_, i) => i + 100);

      const response = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.favoriteRoutes).toHaveLength(20);
    });

    it("should allow clearing all favorites with empty array", async () => {
      // First set some favorites
      await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes: [101, 202] });

      // Then clear them
      const response = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes: [] });

      expect(response.status).toBe(200);
      expect(response.body.favoriteRoutes).toEqual([]);
    });

    it("should handle negative route IDs", async () => {
      const favoriteRoutes = [101, -1, 303];

      const response = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes });

      expect(response.status).toBe(200);
      expect(response.body.favoriteRoutes).toContain(-1);
    });

    it("should handle zero as route ID", async () => {
      const favoriteRoutes = [0, 101, 202];

      const response = await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes });

      expect(response.status).toBe(200);
      expect(response.body.favoriteRoutes).toContain(0);
    });
  });

  describe("Integration: GET after POST", () => {
    it("should retrieve previously saved favorite routes", async () => {
      const favoriteRoutes = [101, 202, 303];

      await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes });

      const response = await request(app)
        .get("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`);

      expect(response.status).toBe(200);
      expect(response.body.favoriteRoutes).toEqual(favoriteRoutes);
    });

    it("should update existing favorites", async () => {
      await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes: [101, 202, 303] });

      const newFavorites = [404, 505, 606];
      await request(app)
        .post("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`)
        .send({ favoriteRoutes: newFavorites });

      const response = await request(app)
        .get("/users/favorite-routes")
        .set("Authorization", `Bearer ${authToken}`);

      expect(response.status).toBe(200);
      expect(response.body.favoriteRoutes).toEqual(newFavorites);
      expect(response.body.favoriteRoutes).not.toContain(101);
    });
  });

  describe("Authentication", () => {
    it("should require authentication for GET and POST", async () => {
      const getRes = await request(app).get("/users/favorite-routes");
      expect(getRes.status).toBe(401);
      expect(getRes.body.success).toBe(false);

      const postRes = await request(app)
        .post("/users/favorite-routes")
        .send({ favoriteRoutes: [101] });
      expect(postRes.status).toBe(401);
      expect(postRes.body.success).toBe(false);
    });
  });
});
