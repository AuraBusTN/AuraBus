import express from "express";
import { getAllRoutes } from "../controllers/RouteController.js";

const router = express.Router();

router.get("/", getAllRoutes);

export default router;