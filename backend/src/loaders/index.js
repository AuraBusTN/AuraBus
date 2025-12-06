import { connectDb } from "../config/db.js";
import { initData } from "../utils/staticData.js";
import { seedDatabase } from "../loaders/seeder.js";

export default async () => {
  await connectDb();
  console.log("✅ DB Loaded");

  await initData();
  console.log("✅ Static Data Loaded");

  await seedDatabase();
  console.log("✅ Database Seeded");
};
