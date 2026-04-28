-- Move 1:1 FK from position.interview_flow_id to interview_flow.position_id
-- so interview flows are deleted when positions are deleted.

ALTER TABLE "position"
  DROP CONSTRAINT "position_interview_flow_id_fkey";

DROP INDEX "position_interview_flow_id_key";

ALTER TABLE "interview_flow"
  ADD COLUMN "position_id" INTEGER;

UPDATE "interview_flow" AS f
SET "position_id" = p."id"
FROM "position" AS p
WHERE p."interview_flow_id" = f."id";

-- Clean orphan interview flows created by previous delete semantics.
DELETE FROM "interview_flow"
WHERE "position_id" IS NULL;

ALTER TABLE "interview_flow"
  ALTER COLUMN "position_id" SET NOT NULL;

CREATE UNIQUE INDEX "interview_flow_position_id_key"
ON "interview_flow"("position_id");

ALTER TABLE "interview_flow"
  ADD CONSTRAINT "interview_flow_position_id_fkey"
  FOREIGN KEY ("position_id") REFERENCES "position"("id")
  ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "position"
  DROP COLUMN "interview_flow_id";

-- Enforce valid salary ranges.
ALTER TABLE "position"
  ADD CONSTRAINT "position_salary_range_chk"
  CHECK (
    "salary_min" IS NULL
    OR "salary_max" IS NULL
    OR "salary_min" <= "salary_max"
  );
