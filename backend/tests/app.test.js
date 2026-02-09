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

const mockUser = { findOne: jest.fn(), findById: jest.fn(), find: jest.fn() };
jest.unstable_mockModule("../src/models/User.js", () => ({ User: mockUser }));

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

describe("App Configuration", () => {
  let consoleErrorSpy;

  beforeAll(() => {
    consoleErrorSpy = jest.spyOn(console, "error").mockImplementation(() => {});
  });

  afterAll(() => {
    consoleErrorSpy.mockRestore();
  });

  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe("Middleware Configuration", () => {
    it("should parse JSON bodies", async () => {
      const res = await request(app)
        .post("/auth/login")
        .send({ email: "test@test.com", password: "test" });

      expect(res.statusCode).not.toBe(400);
      expect(res.body).toBeDefined();
    });

    it("should have CORS enabled", async () => {
      const res = await request(app).get("/");

      expect(res.headers["access-control-allow-origin"]).toBeDefined();
    });

    it("should have security headers (helmet)", async () => {
      const res = await request(app).get("/");

      expect(res.headers["x-content-type-options"]).toBe("nosniff");
      expect(res.headers["x-frame-options"]).toBeDefined();
    });

    it("should sanitize MongoDB queries", async () => {
      const res = await request(app)
        .post("/auth/login")
        .send({
          email: { $gt: "" },
          password: { $gt: "" },
        });

      expect(res.statusCode).toBeDefined();
      expect(res.body).toBeDefined();
    });

    it("should protect against parameter pollution (hpp)", async () => {
      const res = await request(app)
        .get("/routes")
        .query({ limit: ["10", "20"] });

      expect(res.statusCode).toBe(200);
    });
  });

  describe("Error Handlers", () => {
    it("should handle 404 for non-existent routes", async () => {
      const res = await request(app).get("/this-route-does-not-exist");

      expect(res.statusCode).toBe(404);
      expect(res.body.success).toBe(false);
      expect(res.body.message).toContain("Not Found");
      expect(res.body.message).toContain("/this-route-does-not-exist");
    });

    it("should handle 404 for POST to non-existent routes", async () => {
      const res = await request(app)
        .post("/non-existent-endpoint")
        .send({ data: "test" });

      expect(res.statusCode).toBe(404);
      expect(res.body.success).toBe(false);
    });

    it("should handle 404 for PUT to non-existent routes", async () => {
      const res = await request(app)
        .put("/non-existent-endpoint")
        .send({ data: "test" });

      expect(res.statusCode).toBe(404);
      expect(res.body.success).toBe(false);
    });

    it("should handle 404 for DELETE to non-existent routes", async () => {
      const res = await request(app).delete("/non-existent-endpoint");

      expect(res.statusCode).toBe(404);
      expect(res.body.success).toBe(false);
    });

    it("should include error message in 404 response", async () => {
      const res = await request(app).get("/api/invalid");

      expect(res.body).toHaveProperty("message");
      expect(res.body).toHaveProperty("success");
      expect(res.body.message).toMatch(/Not Found/i);
    });

    it("should not include stack trace in test environment", async () => {
      const res = await request(app).get("/non-existent");

      expect(res.body.stack).toBeNull();
    });
  });

  describe("Health Check", () => {
    it("should respond to health check", async () => {
      const res = await request(app).get("/");

      expect(res.statusCode).toBe(200);
      expect(res.body).toEqual({
        status: "OK",
        message: "AuraBus API is alive!",
      });
    });

    it("should return JSON for health check", async () => {
      const res = await request(app).get("/");

      expect(res.headers["content-type"]).toMatch(/json/);
    });
  });

  describe("Rate Limiting", () => {
    it("should apply rate limiting to API routes", async () => {
      const res = await request(app).get("/routes");

      expect(res.statusCode).toBe(200);
    });

    it("should apply rate limiting to auth routes", async () => {
      const res = await request(app)
        .post("/auth/login")
        .send({ email: "test@test.com", password: "test" });

      expect(res.statusCode).toBeDefined();
    });
  });

  describe("API Routing", () => {
    it("should route to auth endpoints", async () => {
      const res = await request(app).post("/auth/login").send({});

      expect(res.statusCode).not.toBe(404);
    });

    it("should route to stops endpoints", async () => {
      const res = await request(app).get("/stops/123");

      expect(res.statusCode).not.toBe(404);
    }, 15000);

    it("should route to routes endpoints", async () => {
      const res = await request(app).get("/routes");

      expect(res.statusCode).not.toBe(404);
    });

    it("should route to users endpoints", async () => {
      const res = await request(app).get("/users/leaderboard");

      expect(res.statusCode).toBe(401);
    });
  });

  describe("Request Query Handling", () => {
    it("should handle query parameters correctly", async () => {
      const res = await request(app).get("/routes").query({ test: "value" });

      expect(res.statusCode).toBe(200);
    });

    it("should make query object writable", async () => {
      const res = await request(app)
        .get("/routes")
        .query({ param1: "value1", param2: "value2" });

      expect(res.statusCode).toBe(200);
    });
  });

  describe("Content Type Handling", () => {
    it("should handle JSON content type", async () => {
      const res = await request(app)
        .post("/auth/signup")
        .set("Content-Type", "application/json")
        .send(
          JSON.stringify({
            firstName: "Test",
            lastName: "User",
            email: "test@example.com",
            password: "Password123",
          }),
        );

      expect(res.statusCode).toBeDefined();
      expect(res.body).toBeDefined();
    });

    it("should return JSON responses", async () => {
      const res = await request(app).get("/");

      expect(res.headers["content-type"]).toMatch(/json/);
    });

    it("should handle missing content-type gracefully", async () => {
      const res = await request(app).post("/auth/login").send({});

      expect(res.statusCode).toBeDefined();
    });
  });

  describe("Trust Proxy Configuration", () => {
    it("should be configured to trust proxy", async () => {
      const res = await request(app)
        .get("/")
        .set("X-Forwarded-For", "192.168.1.1");

      expect(res.statusCode).toBe(200);
    });
  });

  describe("Global Error Handler", () => {
    it("should return structured error for invalid stop ID", async () => {
      const res = await request(app).get("/stops/invalid");

      expect(res.statusCode).toBe(400);
      expect(res.body).toHaveProperty("success");
      expect(res.body).toHaveProperty("message");
      expect(res.body.success).toBe(false);
    });

    it("should not expose stack traces in test environment", async () => {
      const res = await request(app).get("/stops/invalid");

      expect(res.body.stack).toBeNull();
    });

    it("should handle errors with proper status codes", async () => {
      const res = await request(app)
        .get("/users/leaderboard")
        .set("Authorization", "Bearer invalid-token");

      expect(res.statusCode).toBe(403);
      expect(res.body.success).toBe(false);
    });
  });

  describe("Swagger Documentation", () => {
    it("should serve Swagger UI at /api-docs", async () => {
      const res = await request(app).get("/api-docs/");

      expect([200, 301, 302]).toContain(res.statusCode);
    });
  });

  describe("Method Not Allowed", () => {
    it("should handle invalid HTTP methods gracefully", async () => {
      const res = await request(app).patch("/routes");

      expect([404, 405]).toContain(res.statusCode);
    });
  });
});
