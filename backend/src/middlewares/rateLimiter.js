import rateLimit from "express-rate-limit";
import RedisStore from "rate-limit-redis";
import { redisClient } from "../config/redis.js";

const isTest = process.env.NODE_ENV === "test";

const safeSendCommand = async (...args) => {
  if (!redisClient.isOpen) {
    return "0000000000000000000000000000000000000000";
  }
  return redisClient.sendCommand(args);
};

const createRedisLimiter = (options) =>
  rateLimit({
    windowMs: options.windowMs,
    max: options.max,
    standardHeaders: true,
    legacyHeaders: false,
    passOnStoreError: true,
    store: new RedisStore({
      sendCommand: safeSendCommand,
    }),
    message: options.message,
    skip: options.skip,
  });

export const apiLimiter = createRedisLimiter({
  windowMs: 15 * 60 * 1000,
  max: 300,
  message: {
    success: false,
    message: "Too many requests from this IP, please try again later.",
  },
  skip: (req) => isTest || req.method === "OPTIONS",
});

export const authLimiter = createRedisLimiter({
  windowMs: 15 * 60 * 1000,
  max: 20,
  message: {
    success: false,
    message: "Too many login attempts, account temporarily locked.",
  },
  skip: () => isTest,
});
