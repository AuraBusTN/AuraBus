import axios from "axios";
import { TripMetric } from "../models/TripMetric.js";
import config from "../config/index.js";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { redisClient } from "../config/redis.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const routesPath = path.join(__dirname, "../../data/routes.json");
const routesData = JSON.parse(fs.readFileSync(routesPath, "utf-8"));

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const getTodayDateString = () => {
  return new Date().toISOString().split("T")[0];
};

export const runIngestionJob = async () => {
  const now = new Date();
  const currentHour = now.getHours();

  const todayStr = getTodayDateString();
  if (currentHour >= 1 && currentHour < 5) return;

  console.log(`🎯 [${now.toISOString()}] Ingestion running...`);

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
      const pendingUpdates = [];
      const processingQueue = [];
      const redisKeysToFetch = [];

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
          const uniqueKey = `ingest:${todayStr}:${trip.tripId}:${stop.stopId}`;
          redisKeysToFetch.push(uniqueKey);
          processingQueue.push({
            uniqueKey,
            trip,
            stop,
            currentDelay,
          });
        }
      }

      let cachedValues = [];
      if (redisKeysToFetch.length > 0) {
        try {
          cachedValues = await redisClient.mGet(redisKeysToFetch);
        } catch (err) {
          console.warn(`⚠️ Redis batch read failed, proceeding as new data.`);
          cachedValues = new Array(redisKeysToFetch.length).fill(null);
        }
      }

      for (let i = 0; i < processingQueue.length; i++) {
        const item = processingQueue[i];
        const lastRecordedDelay = cachedValues[i];

        if (
          lastRecordedDelay !== null &&
          parseInt(lastRecordedDelay) === item.currentDelay
        ) {
          totalSkipped++;
          continue;
        }

        pendingUpdates.push({
          key: item.uniqueKey,
          val: String(item.currentDelay),
        });

        const [hStr, mStr] = item.stop.arrivalTime.split(":");
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
            tripId: item.trip.tripId,
            routeId: String(item.trip.routeId),
            directionId: item.trip.directionId,
            stopId: item.stop.stopId,
            type: item.trip.type,
          },
          delay: item.currentDelay,
          ingestedAt: now,
        });
      }

      if (metricsBatch.length > 0) {
        await TripMetric.insertMany(metricsBatch, { ordered: false });
        totalSaved += metricsBatch.length;

        try {
          const pipeline = redisClient.multi();
          pendingUpdates.forEach((item) => {
            pipeline.set(item.key, item.val, { EX: 86400 });
          });
          await pipeline.exec();
        } catch (redisErr) {
          console.error(
            `⚠️ Data saved to DB but Redis update failed: ${redisErr.message}`,
          );
        }
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
