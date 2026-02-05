import express from "express";
import {
  getLeaderboard,
  getFavoriteRoutes,
  updateFavoriteRoutes,
} from "../controllers/UserController.js";
import { verifyToken } from "../middlewares/auth.middleware.js";

const router = express.Router();

router.get("/leaderboard", verifyToken, getLeaderboard);
router.get("/favorite-routes", verifyToken, getFavoriteRoutes);
router.post("/favorite-routes", verifyToken, updateFavoriteRoutes);

export default router;
