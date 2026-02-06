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
  });
});
