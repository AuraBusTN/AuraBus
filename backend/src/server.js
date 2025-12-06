// backend/src/server.js
import { app } from "./app.js";
import config from "./config/index.js";
import loaders from "./loaders/index.js";

async function startServer() {
  await loaders();

  const server = app.listen(config.api.port, () => {
    console.log(`
      ################################################
      🛡️  Server listening on port: ${config.api.port} 🛡️
      ################################################
    `);
  });

  process.on("unhandledRejection", (err) => {
    console.error("UNHANDLED REJECTION! 💥 Shutting down...");
    console.error(err);
    server.close(() => process.exit(1));
  });

  process.on("uncaughtException", (err) => {
    console.error("UNCAUGHT EXCEPTION! 💥 Shutting down...");
    console.error(err);
    process.exit(1);
  });
}

startServer();
