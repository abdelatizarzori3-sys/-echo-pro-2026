/**
 * Prisma Database Seeder
 * Run: npx prisma db seed
 */
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database...');

  // Create demo user
  const hashedPassword = await bcrypt.hash('demo123456', 12);
  const demoUser = await prisma.user.upsert({
    where: { email: 'demo@echo.pro' },
    update: {},
    create: {
      email: 'demo@echo.pro',
      password: hashedPassword,
      name: 'Demo User',
    },
  });

  // Create a demo session
  const session = await prisma.session.create({
    data: {
      userId: demoUser.id,
      title: 'Welcome to Echo Pro',
    },
  });

  // Create demo messages
  await prisma.message.createMany({
    data: [
      {
        content: 'Hello! Welcome to Echo Pro. How can I help you today?',
        sender: 'ai',
        sessionId: session.id,
      },
      {
        content: 'Hi! I\'m excited to try this app.',
        sender: 'user',
        sessionId: session.id,
        userId: demoUser.id,
      },
    ],
  });

  console.log('✅ Database seeded successfully!');
  console.log('   Demo user: demo@echo.pro / demo123456');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
