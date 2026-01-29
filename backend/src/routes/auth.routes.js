import express from "express";
import { body } from "express-validator";
import {
  signup,
  login,
  googleLogin,
  refreshToken,
  logout,
  getMe,
} from "../controllers/AuthController.js";
import { verifyToken } from "../middlewares/auth.middleware.js";

const router = express.Router();

router.post(
  "/signup",
  [
    body("email").isEmail().withMessage("Insert a valid email"),
    body("password")
      .isLength({ min: 6 })
      .withMessage("Password of at least 6 characters"),
    body("firstName").notEmpty().withMessage("First name is required"),
    body("lastName").notEmpty().withMessage("Last name is required"),
  ],
  signup
);

router.post(
  "/login",
  [
    body("email").isEmail().withMessage("Email is required"),
    body("password").notEmpty().withMessage("Password is required"),
  ],
  login
);

router.post(
  "/google",
  [body("idToken").notEmpty().withMessage("Google ID token is required")],
  googleLogin
);

router.post(
  "/refresh-token",
  [body("refreshToken").notEmpty().withMessage("Refresh Token is required")],
  refreshToken
);

router.post(
  "/logout",
  [
    body("refreshToken")
      .notEmpty()
      .withMessage("Refresh Token is required for logout"),
  ],
  logout
);

router.get("/me", verifyToken, getMe);

export default router;
