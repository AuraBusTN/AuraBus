import { routes } from "../utils/staticData.js";

export const getAllRoutes = (req, res, next) => {
  try {
    const routesList = Array.from(routes.values()).map(route => ({
      routeId: route.routeId,
      routeShortName: route.routeShortName,
      routeLongName: route.routeLongName,
      routeColor: route.routeColor
    }));
    
    res.status(200).json(routesList);
  } catch (err) {
    next(err);
  }
};