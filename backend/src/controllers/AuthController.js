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
  if (fromList) {
    return fromList
      .split(",")
      .map((s) => s.trim())
      .filter(Boolean);
  }

  const single = process.env.GOOGLE_AUTH_CLIENT_ID;
  return single ? [single] : [];
};

const generateAccessToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: "15m" });
};

const generateRefreshToken = (id) => {
  return jwt.sign({ id }, process.env.REFRESH_SECRET, {
    expiresIn: "7d",
    jwtid: crypto.randomUUID(),
  });
};

export const signup = async (req, res, next) => {
  try {
    const validationResponse = sendValidationErrorIfAny(req, res);
    if (validationResponse) return;

    const { firstName, lastName, email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ success: false, message: "Email already in use" });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const newUser = new User({
      firstName,
      lastName,
      email,
      password: hashedPassword,
      authProvider: "local",
    });

    const accessToken = generateAccessToken(newUser._id);
    const refreshToken = generateRefreshToken(newUser._id);

    newUser.refreshToken.push(refreshToken);
    await newUser.save();

    res.status(201).json({
      success: true,
      accessToken,
      refreshToken,
      user: {
        id: newUser._id,
        firstName: newUser.firstName,
        lastName: newUser.lastName,
        email: newUser.email,
      },
    });
  } catch (error) {
    next(error);
  }
};

export const login = async (req, res, next) => {
  try {
    const validationResponse = sendValidationErrorIfAny(req, res);
    if (validationResponse) return;

    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    if (!user.password) {
      return res.status(401).json({
        success: false,
        message: "This account does not support password login",
      });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res
        .status(401)
        .json({ success: false, message: "Wrong password" });
    }

    const accessToken = generateAccessToken(user._id);
    const newRefreshToken = generateRefreshToken(user._id);

    let oldTokens = user.refreshToken || [];

    if (oldTokens.length >= 5) {
      oldTokens.shift();
    }

    user.refreshToken = [...oldTokens, newRefreshToken];
    await user.save();

    res.status(200).json({
      success: true,
      accessToken,
      refreshToken: newRefreshToken,
      user: {
        id: user._id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
      },
    });
  } catch (error) {
    next(error);
  }
};

export const googleLogin = async (req, res, next) => {
  try {
    const validationResponse = sendValidationErrorIfAny(req, res);
    if (validationResponse) return;

    const { idToken } = req.body;

    const audiences = getGoogleAudiences();
    if (audiences.length === 0 && process.env.NODE_ENV === "production") {
      return res.status(500).json({
        success: false,
        message:
          "Google login is not configured (missing GOOGLE_AUTH_CLIENT_ID/GOOGLE_AUTH_CLIENT_IDS)",
      });
    }

    const ticket = await googleClient.verifyIdToken({
      idToken,
      audience: audiences.length > 0 ? audiences : undefined,
    });
    const payload = ticket.getPayload();

    if (!payload?.email) {
      return res
        .status(400)
        .json({ success: false, message: "Google token missing email" });
    }
    if (payload.email_verified === false) {
      return res.status(401).json({
        success: false,
        message: "Google email is not verified",
      });
    }

    const email = payload.email.toLowerCase();
    const googleSub = payload.sub;

    let firstName = payload.given_name;
    let lastName = payload.family_name;
    if ((!firstName || !lastName) && payload.name) {
      const parts = payload.name.split(" ").filter(Boolean);
      firstName = firstName || parts[0] || "";
      lastName = lastName || parts.slice(1).join(" ") || "";
    }

    if (!firstName) firstName = "Google";
    if (!lastName) lastName = "User";

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
      });
    } else {
      if (user.googleSub && user.googleSub !== googleSub) {
        return res.status(403).json({
          success: false,
          message: "Google account mismatch for this email",
        });
      }
      user.googleSub = user.googleSub || googleSub;
      user.authProvider = user.authProvider || "google";
      user.picture = user.picture || payload.picture;
    }

    const accessToken = generateAccessToken(user._id);
    const newRefreshToken = generateRefreshToken(user._id);

    let oldTokens = user.refreshToken || [];
    if (oldTokens.length >= 5) oldTokens.shift();
    user.refreshToken = [...oldTokens, newRefreshToken];
    await user.save();

    res.status(200).json({
      success: true,
      accessToken,
      refreshToken: newRefreshToken,
      user: {
        id: user._id,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
      },
    });
  } catch (error) {
    next(error);
  }
};

export const refreshToken = async (req, res, next) => {
  const validationResponse = sendValidationErrorIfAny(req, res);
  if (validationResponse) return;

  const { refreshToken } = req.body;

  if (!refreshToken) {
    return res
      .status(401)
      .json({ success: false, message: "Refresh Token Required" });
  }

  try {
    const decoded = jwt.verify(refreshToken, process.env.REFRESH_SECRET);

    const user = await User.findById(decoded.id);
    if (!user) {
      return res
        .status(403)
        .json({ success: false, message: "User not found" });
    }

    if (!user.refreshToken.includes(refreshToken)) {
      return res
        .status(403)
        .json({ success: false, message: "Invalid Refresh Token (Revoked)" });
    }

    const oldRefreshToken = req.body.refreshToken;
    user.refreshToken = user.refreshToken.filter((t) => t !== oldRefreshToken);

    const newAccessToken = generateAccessToken(user._id);
    const newRefreshToken = generateRefreshToken(user._id);

    user.refreshToken.push(newRefreshToken);
    await user.save();

    res.json({
      success: true,
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    });
  } catch (error) {
    return res
      .status(403)
      .json({ success: false, message: "Invalid or Expired Refresh Token" });
  }
};

export const logout = async (req, res, next) => {
  const validationResponse = sendValidationErrorIfAny(req, res);
  if (validationResponse) return;

  const { refreshToken } = req.body;

  if (!refreshToken) {
    return res
      .status(400)
      .json({ success: false, message: "Refresh Token Required for Logout" });
  }

  try {
    const user = await User.findOne({ refreshToken: refreshToken });

    if (user) {
      user.refreshToken = user.refreshToken.filter(
        (token) => token !== refreshToken
      );
      await user.save();
    }

    res.sendStatus(204);
  } catch (error) {
    next(error);
  }
};

export const getMe = async (req, res, next) => {
  try {
    const user = await User.findById(req.userId).select(
      "-password -refreshToken"
    );
    if (!user)
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    res.json(user);
  } catch (error) {
    next(error);
  }
};
