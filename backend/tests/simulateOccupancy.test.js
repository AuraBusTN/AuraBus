import { jest } from "@jest/globals";

jest.unstable_mockModule("../src/utils/routeConfig.js", () => ({
  getRouteConfig: jest.fn(),
}));

let simulateOccupancy;
let getRouteConfig;

describe("simulateOccupancy Logic", () => {
  beforeAll(async () => {
    const occupancyModule = await import("../src/utils/SimulateOccupancy.js");
    simulateOccupancy = occupancyModule.simulateOccupancy;

    const configModule = await import("../src/utils/routeConfig.js");
    getRouteConfig = configModule.getRouteConfig;
  });

  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("Dovrebbe restituire la struttura dati corretta (percentage, passengers, level)", () => {
    getRouteConfig.mockReturnValue({ profile: "standard" });

    const result = simulateOccupancy(
      new Date(),
      "trip123",
      100,
      5,
      20,
      "routeA"
    );

    expect(result).toHaveProperty("percentage");
    expect(result).toHaveProperty("passengers");
    expect(result).toHaveProperty("level");
    expect(typeof result.percentage).toBe("number");
    expect(["green", "orange", "red"]).toContain(result.level);
  });

  test("Dovrebbe gestire il profilo 'university' con picchi specifici", () => {
    getRouteConfig.mockReturnValue({
      profile: "university",
      peakLocation: 0.5,
    });
    const mondayMorning = new Date("2023-10-23T08:00:00");

    const result = simulateOccupancy(
      mondayMorning,
      "tripUni",
      100,
      10,
      20,
      "routeUni"
    );
    // In orario di punta ci aspettiamo passeggeri
    expect(result.passengers).toBeGreaterThan(0);
  });

  test("Dovrebbe restituire livello 'green' e carico basso in orari non di punta", () => {
    getRouteConfig.mockReturnValue({ profile: "standard" });
    const sundayNight = new Date("2023-10-22T23:00:00");

    const result = simulateOccupancy(
      sundayNight,
      "tripQuiet",
      100,
      2,
      20,
      "routeStd"
    );

    expect(result.level).toBe("green");
    expect(result.percentage).toBeLessThan(50);
  });

  test("Dovrebbe assegnare correttamente i colori in base alla percentuale", () => {
    getRouteConfig.mockReturnValue({ profile: "accumulator" });

    for (let i = 0; i < 5; i++) {
      const result = simulateOccupancy(
        new Date(),
        `trip-${i}`,
        100,
        15,
        20,
        "routeTest"
      );

      if (result.percentage > 80) {
        expect(result.level).toBe("red");
      } else if (result.percentage > 50) {
        expect(result.level).toBe("orange");
      } else {
        expect(result.level).toBe("green");
      }
    }
  });

  test("Dovrebbe limitare (clamp) i valori tra 0% e 100%", () => {
    getRouteConfig.mockReturnValue({ profile: "standard" });
    const result = simulateOccupancy(
      new Date(),
      "tripClamp",
      100,
      10,
      20,
      "r1"
    );

    expect(result.percentage).toBeGreaterThanOrEqual(0);
    expect(result.percentage).toBeLessThanOrEqual(100);
    expect(result.passengers).toBeGreaterThanOrEqual(0);
    expect(result.passengers).toBeLessThanOrEqual(100);
  });

  test("Dovrebbe gestire correttamente la prima fermata (stopIndex 0)", () => {
    getRouteConfig.mockReturnValue({ profile: "standard" });
    const result = simulateOccupancy(new Date(), "tripStart", 100, 0, 20, "r1");

    expect(result.percentage).toBe(10);
  });
});
