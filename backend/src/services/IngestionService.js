import axios from "axios";
import { TripMetric } from "../models/TripMetric.js";
import config from "../config/index.js";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const routesPath = path.join(__dirname, "../../data/routes.json");
const routesData = JSON.parse(fs.readFileSync(routesPath, "utf-8"));

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

let lastReadings = new Map();

export const runIngestionJob = async () => {
  const now = new Date();
  const currentHour = now.getHours();

  if (currentHour === 3) {
    if (lastReadings.size > 0) {
      console.log(`🧹 [${now.toISOString()}] Reset memory daily.`);
      lastReadings.clear();
    }
    return;
  }

  if (currentHour >= 1 && currentHour < 5) return;

  console.log(
    `🎯 [${now.toISOString()}] Ingestion Focalized (Next Stop Only)...`,
  );

  if (!config.tnt.url) return;

  const routesToScan = routesData.filter((r) => r.type === "U");
  let totalSaved = 0;
  let totalSkipped = 0;

  for (const route of routesToScan) {
    try {
      const response = await axios.get(`${config.tnt.url}/trips_new`, {
        params: { routeId: route.routeId, type: route.type, limit: 500 },
        auth: { username: config.tnt.username, password: config.tnt.password },
        timeout: 8000,
      });

      const trips = response.data;
      if (!Array.isArray(trips) || trips.length === 0) continue;

      const metricsBatch = [];

      for (const trip of trips) {
        if (!trip.stopTimes || trip.stopTimes.length === 0) continue;

        const currentDelay = trip.delay || 0;
        const lastPassedSequence = trip.lastSequenceDetection || 0;

        const sortedStops = trip.stopTimes.sort(
          (a, b) => a.stopSequence - b.stopSequence,
        );

        const nextStop = sortedStops.find(
          (s) => s.stopSequence > lastPassedSequence,
        );

        if (!nextStop) continue;

        const uniqueKey = `${trip.tripId}_${nextStop.stopId}`;
        const lastRecordedDelay = lastReadings.get(uniqueKey);

        if (
          lastRecordedDelay !== undefined &&
          lastRecordedDelay === currentDelay
        ) {
          totalSkipped++;
          continue;
        }

        lastReadings.set(uniqueKey, currentDelay);

        const [h, m] = nextStop.arrivalTime.split(":");
        const arrivalDate = new Date();
        arrivalDate.setHours(h, m, 0, 0);

        metricsBatch.push({
          timestamp: arrivalDate,
          metadata: {
            tripId: trip.tripId,
            routeId: String(trip.routeId),
            directionId: trip.directionId,
            stopId: nextStop.stopId,
            type: trip.type,
          },
          delay: currentDelay,
          ingestedAt: now,
        });
      }

      if (metricsBatch.length > 0) {
        await TripMetric.insertMany(metricsBatch, { ordered: false });
        totalSaved += metricsBatch.length;
      }

      await sleep(200);
    } catch (error) {
      console.error(`   ❌ Line ${route.routeId}: ${error.message}`);
    }
  }

  console.log(
    `✅ Cycle finished. New records (Next Stop Only): ${totalSaved} | Unchanged: ${totalSkipped}`,
  );
};
