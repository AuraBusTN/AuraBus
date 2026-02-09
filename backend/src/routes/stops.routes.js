import express from "express";
import { getStop } from "../controllers/StopController.js";
import { cacheMiddleware } from "../middlewares/cache.middleware.js";

const router = express.Router();

router.get("/:id", cacheMiddleware(60), getStop);

export default router;
