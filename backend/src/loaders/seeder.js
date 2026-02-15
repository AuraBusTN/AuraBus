import fs from "fs";
import { Bus } from "../models/Bus.js";

export async function seedDatabase() {
  try {
    const count = await Bus.countDocuments();

    if (count === 0) {
      console.log("🌱 No buses found in DB. Starting seeding process...");
      const busesJson = await fs.promises.readFile(
        new URL("../../data/buses.json", import.meta.url),
        "utf-8"
      );

      const buses = JSON.parse(busesJson);

      await Bus.insertMany(buses);

      console.log(
        `✅ Database seeded successfully with ${buses.length} buses!`
      );
    } else {
      console.log("ℹ️ Database already contains data. Skipping seed.");
    }
  } catch (err) {
    console.error("❌ Error seeding database:", err);
  }
}
