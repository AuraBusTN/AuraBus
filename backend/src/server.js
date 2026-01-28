import { app } from "./app.js";
import config from "./config/index.js";
import loaders from "./loaders/index.js";
import cron from "node-cron";
import { runIngestionJob } from "./services/IngestionService.js";

process.on("uncaughtException", (err) => {
  console.error("UNCAUGHT EXCEPTION! 💥 Shutting down...");
  console.error(err);
  process.exit(1);
});

process.on("unhandledRejection", (err) => {
  console.error("UNHANDLED REJECTION! 💥 Shutting down...");
  console.error(err);
  process.exit(1);
});

async function startServer() {
  try {
    await loaders();

    cron.schedule("*/1 * * * *", () => {
      runIngestionJob();
    });
    console.log("⏰ Ingestion Cron Job scheduled (every 1 minute).");

    app.listen(config.api.port, () => {
      console.log(`
        ################################################
        🛡️  Server listening on port: ${config.api.port} 🛡️
        ################################################
      `);
    });
  } catch (err) {
    console.error("❌ Failed to start server:", err);
    process.exit(1);
  }
}

startServer();
