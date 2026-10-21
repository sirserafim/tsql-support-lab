
-- T-SQL SUPPORT INCIDENT LAB
-- Synthetic data only | Local practice environment
USE SupportIncidentLab;
GO

-- Q1. All failed payments, newest first.
SELECT
    PaymentId,
    ClientId,
    CreatedAt,
    ErrorCode
FROM dbo.Payments
WHERE PaymentStatus = 'Failed'
ORDER BY CreatedAt DESC;


-- Q2. Failures between 09:00 and before 10:00.
-- A half-open range excludes 10:00 and works
-- correctly with datetime values containing seconds.
SELECT
    PaymentId,
    ClientId,
    CreatedAt,
    ErrorCode
FROM dbo.Payments
WHERE PaymentStatus = 'Failed'
  AND CreatedAt >= '2026-10-19T09:00:00'
  AND CreatedAt <  '2026-10-19T10:00:00'
ORDER BY CreatedAt;


-- Q3. Number of failed payments per client.
SELECT
    c.ClientName,
    COUNT(*) AS FailedPayments
FROM dbo.Payments AS p
INNER JOIN dbo.Clients AS c
    ON c.ClientId = p.ClientId
WHERE p.PaymentStatus = 'Failed'
GROUP BY c.ClientName
ORDER BY FailedPayments DESC;


-- Q4. Failure count by error code.
SELECT
    ErrorCode,
    COUNT(*) AS FailureCount
FROM dbo.Payments
WHERE PaymentStatus = 'Failed'
GROUP BY ErrorCode
ORDER BY FailureCount DESC;


-- Q5. Two clients with the most failures.
SELECT TOP (2)
    c.ClientName,
    COUNT(*) AS FailedPayments
FROM dbo.Clients AS c
INNER JOIN dbo.Payments AS p
    ON p.ClientId = c.ClientId
WHERE p.PaymentStatus = 'Failed'
GROUP BY c.ClientName
ORDER BY FailedPayments DESC, c.ClientName;


-- Q6. Total and failed payments per client.
-- LEFT JOIN preserves clients with no payments.
-- Filtering failures in WHERE would remove
-- successful payments from the total.
SELECT
    c.ClientId,
    c.ClientName,
    COUNT(p.PaymentId) AS TotalPayments,
    SUM(
        CASE
            WHEN p.PaymentStatus = 'Failed' THEN 1
            ELSE 0
        END
    ) AS FailedPayments
FROM dbo.Clients AS c
LEFT JOIN dbo.Payments AS p
    ON p.ClientId = c.ClientId
GROUP BY c.ClientId, c.ClientName
ORDER BY c.ClientId;


-- Q7. Most recent failed payment per client.
SELECT
    c.ClientId,
    c.ClientName,
    MAX(p.CreatedAt) AS LastFailureAt
FROM dbo.Payments AS p
INNER JOIN dbo.Clients AS c
    ON c.ClientId = p.ClientId
WHERE p.PaymentStatus = 'Failed'
GROUP BY c.ClientId, c.ClientName
ORDER BY c.ClientId;


-- Q8. First failed payment after the earliest
-- High severity monitoring alert.
SELECT TOP (1)
    p.PaymentId,
    p.ClientId,
    p.CreatedAt,
    p.ErrorCode
FROM dbo.Payments AS p
WHERE p.PaymentStatus = 'Failed'
  AND p.CreatedAt > (
      SELECT MIN(a.AlertTime)
      FROM dbo.MonitorAlerts AS a
      WHERE a.Severity = 'High'
  )
ORDER BY p.CreatedAt, p.PaymentId;


-- Q9. Total and failed payments per hour.
-- DATETRUNC is supported in SQL Server 2022+.
SELECT
    DATETRUNC(hour, p.CreatedAt) AS HourStart,
    COUNT(*) AS TotalPayments,
    SUM(
        CASE
            WHEN p.PaymentStatus = 'Failed' THEN 1
            ELSE 0
        END
    ) AS FailedPayments
FROM dbo.Payments AS p
GROUP BY DATETRUNC(hour, p.CreatedAt)
ORDER BY HourStart;


-- Q10. Minutes to first response for each ticket.
-- 15 minutes is a simulated training target,
-- not an actual Qualco SLA.
SELECT
    TicketId,
    Priority,
    OpenedAt,
    FirstResponseAt,
    DATEDIFF(
        minute, OpenedAt, FirstResponseAt
    ) AS ResponseMinutes,
    CASE
        WHEN FirstResponseAt IS NULL
            THEN 'No response yet'
        WHEN FirstResponseAt <= DATEADD(
            minute, 15, OpenedAt
        )
            THEN 'Within example target'
        ELSE 'Beyond example target'
    END AS ResponseAssessment
FROM dbo.SupportTickets
ORDER BY TicketId;


-- Q11. CTE: error codes with >= 3 failures.
;WITH ErrorCounts AS (
    SELECT
        ErrorCode,
        COUNT(*) AS FailureCount
    FROM dbo.Payments
    WHERE PaymentStatus = 'Failed'
    GROUP BY ErrorCode
)
SELECT
    ErrorCode,
    FailureCount
FROM ErrorCounts
WHERE FailureCount >= 3
ORDER BY FailureCount DESC;


-- Q12. Failed payments within 15 minutes
-- after each High severity alert.
-- Time correlation does not prove causation.
SELECT
    a.AlertId,
    a.AlertTime,
    a.Component,
    p.PaymentId,
    p.ClientId,
    p.CreatedAt,
    p.ErrorCode
FROM dbo.MonitorAlerts AS a
INNER JOIN dbo.Payments AS p
    ON p.CreatedAt >= a.AlertTime
   AND p.CreatedAt < DATEADD(
       minute, 15, a.AlertTime
   )
WHERE a.Severity = 'High'
  AND p.PaymentStatus = 'Failed'
ORDER BY a.AlertTime, p.CreatedAt;
