import { User } from "../models/User.js";

export const getLeaderboard = async (req, res, next) => {
  try {
    const currentUserId = req.userId;

    const [topUsers, currentUser, countAbove] = await Promise.all([
      User.find()
        .sort({ points: -1 })
        .limit(10)
        .select("firstName lastName points"),

      User.findById(currentUserId).select("firstName lastName points"),

      User.countDocuments({
        points: { $gt: (await User.findById(currentUserId)).points },
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
