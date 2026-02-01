import mongoose from "mongoose";

const TripMetricSchema = new mongoose.Schema(
  {
    timestamp: { type: Date, required: true },

    metadata: {
      tripId: { type: String, required: true },
      routeId: { type: String, required: true },
      directionId: { type: Number },
      stopId: { type: Number, required: true },
      type: { type: String },
    },

    delay: { type: Number, required: true },

    ingestedAt: { type: Date, default: Date.now },
  },
  {
    timeseries: {
      timeField: "timestamp",
      metaField: "metadata",
      granularity: "minutes",
    },
    autoCreate: true,
    versionKey: false,
  },
);

TripMetricSchema.index({ "metadata.routeId": 1, timestamp: 1 });

TripMetricSchema.index({ "metadata.tripId": 1, timestamp: 1 });

TripMetricSchema.index({ timestamp: 1 }, { expireAfterSeconds: 15778463 });

export const TripMetric = mongoose.model("TripMetric", TripMetricSchema);
