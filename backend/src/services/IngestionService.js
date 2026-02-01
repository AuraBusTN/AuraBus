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
    `🎯 [${now.toISOString()}] Ingestion (Cluster + Terminus Fix)...`,
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
      const pendingUpdates = new Map();

      for (const trip of trips) {
        if (!trip.stopTimes || trip.stopTimes.length === 0) continue;

        const currentDelay = trip.delay || 0;
        const lastPassedSequence = trip.lastSequenceDetection || 0;

        const sortedStops = trip.stopTimes.sort(
          (a, b) => a.stopSequence - b.stopSequence,
        );

        let nextStopIndex = sortedStops.findIndex(
          (s) => s.stopSequence > lastPassedSequence,
        );

        if (nextStopIndex === -1) {
          const lastStop = sortedStops[sortedStops.length - 1];
          if (lastStop.stopSequence === lastPassedSequence) {
            nextStopIndex = sortedStops.length - 1;
          } else {
            continue;
          }
        }

        const stopsToSave = [];

        const primaryNextStop = sortedStops[nextStopIndex];
        stopsToSave.push(primaryNextStop);

        let lookAhead = 1;
        while (nextStopIndex + lookAhead < sortedStops.length) {
          const candidateStop = sortedStops[nextStopIndex + lookAhead];
          if (candidateStop.arrivalTime === primaryNextStop.arrivalTime) {
            stopsToSave.push(candidateStop);
            lookAhead++;
          } else {
            break;
          }
        }

        for (const stop of stopsToSave) {
          const uniqueKey = `${trip.tripId}_${stop.stopId}`;
          const lastRecordedDelay = lastReadings.get(uniqueKey);

          if (
            lastRecordedDelay !== undefined &&
            lastRecordedDelay === currentDelay
          ) {
            totalSkipped++;
            continue;
          }

          pendingUpdates.set(uniqueKey, currentDelay);

          const [hStr, mStr] = stop.arrivalTime.split(":");
          const h = parseInt(hStr, 10);
          const m = parseInt(mStr, 10);

          let arrivalDate = new Date(now);
          arrivalDate.setHours(h, m, 0, 0);

          if (currentHour > 20 && h < 4) {
            arrivalDate.setDate(arrivalDate.getDate() + 1);
          }

          metricsBatch.push({
            timestamp: arrivalDate,
            metadata: {
              tripId: trip.tripId,
              routeId: String(trip.routeId),
              directionId: trip.directionId,
              stopId: stop.stopId,
              type: trip.type,
            },
            delay: currentDelay,
            ingestedAt: now,
          });
        }
      }

      if (metricsBatch.length > 0) {
        await TripMetric.insertMany(metricsBatch, { ordered: false });
        for (const [key, val] of pendingUpdates) {
          lastReadings.set(key, val);
        }
        totalSaved += metricsBatch.length;
      }

      await sleep(200);
    } catch (error) {
      console.error(`   ❌ Line ${route.routeId}: ${error.message}`);
    }
  }

  console.log(
    `✅ Cycle finished. New: ${totalSaved} | Skipped: ${totalSkipped}`,
  );
};
