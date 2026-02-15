import express from "express";
import { getAllRoutes } from "../controllers/RouteController.js";
import { cacheMiddleware } from "../middlewares/cache.middleware.js";

const router = express.Router();

router.get("/", cacheMiddleware(3600 * 24), getAllRoutes);

export default router;
