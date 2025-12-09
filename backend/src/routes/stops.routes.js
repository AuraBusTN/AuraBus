import express from "express";
import { getStop } from "../controllers/StopController.js";

const router = express.Router();

router.get("/:id", getStop);

export default router;
