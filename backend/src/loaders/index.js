import { connectDb } from "../config/db.js";
import { initData } from "../utils/staticData.js";
import { seedDatabase } from "../loaders/seeder.js";
import { initRedis } from "../config/redis.js";

export default async () => {
  await connectDb();
  await initRedis();
  await initData();
  await seedDatabase();
};
