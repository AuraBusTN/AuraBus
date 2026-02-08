import rateLimit from "express-rate-limit";
import RedisStore from "rate-limit-redis";
import { redisClient } from "../config/redis.js";

const isTest = process.env.NODE_ENV === "test";

const safeSendCommand = async (...args) => {
  if (redisClient.isOpen) {
    return redisClient.sendCommand(args);
  }
  return "0000000000000000000000000000000000000000";
};

export const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 300,
  standardHeaders: true,
  legacyHeaders: false,
  store: new RedisStore({
    sendCommand: safeSendCommand,
  }),
  message: {
    success: false,
    message: "Too many requests from this IP, please try again later.",
  },
  skip: (req) => isTest || req.method === "OPTIONS",
});

export const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  standardHeaders: true,
  legacyHeaders: false,
  store: new RedisStore({
    sendCommand: safeSendCommand,
  }),
  message: {
    success: false,
    message: "Too many login attempts, account temporarily locked.",
  },
  skip: () => isTest,
});
