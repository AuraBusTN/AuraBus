import { User } from "../models/User.js";
import jwt from "jsonwebtoken";
import bcrypt from "bcryptjs";
import { validationResult } from "express-validator";
import { OAuth2Client } from "google-auth-library";
import crypto from "crypto";

const googleClient = new OAuth2Client();

const sendValidationErrorIfAny = (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const first = errors.array({ onlyFirstError: true })[0];
    return res.status(400).json({
      success: false,
      message: first?.msg ?? "Validation error",
      errors: errors.array(),
    });
  }
  return null;
};

const getGoogleAudiences = () => {
  const fromList = process.env.GOOGLE_AUTH_CLIENT_IDS;
  if (fromList) return fromList.split(",").map(s => s.trim()).filter(Boolean);
  const single = process.env.GOOGLE_AUTH_CLIENT_ID;
  return single ? [single] : [];
};

const generateAccessToken = (id) =>
  jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: "1h" });

const generateRefreshToken = (id) =>
  jwt.sign({ id }, process.env.REFRESH_SECRET, {
    expiresIn: process.env.REFRESH_EXPIRES_IN || "7d",
    jwtid: crypto.randomUUID(),
  });

// --- Signup ---
export const signup = async (req, res, next) => {
  try {
    if (sendValidationErrorIfAny(req, res)) return;

    const { firstName, lastName, password, email: rawEmail } = req.body;
    const email = rawEmail.toLowerCase();

    if (await User.findOne({ email })) {
      return res.status(400).json({ success: false, message: "Email already in use" });
    }

    const hashedPassword = await bcrypt.hash(password, await bcrypt.genSalt(10));

    const newUser = new User({
      firstName,
      lastName,
      email,
      password: hashedPassword,
      authProvider: "local",
      refreshToken: [],
    });

    const accessToken = generateAccessToken(newUser.id);
    const refreshToken = generateRefreshToken(newUser.id);

    newUser.refreshToken.push(refreshToken);
    await newUser.save();

    res.status(201).json({
      success: true,
      accessToken,
      refreshToken,
      user: {
        id: newUser.id,
        firstName: newUser.firstName,
        lastName: newUser.lastName,
        email: newUser.email,
        points: newUser.points,
        picture: newUser.picture,
      },
    });
  } catch (error) {
    next(error);
  }
};

// --- Login ---
export const login = async (req, res, next) => {
  try {
    if (sendValidationErrorIfAny(req, res)) return;

    const { email: rawEmail, password } = req.body;
    const email = rawEmail.toLowerCase();

    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ success: false, message: "User not found" });

    if (!user.password) return res.status(401).json({
      success: false,
      message: "This account does not support password login",
    });

    if (!await bcrypt.compare(password, user.password)) {
      return res.status(401).json({ success: false, message: "Wrong password" });
    }

    const accessToken = generateAccessToken(user.id);
    const refreshToken = generateRefreshToken(user.id);

    user.refreshToken = user.refreshToken || [];
    if (user.refreshToken.length >= 5) user.refreshToken.shift(); // mantieni massimo 5
    user.refreshToken.push(refreshToken);
    await user.save();

    res.status(200).json({
      success: true,
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        points: user.points,
        picture: user.picture,
      },
    });
  } catch (error) {
    next(error);
  }
};

export const googleLogin = async (req, res, next) => {
  try {
    if (sendValidationErrorIfAny(req, res)) return;

    const { idToken } = req.body;
    const audiences = getGoogleAudiences();
    const allowMissingAudienceCheck =
      process.env.NODE_ENV === "test" ||
      process.env.GOOGLE_AUTH_ALLOW_MISSING_AUDIENCE === "true";

    if (audiences.length === 0 && !allowMissingAudienceCheck) {
      return res.status(500).json({
        success: false,
        message: "Google login not configured. Set GOOGLE_AUTH_CLIENT_ID.",
      });
    }

    const ticket = await googleClient.verifyIdToken({
      idToken,
      audience: audiences.length > 0 ? audiences : undefined,
    });

    const payload = ticket.getPayload();
    if (!payload?.email) return res.status(400).json({ success: false, message: "Google token missing email" });
    if (payload.email_verified === false) return res.status(401).json({ success: false, message: "Google email not verified" });

    const email = payload.email.toLowerCase();
    const googleSub = payload.sub;
    let firstName = payload.given_name || "Google";
    let lastName = payload.family_name || "User";

    if ((!payload.given_name || !payload.family_name) && payload.name) {
      const parts = payload.name.split(" ").filter(Boolean);
      firstName = firstName || parts[0];
      lastName = lastName || parts.slice(1).join(" ");
    }

    let user = await User.findOne({ email });
    if (!user) {
      user = new User({
        firstName,
        lastName,
        email,
        authProvider: "google",
        googleSub,
        picture: payload.picture,
        password: null,
        refreshToken: [],
      });
    } else {
      if (user.googleSub && user.googleSub !== googleSub) {
        return res.status(403).json({ success: false, message: "Google account mismatch" });
      }
      user.googleSub = user.googleSub || googleSub;
      user.authProvider = user.authProvider || "google";
      user.picture = user.picture || payload.picture;
    }

    const accessToken = generateAccessToken(user.id);
    const refreshToken = generateRefreshToken(user.id);

    user.refreshToken = user.refreshToken || [];
    if (user.refreshToken.length >= 5) user.refreshToken.shift();
    user.refreshToken.push(refreshToken);
    await user.save();

    res.status(200).json({
      success: true,
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        points: user.points,
        picture: user.picture,
      },
    });
  } catch (error) {
    next(error);
  }
};

export const refreshToken = async (req, res, next) => {
  const { refreshToken } = req.body;
  if (!refreshToken) return res.status(400).json({ success: false, message: "Refresh Token required" });

  try {
    const decoded = jwt.verify(refreshToken, process.env.REFRESH_SECRET);
    const user = await User.findById(decoded.id);
    if (!user) return res.status(403).json({ success: false, message: "User not found" });

    if (!user.refreshToken.includes(refreshToken)) {
      return res.status(403).json({ success: false, message: "Invalid Refresh Token" });
    }

    user.refreshToken = user.refreshToken.filter(t => t !== refreshToken);

    const newAccessToken = generateAccessToken(user.id);
    const newRefreshToken = generateRefreshToken(user.id);

    user.refreshToken.push(newRefreshToken);
    await user.save();

    res.json({ success: true, accessToken: newAccessToken, refreshToken: newRefreshToken });
  } catch (error) {
    res.status(403).json({ success: false, message: "Invalid or expired Refresh Token" });
  }
};

export const logout = async (req, res, next) => {
  const { refreshToken } = req.body;
  if (!refreshToken) return res.status(400).json({ success: false, message: "Refresh Token required" });

  try {
    const user = await User.findOne({ refreshToken });
    if (user) {
      user.refreshToken = user.refreshToken.filter(t => t !== refreshToken);
      await user.save();
    }
    res.sendStatus(204);
  } catch (error) {
    next(error);
  }
};

export const getMe = async (req, res, next) => {
  try {
    const user = await User.findById(req.userId).select("-password -refreshToken");
    if (!user) return res.status(404).json({ success: false, message: "User not found" });
    res.status(200).json({ success: true, user });
  } catch (error) {
    next(error);
  }
};