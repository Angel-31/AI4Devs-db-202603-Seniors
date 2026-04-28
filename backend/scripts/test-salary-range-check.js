const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
  const company = await prisma.company.create({
    data: {
      name: `CHECK test ${Date.now()}`,
    },
  });

  try {
    await prisma.position.create({
      data: {
        companyId: company.id,
        title: 'Invalid salary range test',
        status: 'OPEN',
        salaryMin: 5000,
        salaryMax: 1000,
      },
    });

    throw new Error('Expected CHECK constraint violation, but insert succeeded.');
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    if (!message.includes('position_salary_range_chk')) {
      throw error;
    }

    console.log('OK: CHECK constraint blocked invalid salary range.');
    console.log('Constraint: position_salary_range_chk');
  } finally {
    await prisma.company.delete({ where: { id: company.id } });
  }
}

main()
  .catch((error) => {
    console.error('FAILED:', error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

