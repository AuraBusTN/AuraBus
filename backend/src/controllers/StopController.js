import { getStopDetails } from "../services/StopService.js";

export const getStop = async (req, res, next) => {
  const stopId = Number(req.params.id);
  if (isNaN(stopId)) {
    const error = new Error("Invalid stop ID");
    error.statusCode = 400;
    return next(error);
  }

  try {
    const trips = await getStopDetails(stopId);
    res.json(trips);
  } catch (err) {
    next(err);
  }
};
