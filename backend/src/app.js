import express from "express";
import { connect } from "mongoose";
import config from "./config.js";
import { stops, routes } from "./data.js";
import { setupSwagger } from "./swagger.js";
import { Bus } from "./models/Bus.js";
import { simulateOccupancy } from "./utils/simulateOccupancy.js";

export const app = express();

setupSwagger(app);

const header = {
  method: "GET",
  headers: {
    Authorization:
      "Basic " +
      Buffer.from(`${config.tnt.username}:${config.tnt.password}`).toString(
        "base64"
      ),
  },
};

export async function connectDb() {
  const { user, pass, host, name } = config.db;
  if (!user || !pass || !host) {
    console.error(
      "Error: Missing MongoDB environment variables (USER, PASSWORD, or HOST)"
    );
    process.exit(1);
  }

  const mongoURI = `mongodb://${user}:${pass}@${host}:27017/${name}?authSource=admin`;

  try {
    await connect(mongoURI);
    console.log("Connected to MongoDB successfully!");
  } catch (err) {
    console.error("Error connecting to MongoDB:", err.message);
    process.exit(1);
  }
}

app.get("/", (req, res) => {
  res.send("Hello World! My AuraBus API is alive!");
});

app.get("/stops", (req, res) => {
  res.json(Array.from(stops.values()));
});

app.get("/stops/:id", async (req, res) => {
  const { id } = req.params;

  try {
    const result = await fetch(
      `${config.tnt.url}/trips_new?stopId=${encodeURIComponent(
        id
      )}&type=U&limit=30`,
      header
    );

    if (!result.ok) {
      return res.status(502).json({
        error: `Failed to fetch data from external API: ${result.status} ${result.statusText}`,
      });
    }

    const data = await result.json();
    if (data.error) {
      return res.status(500).json({ error: data.error });
    }

    const busIdsFromApi = data.map((el) => el.matricolaBus).filter(Boolean);

    const busDetails = await Bus.find({ bus_id: { $in: busIdsFromApi } });

    const busMap = new Map();
    busDetails.forEach((b) => {
      busMap.set(String(b.bus_id), { capacity: b.capacity, type: b.type });
    });

    const trips = [];

    data.forEach((element) => {
      const route = routes.get(element.routeId);

      const extraBusInfo = busMap.get(String(element.matricolaBus)) || {
        capacity: 100,
        type: "standard",
      };

      const stopTimes = Array.isArray(element.stopTimes)
        ? element.stopTimes
        : [];
      const totalStops = stopTimes.length;

      const lastStopId = Number(element.stopLast);
      let currentBusIndex = -1;

      if (lastStopId === 0) {
        currentBusIndex = 0;
      } else {
        currentBusIndex = stopTimes.findIndex((s) => s.stopId === lastStopId);
      }
      const actualCurrentIndex = currentBusIndex === -1 ? 0 : currentBusIndex;
      const targetIndices = stopTimes
        .map((s, i) => (String(s.stopId) === id ? i : -1))
        .filter((i) => i !== -1);

      let targetIndex = targetIndices.find((i) => i >= actualCurrentIndex);

      if (targetIndex === undefined && targetIndices.length > 0) {
        targetIndex = targetIndices[targetIndices.length - 1];
      } else if (targetIndices.length === 0) {
        return;
      }
      const stopsRemaining = targetIndex - actualCurrentIndex;

      const occupancyRealTime = simulateOccupancy(
        new Date(),
        element.tripId,
        extraBusInfo.capacity,
        actualCurrentIndex,
        totalStops,
        route.routeId
      );

      const occupancyExpected = simulateOccupancy(
        new Date(element.oraArrivoEffettivaAFermataSelezionata),
        element.tripId,
        extraBusInfo.capacity,
        targetIndex,
        totalStops,
        route.routeId
      );

      trips.push({
        routeId: route.routeId,
        routeShortName: route.routeShortName,
        routeLongName: route.routeLongName,
        routeColor: route.routeColor,

        busId: element.matricolaBus,
        busCapacity: extraBusInfo.capacity,
        busType: extraBusInfo.type,

        occupancyRealTime,
        occupancyExpected,

        stopsRemaining,
        isTripFinished: stopsRemaining < 0,
        isAtStop: stopsRemaining === 0 && lastStopId !== 0,

        delay: element.delay,
        lastStopId: element.stopLast,
        nextStopId: element.stopNext,

        arrivalTimeScheduled: element.oraArrivoProgrammataAFermataSelezionata,
        arrivalTimeEstimated: element.oraArrivoEffettivaAFermataSelezionata,

        stopTimes: stopTimes.map((st) => ({
          stopId: st.stopId,
          stopName: stops.get(st.stopId)?.stopName || "Unknown",
          arrivalTimeScheduled: st.arrivalTime,
          arrivalTimeEstimated: st.departureTime,
        })),
      });
    });

    trips.sort((a, b) =>
      a.arrivalTimeEstimated.localeCompare(b.arrivalTimeEstimated)
    );

    res.json(trips);
  } catch (err) {
    console.error("Error fetching or processing data:", err);
    res
      .status(502)
      .json({ error: "Failed to fetch or process data from external API." });
  }
});
