import { redisClient } from "../config/redis.js";

export const cacheMiddleware =
  (duration = 3600) =>
  async (req, res, next) => {
    const key = `aurabus_cache:${req.originalUrl || req.url}`;

    try {
      const cachedData = await redisClient.get(key);

      if (cachedData) {
        console.log(`⚡ Hit cache for ${key}`);
        return res.status(200).json(JSON.parse(cachedData));
      }

      console.log(`Miss cache for ${key}`);

      const originalJson = res.json;
      res.json = (body) => {
        redisClient.setEx(key, duration, JSON.stringify(body));
        originalJson.call(res, body);
      };

      next();
    } catch (err) {
      console.error("Redis Cache Error:", err);
      next();
    }
  };
