import { app } from "./app.js";
import config from "./config/index.js";
import loaders from "./loaders/index.js";

const port = config.api.port;

async function startServer() {
  try {
    await loaders();

    app.listen(port, () => {
      console.log(`
      ################################################
      🛡️  Server listening on port: ${port} 🛡️
      ################################################
      `);
    });
  } catch (err) {
    console.error("❌ Failed to start server:", err);
    process.exit(1);
  }
}

startServer();
