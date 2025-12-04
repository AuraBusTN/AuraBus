import mongoose from "mongoose";

const busSchema = new mongoose.Schema({
  bus_id: { type: Number, required: true, unique: true, index: true },
  capacity: { type: Number, required: true },
  type: {
    type: String,
    enum: ["mini", "standard_single", "standard", "articulated"],
    default: "standard",
  },
});

export const Bus = mongoose.model("Bus", busSchema);
