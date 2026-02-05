import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import mongoSanitize from "express-mongo-sanitize";
import { setupSwagger } from "./swagger.js";
import stopsRouter from "./routes/stops.routes.js";
import authRouter from "./routes/auth.routes.js";
import usersRouter from "./routes/users.routes.js";
import { apiLimiter, authLimiter } from "./middlewares/rateLimiter.js";

export const app = express();

setupSwagger(app);
app.use(helmet());
app.use(cors());

app.use(morgan("dev"));
app.use(express.json());
app.use((req, res, next) => {
  if (req.query) {
    Object.defineProperty(req, "query", {
      value: req.query,
      writable: true,
      configurable: true,
      enumerable: true,
    });
  }
  next();
});

app.use(mongoSanitize());

app.get("/", (req, res) => {
  res.status(200).json({ status: "OK", message: "AuraBus API is alive!" });
});

app.use("/auth", authLimiter, authRouter);
app.use("/stops", apiLimiter, stopsRouter);
app.use("/users", apiLimiter, usersRouter);

app.use((req, res, next) => {
  const error = new Error(`Not Found - ${req.originalUrl}`);
  error.statusCode = 404;
  next(error);
});

app.use((err, req, res, next) => {
  console.error("❌ Global Error Handler:", err);
  const statusCode = err.statusCode || 500;
  res.status(statusCode).json({
    success: false,
    message: err.message || "Internal Server Error",
    stack: process.env.NODE_ENV === "development" ? err.stack : null,
  });
});
