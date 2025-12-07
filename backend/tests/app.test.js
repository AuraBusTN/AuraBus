import { jest } from "@jest/globals";
import request from "supertest";

const mockStops = new Map([
  [1, { stopId: 1, stopName: "Stazione Centrale" }],
  [2, { stopId: 2, stopName: "Piazza Duomo" }],
]);
const mockRoutes = new Map([
  [
    1,
    {
      routeId: 1,
      routeShortName: "5",
      routeLongName: "Circolare",
      routeColor: "#FF0000",
    },
  ],
]);

jest.unstable_mockModule("../src/utils/staticData.js", () => ({
  initData: jest.fn(),
  stops: mockStops,
  routes: mockRoutes,
}));

const mockBusFind = jest.fn();
jest.unstable_mockModule("../src/models/Bus.js", () => ({
  Bus: {
    find: mockBusFind,
  },
}));

jest.unstable_mockModule("mongoose", () => ({
  connect: jest.fn().mockResolvedValue(true),
  Schema: class {},
  model: jest.fn(),
}));

global.fetch = jest.fn();

const { app } = await import("../src/app.js");

describe("Integration Test: AuraBus API", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    global.fetch.mockReset();
  });

  describe("GET /", () => {
    it("Should respond with status 200 and a welcome message", async () => {
      const res = await request(app).get("/");
      expect(res.statusCode).toBe(200);
      expect(res.text).toContain("AuraBus API is alive");
    });
  });

  describe("Global 404 Handler", () => {
    it("Should return 404 JSON for non-existent routes", async () => {
      const res = await request(app).get("/questo-endpoint-non-esiste");

      expect(res.statusCode).toBe(404);
      expect(res.body.error).toBe(true);
      expect(res.body.message).toMatch(/Not Found/);
    });
  });

  describe("GET /stops/:id (Logic Trip & Occupancy)", () => {
    const stopId = 1;

    const baseApiData = {
      tripId: 1,
      routeId: 1,
      matricolaBus: 100,
      stopLast: 1,
      stopNext: 2,
      delay: 120,
      oraArrivoProgrammataAFermataSelezionata: "2024-12-03T10:00:00Z",
      oraArrivoEffettivaAFermataSelezionata: "2024-12-03T10:02:00Z",
      lastEventRecivedAt: "2024-12-03T09:59:00Z",
      stopTimes: [
        { stopId: 1, arrivalTime: "10:00:00" },
        { stopId: 2, arrivalTime: "10:10:00" },
      ],
    };

    it("Should correctly process data and calculate occupancy", async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        json: async () => [baseApiData],
      });

      mockBusFind.mockResolvedValue([
        { bus_id: 100, capacity: 150, type: "articulated" },
      ]);

      const res = await request(app).get(`/stops/${String(stopId)}`);

      expect(res.statusCode).toBe(200);
      expect(Array.isArray(res.body)).toBe(true);
      expect(res.body).toHaveLength(1);

      const trip = res.body[0];
      expect(trip.busId).toBe(100);
      expect(trip.busCapacity).toBe(150);
      expect(trip.routeShortName).toBe("5");
    });

    it("Should correctly handle a bus not found in the DB (default fallback)", async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        json: async () => [baseApiData],
      });

      mockBusFind.mockResolvedValue([]);

      const res = await request(app).get(`/stops/${stopId}`);

      expect(res.statusCode).toBe(200);
      const trip = res.body[0];
      expect(trip.busCapacity).toBe(100);
      expect(trip.busType).toBe("standard");
    });

    it("Should ignore trips with unknown routeIds (Service Resilience)", async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        json: async () => [{ ...baseApiData, tripId: 999, routeId: 999 }],
      });

      mockBusFind.mockResolvedValue([]);

      const res = await request(app).get(`/stops/${stopId}`);

      expect(res.statusCode).toBe(200);
      expect(res.body).toHaveLength(0);
    });

    it("Should return empty array if external API returns empty list", async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        json: async () => [],
      });

      const res = await request(app).get(`/stops/${stopId}`);

      expect(res.statusCode).toBe(200);
      expect(res.body).toEqual([]);
    });

    it("Should return 500 if the external API fails (503)", async () => {
      global.fetch.mockResolvedValue({
        ok: false,
        status: 503,
        statusText: "Service Unavailable",
      });

      const res = await request(app).get(`/stops/${stopId}`);
      expect(res.statusCode).toBe(500);
      expect(res.body.error).toBe(true);
      expect(res.body.message).toMatch(/External API Error/);
    });

    it("Should return 400 if the stop ID is not numeric", async () => {
      const res = await request(app).get("/stops/abc");
      expect(res.statusCode).toBe(400);
      expect(res.body.error).toBe(true);
      expect(res.body.message).toBe("Invalid stop ID");
    });

    it("Should handle unexpected network errors in fetch", async () => {
      global.fetch.mockRejectedValue(new Error("Network Error"));

      const res = await request(app).get(`/stops/${stopId}`);
      expect(res.statusCode).toBe(500);
      expect(res.body.error).toBe(true);
      expect(res.body.message).toBeDefined();
    });
  });
});
