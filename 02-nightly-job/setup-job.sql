-- Nightly load: table and procedure that the SQL Server Agent job runs
USE SupportIncidentLab;
GO
CREATE TABLE dbo.DailyLoad (
    LoadDate     date      NOT NULL PRIMARY KEY,
    PaymentCount int       NOT NULL,
    LoadedAt     datetime2 NOT NULL DEFAULT SYSDATETIME()
);
GO
CREATE PROCEDURE dbo.usp_NightlyLoad
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.DailyLoad (LoadDate, PaymentCount)
    SELECT CAST(GETDATE() AS date), COUNT(*)
    FROM dbo.Payments;
END;
GO
