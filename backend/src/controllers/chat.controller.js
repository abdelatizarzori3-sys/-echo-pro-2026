const { PrismaClient } = require('@prisma/client');
const { v4: uuidv4 } = require('uuid');
const aiService = require('../services/ai.service');
const logger = require('../utils/logger');

const prisma = new PrismaClient();

const chatController = {
  getMessages: async (req, res) => {
    const { sessionId } = req.query;
    const where = sessionId ? { sessionId, userId: req.user.id } : { userId: req.user.id };
    const messages = await prisma.message.findMany({
      where,
      orderBy: { createdAt: 'asc' },
      take: 100,
    });
    res.json({ success: true, data: messages });
  },

  sendMessage: async (req, res) => {
    const { text, sessionId } = req.body;
    if (!text?.trim()) throw new Error('Text is required');

    const sid = sessionId || uuidv4();

    // Ensure session exists
    await prisma.session.upsert({
      where: { id: sid },
      update: { updatedAt: new Date() },
      create: { id: sid, userId: req.user.id, title: text.slice(0, 50) },
    });

    // Save user message
    await prisma.message.create({
      data: { content: text.trim(), sender: 'user', sessionId: sid, userId: req.user.id },
    });

    // Get AI response
    const history = await prisma.message.findMany({
      where: { sessionId: sid },
      orderBy: { createdAt: 'desc' },
      take: 10,
    });

    const reply = await aiService.sendMessage(text.trim(), history.reverse());

    // Save AI response
    const aiMsg = await prisma.message.create({
      data: {
        content: reply,
        sender: 'agent',
        sessionId: sid,
        userId: req.user.id,
        metadata: { model: 'moonshot-v1-8k' },
      },
    });

    res.json({ success: true, data: { reply, message: aiMsg, sessionId: sid } });
  },

  clearChat: async (req, res) => {
    const { sessionId } = req.query;
    const where = sessionId
      ? { sessionId, userId: req.user.id }
      : { userId: req.user.id };
    await prisma.message.deleteMany({ where });
    res.json({ success: true });
  },

  getSessions: async (req, res) => {
    const sessions = await prisma.session.findMany({
      where: { userId: req.user.id },
      orderBy: { updatedAt: 'desc' },
      include: { _count: { select: { messages: true } } },
    });
    res.json({ success: true, data: sessions });
  },
};

module.exports = chatController;
