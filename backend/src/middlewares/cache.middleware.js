import { redisClient } from "../config/redis.js";

export const cacheMiddleware =
  (duration = 3600) =>
  async (req, res, next) => {
    const key = `aurabus_cache:${req.originalUrl || req.url}`;

    try {
      const cachedData = await redisClient.get(key);

      if (cachedData) {
        try {
          const parsed = JSON.parse(cachedData);
          if (parsed && parsed.status && parsed.body) {
            console.log(`⚡ Hit cache for ${key} (Status: ${parsed.status})`);
            return res.status(parsed.status).json(parsed.body);
          }
          console.log(`⚡ Hit cache for ${key} (Legacy)`);
          return res.status(200).json(parsed);
        } catch (parseErr) {
          console.error("Cache parse error, proceeding without cache");
        }
      }

      console.log(`Miss cache for ${key}`);

      const originalJson = res.json;
      res.json = (body) => {
        const status = res.statusCode || 200;

        if (status >= 200 && status < 400) {
          const payload = { status, body };
          redisClient
            .setEx(key, duration, JSON.stringify(payload))
            .catch((err) =>
              console.error(`⚠️ Cache write failed: ${err.message}`),
            );
        }

        return originalJson.call(res, body);
      };

      next();
    } catch (err) {
      console.error("Redis Cache Middleware Error:", err);
      next();
    }
  };
