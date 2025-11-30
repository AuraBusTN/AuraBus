export const simulateOccupancy = (
  targetTime = new Date(),
  tripId = "",
  capacity = 100,
  stopIndex = 0,
  totalStops = 25
) => {
  const dateObj = new Date(targetTime);
  const hour = dateObj.getHours();
  const minutes = dateObj.getMinutes();
  const decimalTime = hour + minutes / 60;
  const dayOfWeek = dateObj.getDay();

  const getPeakFactor = (current, peak, width) => {
    return Math.exp(-Math.pow(current - peak, 2) / (2 * Math.pow(width, 2)));
  };

  // Peak hours factors
  const morningPeak = getPeakFactor(decimalTime, 7.5, 1.5) * 1.0;
  const lunchPeak = getPeakFactor(decimalTime, 13.5, 1.5) * 0.8;
  const eveningPeak = getPeakFactor(decimalTime, 17.5, 2.0) * 0.9;
  const baseLoad = 0.05;

  let timeFactor = Math.max(morningPeak, lunchPeak, eveningPeak, baseLoad);

  // day of week adjustments
  if (dayOfWeek === 0) timeFactor *= 1.1; // Sunday
  if (dayOfWeek === 1) timeFactor *= 0.8; // Monday
  if (dayOfWeek === 2) timeFactor *= 0.9; // Tuesday
  if (dayOfWeek === 3) timeFactor *= 1.0; // Wednesday
  if (dayOfWeek === 4) timeFactor *= 0.9; // Thursday
  if (dayOfWeek === 5) timeFactor *= 0.8; // Friday
  if (dayOfWeek === 6) timeFactor *= 0.9; // Saturday

  // Sinusoidal route position factor
  // The further along the route, the less likely it is to be full (generally)
  // This creates a wave that starts at 0, peaks at mid-route, and goes back to 0 at the end
  const progress = Math.min(stopIndex / totalStops, 1);
  const routeCurve = Math.sin(progress * Math.PI);

  // Combine time factor and route curve
  // Weigh time factor more heavily
  let rawLoad = timeFactor * 0.7 + routeCurve * 0.3 * timeFactor;

  // Create a unique seed combining trip ID and day of the year
  // This ensures that "that" bus on "that" day always has the same crowd if you reload the page
  const dateString = dateObj.toISOString().split("T")[0]; // e.g., "2023-10-25"
  const seedString = `${tripId}-${dateString}`;

  let hash = 0;
  for (let i = 0; i < seedString.length; i++) {
    hash = (hash << 5) - hash + seedString.charCodeAt(i);
    hash |= 0;
  }
  const randomVariance = (Math.abs(hash) % 100) / 500 - 0.1;

  // Apply variance
  let finalLoadFactor = rawLoad + randomVariance;

  // Initial stop is always empty or almost empty
  if (stopIndex === 0) finalLoadFactor = 0;

  finalLoadFactor = Math.min(Math.max(finalLoadFactor, 0), 1);

  const estimatedPassengers = Math.floor(capacity * finalLoadFactor);
  const percentage = Math.round(finalLoadFactor * 100);

  let statusColor = "green";
  if (percentage > 50) statusColor = "orange";
  if (percentage > 80) statusColor = "red";

  return {
    percentage: percentage,
    passengers: estimatedPassengers,
    level: statusColor,
  };
};
