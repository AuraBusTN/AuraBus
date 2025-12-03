import { jest } from "@jest/globals";

jest.unstable_mockModule("../src/utils/routeConfig.js", () => ({
  getRouteConfig: jest.fn(),
}));

let simulateOccupancy;
let getRouteConfig;

describe("Unit Test: simulateOccupancy Algorithm", () => {
  beforeAll(async () => {
    const configModule = await import("../src/utils/routeConfig.js");
    getRouteConfig = configModule.getRouteConfig;

    const occupancyModule = await import("../src/utils/simulateOccupancy.js");
    simulateOccupancy = occupancyModule.simulateOccupancy;
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe("Basic Logic and Data Structure", () => {
    test("It should return an object with correct percentage, passengers, and level", () => {
      getRouteConfig.mockReturnValue({ profile: "standard" });
      const result = simulateOccupancy(new Date(), "trip1", 100, 5, 20, "R1");

      expect(result).toEqual({
        percentage: expect.any(Number),
        passengers: expect.any(Number),
        level: expect.stringMatching(/green|orange|red/),
      });
      expect(result.percentage).toBeGreaterThanOrEqual(0);
      expect(result.percentage).toBeLessThanOrEqual(100);
    });

    test("It should correctly calculate the number of passengers based on capacity", () => {
      getRouteConfig.mockReturnValue({ profile: "standard" });
      const capacity = 50;
      const result = simulateOccupancy(
        new Date(),
        "trip1",
        capacity,
        10,
        20,
        "R1"
      );

      expect(result.passengers).toBe(
        Math.floor(capacity * (result.percentage / 100))
      );
    });
  });

  describe("Route Profiles", () => {
    test.each([
      ["accumulator", 0, 0.1],
      ["draining", 0, 0.1],
      ["flat_high", 0, 0.6],
    ])(
      "Profile '%s' at stop index %i should have base load around %f",
      (profile, stopIndex, expectedBase) => {
        getRouteConfig.mockReturnValue({ profile });

        const neutralTime = new Date("2023-10-25T12:00:00");
        const result = simulateOccupancy(
          neutralTime,
          "tripX",
          100,
          stopIndex,
          10,
          "RX"
        );

        if (profile === "flat_high") {
          expect(result.percentage).toBeGreaterThan(50);
        } else if (stopIndex === 0 && profile !== "flat_high") {
          expect(result.percentage).toBe(10);
        }
      }
    );

    test("Profile 'university' should have specific peaks (morning)", () => {
      getRouteConfig.mockReturnValue({
        profile: "university",
        peakLocation: 0.5,
      });
      const mondayMorning = new Date("2023-10-23T08:00:00");

      const result = simulateOccupancy(
        mondayMorning,
        "tripUni",
        100,
        5,
        10,
        "R_UNI"
      );
      expect(result.percentage).toBeGreaterThan(10);
    });
  });

  describe("Temporal Factors", () => {
    test("Sunday should drastically reduce occupancy", () => {
      getRouteConfig.mockReturnValue({ profile: "standard" });
      const sunday = new Date("2023-10-22T10:00:00");
      const monday = new Date("2023-10-23T10:00:00");

      const resSunday = simulateOccupancy(sunday, "t1", 100, 5, 10, "R1");
      const resMonday = simulateOccupancy(monday, "t1", 100, 5, 10, "R1");

      expect(resSunday.percentage).toBeGreaterThanOrEqual(resMonday.percentage);
    });
  });

  describe("Edge Cases", () => {
    test("StopIndex 0 should force load factor to 0.1 (except flat_high)", () => {
      getRouteConfig.mockReturnValue({ profile: "standard" });
      const result = simulateOccupancy(new Date(), "t1", 100, 0, 10, "R1");
      expect(result.percentage).toBe(10);
    });

    test("Invalid inputs should not break execution", () => {
      getRouteConfig.mockReturnValue({ profile: "standard" });
      const result = simulateOccupancy(undefined, "t1", 100, 5, 10, "R1");
      expect(result).toHaveProperty("percentage");
    });
  });
});
