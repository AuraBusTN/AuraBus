import { routes } from "../utils/staticData.js";

export const getRoutes = async (req, res, next) => {
  const areaid = Number(req.params.areaid);

  if (isNaN(areaid)) {
    const error = new Error("Invalid areaID");
    error.statusCode = 400;
    return next(error);
  }

  try {
    // NON ridefinire "routes", usa l'importato
    const filteredRoutes = Array.from(routes.values()).filter(
      route => route.areaId === areaid
    );

    res.status(200).json(filteredRoutes);
  } catch (err) {
    next(err);
  }
};
