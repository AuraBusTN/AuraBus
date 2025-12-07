import { connectDb } from "../config/db.js";
import { initData } from "../utils/staticData.js";
import { seedDatabase } from "../loaders/seeder.js";

export default async () => {
  await connectDb();
  await initData();
  await seedDatabase();
};
