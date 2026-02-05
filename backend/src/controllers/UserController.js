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
