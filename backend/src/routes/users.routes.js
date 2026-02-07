import express from "express";
import { body } from "express-validator";
import {
  getLeaderboard,
  getFavoriteRoutes,
  updateFavoriteRoutes,
} from "../controllers/UserController.js";
import { verifyToken } from "../middlewares/auth.middleware.js";

const router = express.Router();

router.get("/leaderboard", verifyToken, getLeaderboard);
router.get("/favorite-routes", verifyToken, getFavoriteRoutes);
router.post(
  "/favorite-routes",
  verifyToken,
  [
    body("favoriteRoutes")
      .isArray()
      .withMessage("favoriteRoutes must be an array"),
    body("favoriteRoutes.*")
      .isInt({ gt: 0 })
      .withMessage("Each route ID must be a positive integer"),
  ],
  updateFavoriteRoutes,
);

export default router;
