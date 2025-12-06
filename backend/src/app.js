import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import { setupSwagger } from "./swagger.js";
import stopsRouter from "./routes/stops.routes.js";

export const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(morgan("dev"));

setupSwagger(app);

app.get("/", (req, res) => {
  res.status(200).json({ status: "OK", message: "AuraBus API is alive!" });
});

app.use("/stops", stopsRouter);

app.use((err, req, res, next) => {
  console.error("❌ Global Error Handler:", err);

  const statusCode = err.statusCode || 500;
  const message = err.message || "Internal Server Error";
  const showStack =
    process.env.NODE_ENV === "development" || process.env.NODE_ENV === "test";

  res.status(statusCode).json({
    error: true,
    message: message,
    stack: showStack ? err.stack : null,
  });
});
