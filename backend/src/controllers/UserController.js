import { User } from "../models/User.js";

export const getLeaderboard = async (req, res, next) => {
  try {
    const currentUserId = req.userId;

    const currentUser = await User.findById(currentUserId).select(
      "firstName lastName points",
    );

    if (!currentUser) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    const [topUsers, countAbove] = await Promise.all([
      User.find()
        .sort({ points: -1 })
        .limit(10)
        .select("firstName lastName points"),

      User.countDocuments({
        points: { $gt: currentUser.points },
      }),
    ]);

    const myRank = countAbove + 1;

    const sanitizedTopUsers = topUsers.map((u, index) => ({
      id: u.id,
      firstName: u.firstName,
      lastName: u.lastName,
      points: u.points,
      rank: index + 1,
    }));

    const isMeInTop10 = sanitizedTopUsers.some((u) => u.id === currentUserId);

    const meSanitized = {
      id: currentUser.id,
      firstName: currentUser.firstName,
      lastName: currentUser.lastName,
      points: currentUser.points,
      rank: myRank,
    };

    res.status(200).json({
      success: true,
      topUsers: sanitizedTopUsers,
      me: isMeInTop10 ? null : meSanitized,
    });
  } catch (error) {
    next(error);
  }
};

export const getFavoriteRoutes = async (req, res, next) => {
  try {
    const userId = req.userId;

    const user = await User.findById(userId).select("favoriteRoutes");

    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    res.status(200).json({
      success: true,
      favoriteRoutes: user.favoriteRoutes || [],
    });
  } catch (error) {
    next(error);
  }
};

export const updateFavoriteRoutes = async (req, res, next) => {
  try {
    const userId = req.userId;
    const { favoriteRoutes } = req.body;

    if (favoriteRoutes === undefined) {
      return res.status(400).json({
        success: false,
        message: "favoriteRoutes field is required",
      });
    }

    if (!Array.isArray(favoriteRoutes)) {
      return res.status(400).json({
        success: false,
        message: "favoriteRoutes must be an array",
      });
    }

    if (
      !favoriteRoutes.every((route) => Number.isInteger(route) && route > 0)
    ) {
      return res.status(400).json({
        success: false,
        message: "Each route ID must be a positive integer",
      });
    }

    const uniqueRoutes = [...new Set(favoriteRoutes)];

    const user = await User.findByIdAndUpdate(
      userId,
      { favoriteRoutes: uniqueRoutes },
      { new: true, runValidators: true, select: "favoriteRoutes" },
    );

    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }

    res.status(200).json({
      success: true,
      message: "Favorite routes updated successfully",
      favoriteRoutes: user.favoriteRoutes,
    });
  } catch (error) {
    if (error.name === "ValidationError") {
      return res.status(400).json({
        success: false,
        message: error.message,
      });
    }
    next(error);
  }
};
