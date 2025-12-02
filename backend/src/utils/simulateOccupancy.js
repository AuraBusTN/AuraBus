import { getRouteConfig } from "./routeConfig.js";

export const simulateOccupancy = (
  targetTime = new Date(),
  tripId = "",
  capacity = 100,
  stopIndex = 0,
  totalStops = 25,
  routeId = "0"
) => {
  const dateObj = new Date(targetTime);
  const hour = dateObj.getHours();
  const minutes = dateObj.getMinutes();
  const decimalTime = hour + minutes / 60;
  const dayOfWeek = dateObj.getDay();

  const config = getRouteConfig(routeId);
  
  const progress = totalStops > 1 ? stopIndex / (totalStops - 1) : 0;

  let routeCurve = 0;

  switch (config.profile) {
    case "accumulator":
      routeCurve = 0.2 + (progress * 0.8); 
      break;

    case "university":
      const center = config.peakLocation;
      const width = 0.25;
      routeCurve = Math.exp(-Math.pow(progress - center, 2) / (2 * Math.pow(width, 2)));
      routeCurve = 0.2 + (routeCurve * 0.8);
      break;

    case "flat_high":
      routeCurve = 0.6 + (Math.sin(progress * Math.PI) * 0.4);
      break;
      
    case "draining":
      routeCurve = 1.0 - (progress * 0.8);
      break;

    case "standard":
    default:
      routeCurve = Math.sin(progress * Math.PI);
      break;
  }

  const getPeakFactor = (current, peak, width) => {
    return Math.exp(-Math.pow(current - peak, 2) / (2 * Math.pow(width, 2)));
  };

  let timeFactor = 0.1;

  // Peak hours differ for university routes
  if (config.profile === "university") {
    const morning = getPeakFactor(decimalTime, 8.0, 1.0) * 1.1; 
    const evening = getPeakFactor(decimalTime, 18.0, 1.0) * 1.1;
    timeFactor = Math.max(morning, evening, 0.1);
  } else {
    const morning = getPeakFactor(decimalTime, 7.5, 1.5);
    const lunch = getPeakFactor(decimalTime, 13.5, 1.5) * 0.8;
    const evening = getPeakFactor(decimalTime, 17.5, 2.0) * 0.9;
    timeFactor = Math.max(morning, lunch, evening, 0.05);
  }

  if (dayOfWeek === 0) timeFactor *= 1.1; // Sunday
  if (dayOfWeek === 1) timeFactor *= 0.8; // Monday
  if (dayOfWeek === 2) timeFactor *= 0.9; // Tuesday
  if (dayOfWeek === 3) timeFactor *= 1.0; // Wednesday
  if (dayOfWeek === 4) timeFactor *= 0.9; // Thursday
  if (dayOfWeek === 5) timeFactor *= 0.8; // Friday
  if (dayOfWeek === 6) timeFactor *= 0.9; // Saturday

  // Combine the line shape with the time factor
  // Weighing timeFactor more to reflect its importance
  let rawLoad = (timeFactor * 0.6) + (routeCurve * 0.4 * timeFactor * 2);
  
  const dateString = dateObj.toISOString().split('T')[0];
  const seedString = `${tripId}-${dateString}`;
  let hash = 0;
  for (let i = 0; i < seedString.length; i++) {
    hash = ((hash << 5) - hash) + seedString.charCodeAt(i);
    hash |= 0;
  }
  const randomVariance = ((Math.abs(hash) % 100) / 500) - 0.1;

  let finalLoadFactor = rawLoad + randomVariance;

  // Clamp e Output
  if (stopIndex === 0 && config.profile !== "flat_high") finalLoadFactor = 0.1;
  
  finalLoadFactor = Math.min(Math.max(finalLoadFactor, 0), 1);

  const estimatedPassengers = Math.floor(capacity * finalLoadFactor);
  const percentage = Math.round(finalLoadFactor * 100);

  let statusColor = "green";
  if (percentage > 50) statusColor = "orange";
  if (percentage > 80) statusColor = "red";

  return {
    percentage: percentage,
    passengers: estimatedPassengers,
    level: statusColor
  };
};