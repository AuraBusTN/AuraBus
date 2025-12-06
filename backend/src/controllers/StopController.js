import { getStopDetails } from "../services/StopService.js";

export const getStop = async (req, res, next) => {
  const stopId = Number(req.params.id);
  if (isNaN(stopId)) {
    return res.status(400).json({ error: "Invalid stop ID" });
  }

  try {
    const trips = await getStopDetails(stopId);
    res.json(trips);
  } catch (err) {
    next(err);
  }
};
