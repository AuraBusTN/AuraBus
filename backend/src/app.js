import express from "express";
import { setupSwagger } from "./swagger.js";
import stopsRouter from "./routes/stops.routes.js";

export const app = express();

setupSwagger(app);

app.get("/", (req, res) => {
  res.send("Hello World! My AuraBus API is alive!");
});

app.use("/stops", stopsRouter);