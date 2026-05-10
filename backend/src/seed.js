const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding database with dashboard statistics...');
  const sqlFile = path.join(__dirname, '../database_dashboard.sql');
  const sql = fs.readFileSync(sqlFile, 'utf8');

  try {
    await prisma.$executeRawUnsafe(sql);
    console.log('Seed completed successfully!');
  } catch (err) {
    console.error('Seed failed:', err.message);
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
