-- Align application/interview dates with DateTime semantics in Prisma.
ALTER TABLE "application"
  ALTER COLUMN "application_date" TYPE TIMESTAMP(3)
  USING "application_date"::TIMESTAMP(3),
  ALTER COLUMN "application_date" SET DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE "interview"
  ALTER COLUMN "interview_date" TYPE TIMESTAMPTZ(6)
  USING "interview_date"::TIMESTAMPTZ(6);
