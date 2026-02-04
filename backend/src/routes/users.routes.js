import express from "express";
import { getLeaderboard } from "../controllers/UserController.js";
import { verifyToken } from "../middlewares/auth.middleware.js";

const router = express.Router();

router.get("/leaderboard", verifyToken, getLeaderboard);

export default router;
