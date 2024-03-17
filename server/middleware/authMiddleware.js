const jwt = require("jsonwebtoken");

const authMiddleware = (req, res, next) => {
  const { token } = req.header("x-auth-token");
  if (!token) return res.status(401).send("Access denied. No token provided");

  try {
    const decoded = jwt.verify(token, config.get("jwtPrivateKey")); // change this later
    req.user = decoded;
    next();
  } catch (error) {
    res.status.send("Invalid token");
  }
};

module.exports = authMiddleware;
