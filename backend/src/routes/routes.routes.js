import express from "express";
import { getRoutes } from "../controllers/RoutesController.js";

const router = express.Router();

router.get("/:areaid", getRoutes);

export default router;
