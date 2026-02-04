import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    email: { type: String, required: true, unique: true, index: true },
    password: { type: String, required: false },
    authProvider: {
      type: String,
      enum: ["local", "google"],
      default: "local",
      index: true,
    },
    googleSub: { type: String, required: false, index: true },
    picture: { type: String, required: false },
    refreshToken: { type: [String], default: [] },
    points: { type: Number, default: 0, index: true },
  },
  {
    timestamps: true,
    toJSON: {
      virtuals: true,
      versionKey: true,
      transform: function (doc, ret) {
        delete ret._id;
        delete ret.password;
        delete ret.refreshToken;
        delete ret.__v;
      },
    },
  },
);

export const User = mongoose.model("User", userSchema);
