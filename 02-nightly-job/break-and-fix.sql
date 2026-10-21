-- Breaking the nightly job on purpose, then fixing it safely
USE SupportIncidentLab;
GO

-- Break 1: run the job twice on the same day (expect error 2627). No code change needed.

-- Break 2: divide by zero (expect error 8134)
ALTER PROCEDURE dbo.usp_NightlyLoad
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.DailyLoad (LoadDate, PaymentCount)
    SELECT CAST(GETDATE() AS date), COUNT(*) / 0
    FROM dbo.Payments;
END;
GO

-- Break 3: missing date (expect error 515)
-- (write the ALTER PROCEDURE here: SELECT CAST(NULL AS date), COUNT(*))

-- Break 4: wrong table name (expect error 208)
-- (write the ALTER PROCEDURE here: FROM dbo.PaymentsX)

-- Restore the correct procedure
-- (write the ALTER PROCEDURE here, same body as setup-job.sql)

-- Safe fix: remove today's row before re-running the job
-- 1) Look first, with the same WHERE
SELECT * FROM dbo.DailyLoad WHERE LoadDate = CAST(GETDATE() AS date);

-- 2) Change inside a transaction
BEGIN TRAN;
DELETE FROM dbo.DailyLoad WHERE LoadDate = CAST(GETDATE() AS date);
SELECT @@ROWCOUNT AS RowsDeleted;   -- expect 1

-- 3) Then run ONE of these on its own:
-- COMMIT;     -- the count is what you expected
-- ROLLBACK;   -- anything else
