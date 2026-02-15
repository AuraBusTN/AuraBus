import config from "../config/index.js";
import { stops, routes } from "../utils/staticData.js";
import { simulateOccupancy } from "../utils/simulateOccupancy.js";
import { findBusByIds } from "../repositories/BusRepository.js";

const getFetchOptions = () => {
  const authToken = Buffer.from(
    `${config.tnt.username}:${config.tnt.password}`,
  ).toString("base64");

  return {
    method: "GET",
    headers: {
      Authorization: `Basic ${authToken}`,
    },
  };
};

export const getStopDetails = async (stopId) => {
  const abortController = new AbortController();
  const TIMEOUT_MS = 5000;
  const timeout = setTimeout(() => abortController.abort(), TIMEOUT_MS);

  try {
    const response = await fetch(
      `${config.tnt.url}/trips_new?stopId=${stopId}&type=U&limit=30`,
      { ...getFetchOptions(), signal: abortController.signal },
    );

    if (!response.ok) {
      throw new Error(
        `External API Error: ${response.status} ${response.statusText}`,
      );
    }

    const data = await response.json();
    if (data.error) {
      throw new Error(data.error);
    }

    const busIdsFromApi = data.map((el) => el.matricolaBus).filter(Boolean);
    const busMap = await findBusByIds(busIdsFromApi);

    const trips = await Promise.all(
      data.map(async (element) => {
        const route = routes.get(element.routeId);
        if (!route) {
          console.warn(
            `⚠️ Unknown routeId received from API: ${element.routeId}`,
          );
          return null;
        }

        const directionId = element.directionId;

        const extraBusInfo = busMap.get(element.matricolaBus) || {
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
          .map((s, i) => (s.stopId === stopId ? i : -1))
          .filter((i) => i !== -1);

        let targetIndex = targetIndices.find((i) => i >= actualCurrentIndex);

        if (targetIndex === undefined && targetIndices.length > 0) {
          targetIndex = targetIndices[targetIndices.length - 1];
        } else if (targetIndices.length === 0) {
          return null;
        }

        let index = 0;
        let bodyRequest = [];

        stopTimes.forEach((st) => {
          if (st.stopId) {
            let hour = 0;
            const timeVal = st.arrivalTime;
            if (typeof timeVal === "string" && timeVal.includes(":")) {
              hour = parseInt(timeVal.split(":")[0], 10);
            } else {
              hour = Math.floor(Number(timeVal) / 3600);
            }
            const day_of_week = (new Date().getDay() + 6) % 7;

            if (index > actualCurrentIndex) {
              bodyRequest.push({
                stop_encoded: parseInt(st.stopId, 10),
                hour: parseInt(hour, 10),
                day_of_week: parseInt(day_of_week, 10),
                directionId: parseInt(directionId, 10) || 0,
              });
            }
            index++;
          }
        });

        let newStopTimes = [...stopTimes];
        if (config.prediction?.url && bodyRequest.length > 0) {
          try {
            const predResponse = await fetch(
              `${config.prediction.url}/predict`,
              {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                  route_encoded: parseInt(route.routeId, 10),
                  current_delay: parseInt(element.delay, 10) || 0,
                  future_stops: bodyRequest,
                }),
              },
            );

            if (predResponse.ok) {
              const responseData = await predResponse.json();
              const predictions = responseData.predictions || [];
              newStopTimes = stopTimes.map((st) => {
                const prediction = predictions.find(
                  (p) => p.stop_encoded === Number(st.stopId),
                );
                return {
                  ...st,
                  delayPredicted: prediction
                    ? prediction.predicted_delay
                    : null,
                };
              });
            }
          } catch (err) {
            console.warn(`⚠️ Prediction service failed: ${err.message}`);
          }
        }

        const occupancyRealTime = simulateOccupancy(
          new Date(),
          element.tripId,
          extraBusInfo.capacity,
          actualCurrentIndex,
          totalStops,
          route.routeId,
        );

        const occupancyExpected = simulateOccupancy(
          new Date(element.oraArrivoEffettivaAFermataSelezionata),
          element.tripId,
          extraBusInfo.capacity,
          targetIndex,
          totalStops,
          route.routeId,
        );

        return {
          routeId: route.routeId,
          routeShortName: route.routeShortName,
          routeLongName: route.routeLongName,
          routeColor: route.routeColor,

          busId: element.matricolaBus,
          busCapacity: extraBusInfo.capacity,
          busType: extraBusInfo.type,

          occupancy: {
            realTime: occupancyRealTime,
            expected: occupancyExpected,
          },

          lastUpdate: element.lastEventRecivedAt,
          delay: element.delay,
          lastStopId: element.stopLast,
          nextStopId: element.stopNext,
          passedStopCount: element.lastSequenceDetection,

          arrivalTimeScheduled: element.oraArrivoProgrammataAFermataSelezionata,
          arrivalTimeEstimated: element.oraArrivoEffettivaAFermataSelezionata,

          stopTimes: newStopTimes.map((st) => ({
            stopId: st.stopId,
            stopName: stops.get(st.stopId)?.stopName || "Unknown",
            arrivalTimeScheduled: st.arrivalTime,
            delayPredicted: st.delayPredicted ?? null,
          })),
        };
      }),
    );

    const validTrips = trips.filter((t) => t !== null);

    validTrips.sort((a, b) =>
      a.arrivalTimeEstimated.localeCompare(b.arrivalTimeEstimated),
    );

    return validTrips;
  } catch (error) {
    if (error.name === "AbortError") {
      console.error(`⏱️ Timeout request to TNT API after ${TIMEOUT_MS}ms`);
      throw new Error("External service unavailable (Timeout)");
    }
    throw error;
  } finally {
    clearTimeout(timeout);
  }
};
