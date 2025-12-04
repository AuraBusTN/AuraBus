import { app, connectDb } from "./app.js";
import { initData } from "./data.js";
import config from "./config.js";
import { seedDatabase } from "./seedBus.js";

const port = config.api.port;

async function startServer() {
  try {
    await Promise.all([connectDb(), initData(), seedDatabase()]);

    app.listen(port, () => {
      console.log(`Server API listening on port ${port}`);
    });
  } catch (err) {
    console.error("Failed to start server:", err);
    process.exit(1);
  }
}

startServer();
