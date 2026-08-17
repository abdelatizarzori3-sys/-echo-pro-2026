const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client');
const { AppError } = require('./error.middleware');
const prisma = new PrismaClient();

const auth = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) throw new AppError('Access denied. No token provided.', 401);
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await prisma.user.findUnique({ where: { id: decoded.id } });
    if (!user) throw new AppError('User not found.', 401);
    req.user = user;
    next();
  } catch (err) {
    next(new AppError('Invalid token.', 401));
  }
};

module.exports = { auth };
