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

let isJobRunning = false;

async function startServer() {
  try {
    await loaders();

    cron.schedule("*/1 * * * *", async () => {
      if (isJobRunning) {
        console.warn("⚠️  Previous Job still running. Skip.");
        return;
      }

      isJobRunning = true;

      try {
        await runIngestionJob();
      } catch (error) {
        console.error("❌ Critical Error inside the Cron Job:", error);
      } finally {
        isJobRunning = false;
      }
    });

    console.log("⏰ Ingestion Cron Job scheduled (Safe Mode).");

    app.listen(config.api.port || config.port || 8888, () => {
      console.log(`
        ################################################
        🛡️  Server listening on port: ${config.api.port || config.port || 8888} 🛡️
        ################################################
      `);
    });
  } catch (err) {
    console.error("❌ Error starting server:", err);
    process.exit(1);
  }
}

startServer();
