/**
 * JWT Authentication Middleware
 */

const jwt = require('jsonwebtoken');
const env = require('../config/env');
const logger = require('../config/logger');

const verifyToken = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    logger.warn(`❌ No token provided from ${req.ip}`);
    return res.status(401).json({ error: 'No token provided' });
  }

  try {
    const decoded = jwt.verify(token, env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    logger.error('❌ Invalid token:', error.message);
    return res.status(403).json({ error: 'Invalid token' });
  }
};

const generateToken = (userId) => {
  return jwt.sign({ userId }, env.JWT_SECRET, { expiresIn: '7d' });
};

module.exports = { verifyToken, generateToken };
