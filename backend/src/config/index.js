import dotenv from "dotenv";
import path from "path";
import fs from "fs";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const envPath = path.join(__dirname, "../../.env");

if (fs.existsSync(envPath)) {
  console.log(`✅ .env found at: ${envPath}`);
  dotenv.config({ path: envPath });
} else {
  console.warn(`⚠️  WARNING: .env file NOT found at: ${envPath}`);
}

const config = {
  api: {
    port: process.env.API_PORT || 8888,
    baseUrl: process.env.API_BASE_URL || "http://localhost",
  },
  db: {
    host: process.env.MONGO_HOST || "localhost",
    user: process.env.MONGO_USER,
    pass: process.env.MONGO_PASSWORD,
    name: "aurabus_db",
  },
  tnt: {
    url: process.env.API_URL,
    username: process.env.API_USER,
    password: process.env.API_PASSWORD,
  },
};

const missingTntConfig = [];
if (!config.tnt.url) missingTntConfig.push("API_URL");
if (!config.tnt.username) missingTntConfig.push("API_USER");
if (!config.tnt.password) missingTntConfig.push("API_PASSWORD");
if (!config.db.user) missingTntConfig.push("MONGO_USER");
if (!config.db.pass) missingTntConfig.push("MONGO_PASSWORD");

if (missingTntConfig.length > 0) {
  throw new Error(
    `❌ CRITICAL ERROR: Missing required TNT API configuration: ${missingTntConfig.join(
      ", "
    )}`
  );
}

export default config;
