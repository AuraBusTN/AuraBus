import config from "../config/index.js";
import { stops, routes } from "../utils/staticData.js";
import { simulateOccupancy } from "../utils/simulateOccupancy.js";
import { findBusByIds } from "../repositories/BusRepository.js";

const AUTH_TOKEN = Buffer.from(
  `${config.tnt.username}:${config.tnt.password}`
).toString("base64");

const getFetchOptions = () => ({
  method: "GET",
  headers: {
    Authorization: `Basic ${AUTH_TOKEN}`,
  },
});

export const getStopDetails = async (stopId) => {
  const abortController = new AbortController();
  const TIMEOUT_MS = 5000;
  const timeout = setTimeout(() => abortController.abort(), TIMEOUT_MS);

  try {
    const response = await fetch(
      `${config.tnt.url}/trips_new?stopId=${stopId}&type=U&limit=30`,
      { ...getFetchOptions(), signal: abortController.signal }
    );

    if (!response.ok) {
      throw new Error(
        `External API Error: ${response.status} ${response.statusText}`
      );
    }

    const data = await response.json();
    if (data.error) {
      throw new Error(data.error);
    }

    const busIdsFromApi = data.map((el) => el.matricolaBus).filter(Boolean);

    const busMap = await findBusByIds(busIdsFromApi);

    const trips = [];

    data.forEach((element) => {
      const route = routes.get(element.routeId);
      if (!route) {
        console.warn(
          `⚠️ Unknown routeId received from API: ${element.routeId}`
        );
        return;
      }

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

        lastUpdate: element.lastEventRecivedAt,
        delay: element.delay,
        lastStopId: element.stopLast,
        nextStopId: element.stopNext,
        passedStopCount: element.lastSequenceDetection,

        arrivalTimeScheduled: element.oraArrivoProgrammataAFermataSelezionata,
        arrivalTimeEstimated: element.oraArrivoEffettivaAFermataSelezionata,

        stopTimes: stopTimes.map((st) => ({
          stopId: st.stopId,
          stopName: stops.get(st.stopId)?.stopName || "Unknown",
          arrivalTimeScheduled: st.arrivalTime,
        })),
      });
    });

    trips.sort((a, b) =>
      a.arrivalTimeEstimated.localeCompare(b.arrivalTimeEstimated)
    );

    return trips;
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
