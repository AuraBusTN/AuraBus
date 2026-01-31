import jwt from "jsonwebtoken";

export const verifyToken = (req, res, next) => {
  let token = req.headers["x-access-token"] || req.headers["authorization"];

  if (token && token.startsWith("Bearer ")) {
    token = token.slice(7, token.length);
  }

  if (!token) {
    return res
      .status(401)
      .json({ success: false, message: "No token provided." });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      if (err.name === "TokenExpiredError") {
        return res.status(401).json({
          success: false,
          message: "TokenExpired",
          expiredAt: err.expiredAt,
        });
      }
      return res
        .status(403)
        .json({ success: false, message: "Token not valid" });
    }

    req.userId = decoded.id;
    next();
  });
};
