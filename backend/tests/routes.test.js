import { jest } from "@jest/globals";
import request from "supertest";
import { initData } from "../src/utils/staticData.js";

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

const mockUser = { findOne: jest.fn(), findById: jest.fn(), find: jest.fn() };
jest.unstable_mockModule("../src/models/User.js", () => ({ User: mockUser }));

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

const { app } = await import("../src/app.js");

describe("Routes API", () => {
  beforeAll(async () => {
    await initData();
  });

  describe("GET /routes", () => {
    let res;
    let routes;
    let firstRoute;

    beforeAll(async () => {
      res = await request(app).get("/routes");
      routes = res.body;
      firstRoute = routes[0];
    });

    it("should return 200 status code", () => {
      expect(res.statusCode).toBe(200);
    });

    it("should return an array of routes", () => {
      expect(Array.isArray(routes)).toBe(true);
      expect(routes.length).toBeGreaterThan(0);
    });

    it("should return routes with required fields", () => {
      expect(firstRoute).toHaveProperty("routeId");
      expect(firstRoute).toHaveProperty("routeShortName");
      expect(firstRoute).toHaveProperty("routeLongName");
      expect(firstRoute).toHaveProperty("routeColor");
    });

    it("should filter out internal fields", () => {
      expect(firstRoute).not.toHaveProperty("areaId");
      expect(firstRoute).not.toHaveProperty("routeType");
      expect(firstRoute).not.toHaveProperty("type");
    });

    it("should return valid route IDs as integers", () => {
      routes.forEach((route) => {
        expect(typeof route.routeId).toBe("number");
        expect(Number.isInteger(route.routeId)).toBe(true);
      });
    });

    it("should return valid color codes", () => {
      routes.forEach((route) => {
        if (route.routeColor) {
          expect(route.routeColor).toMatch(/^[0-9A-Fa-f]{6}$/);
        }
      });
    });

    it("should return non-empty route names", () => {
      routes.forEach((route) => {
        expect(route.routeShortName).toBeTruthy();
        expect(route.routeLongName).toBeTruthy();
        expect(typeof route.routeShortName).toBe("string");
        expect(typeof route.routeLongName).toBe("string");
      });
    });
  });

  describe("GET / (Health Check)", () => {
    it("should respond with health status", async () => {
      const res = await request(app).get("/");

      expect(res.statusCode).toBe(200);
      expect(res.body).toEqual({
        status: "OK",
        message: "AuraBus API is alive!",
      });
    });

    it("should return JSON content type", async () => {
      const res = await request(app).get("/");

      expect(res.headers["content-type"]).toMatch(/json/);
    });
  });

  describe("GET /routes - Cache Behavior", () => {
    beforeEach(() => {
      mockRedisClient.get.mockResolvedValue(null);
    });

    it("should serve from cache when Redis returns cached data", async () => {
      const cachedRoutes = [
        {
          routeId: 1,
          routeShortName: "1",
          routeLongName: "Route 1",
          routeColor: "FF0000",
        },
      ];

      mockRedisClient.get.mockResolvedValueOnce(JSON.stringify(cachedRoutes));

      const res = await request(app).get("/routes");

      expect(res.statusCode).toBe(200);
      expect(res.body).toEqual(cachedRoutes);
      expect(mockRedisClient.get).toHaveBeenCalledWith(
        expect.stringContaining("aurabus_cache:/routes"),
      );
    });

    it("should handle Redis cache errors gracefully", async () => {
      mockRedisClient.get.mockRejectedValueOnce(
        new Error("Redis connection error"),
      );

      const res = await request(app).get("/routes");

      expect(res.statusCode).toBe(200);
      expect(Array.isArray(res.body)).toBe(true);
      expect(res.body.length).toBeGreaterThan(0);
    });

    it("should cache response after successful fetch", async () => {
      mockRedisClient.get.mockResolvedValueOnce(null);

      const res = await request(app).get("/routes");

      expect(res.statusCode).toBe(200);
      expect(mockRedisClient.setEx).toHaveBeenCalled();
    });
  });

  describe("GET /routes - Data Validation", () => {
    let routes;

    beforeAll(async () => {
      const res = await request(app).get("/routes");
      routes = res.body;
    });

    it("should have unique route IDs", () => {
      const routeIds = routes.map((r) => r.routeId);
      const uniqueIds = new Set(routeIds);
      expect(routeIds.length).toBe(uniqueIds.size);
    });

    it("should have all routes with positive IDs", () => {
      routes.forEach((route) => {
        expect(route.routeId).toBeGreaterThan(0);
      });
    });

    it("should have consistent data types", () => {
      routes.forEach((route) => {
        expect(typeof route.routeId).toBe("number");
        expect(typeof route.routeShortName).toBe("string");
        expect(typeof route.routeLongName).toBe("string");
        if (route.routeColor) {
          expect(typeof route.routeColor).toBe("string");
        }
      });
    });

    it("should not contain password or sensitive data", () => {
      routes.forEach((route) => {
        expect(route).not.toHaveProperty("password");
        expect(route).not.toHaveProperty("secret");
        expect(route).not.toHaveProperty("token");
      });
    });

    it("should have route short names that are not empty", () => {
      routes.forEach((route) => {
        expect(route.routeShortName.length).toBeGreaterThan(0);
        expect(route.routeShortName.trim()).toBe(route.routeShortName);
      });
    });

    it("should have route long names that are not empty", () => {
      routes.forEach((route) => {
        expect(route.routeLongName.length).toBeGreaterThan(0);
        expect(route.routeLongName.trim()).toBe(route.routeLongName);
      });
    });
  });

  describe("Error Handling", () => {
    it("should return 404 for non-existent routes", async () => {
      const res = await request(app).get("/non-existent-route");

      expect(res.statusCode).toBe(404);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toContain("Not Found");
    });

    it("should handle errors with proper structure", async () => {
      const res = await request(app).get("/invalid/path/that/does/not/exist");

      expect(res.statusCode).toBe(404);
      expect(res.body).toHaveProperty("success");
      expect(res.body).toHaveProperty("message");
      expect(res.body.success).toBe(false);
    });
  });

  describe("Security Headers", () => {
    it("should include security headers", async () => {
      const res = await request(app).get("/routes");

      expect(res.headers).toHaveProperty("x-content-type-options");
      expect(res.headers["x-content-type-options"]).toBe("nosniff");
    });

    it("should allow CORS", async () => {
      const res = await request(app).get("/routes");

      expect(res.headers).toHaveProperty("access-control-allow-origin");
    });
  });
});
