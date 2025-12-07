import { app } from "./app.js";
import config from "./config/index.js";
import loaders from "./loaders/index.js";

process.on("uncaughtException", (err) => {
  console.error("UNCAUGHT EXCEPTION! 💥 Shutting down...");
  console.error(err);
  process.exit(1);
});

async function startServer() {
  process.on("unhandledRejection", (err) => {
    console.error("UNHANDLED REJECTION! 💥 Shutting down...");
    console.error(err);
    process.exit(1);
  });

  try {
    await loaders();
    const server = app.listen(config.api.port, () => {
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
