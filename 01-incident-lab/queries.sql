-- T-SQL support incident lab: my queries
-- Database: SupportIncidentLab (synthetic data, created by setup.sql)
USE SupportIncidentLab;
GO

-- Q1: All failed payments, newest first (PaymentId, ClientId, CreatedAt, ErrorCode).
SELECT PaymentId, ClientId, CreatedAt, ErrorCode
FROM dbo.Payments
WHERE PaymentStatus = 'Failed'
ORDER BY CreatedAt DESC;

-- Q2: Failed payments from 09:00 to before 10:00 on 19 Oct 2026, using >= and <.
-- Why not BETWEEN: (your words)
-- (write your query here)

-- Q3: Client name and number of failed payments per client.
-- (write your query here)

-- Q4: Number of failures per error code, highest first.
-- (write your query here)

-- Q5: The two clients with the most failures.
-- (write your query here)

-- Q6: Total and failed payments per client.
-- Why a WHERE PaymentStatus = 'Failed' is not enough: (your words)
-- (write your query here)

-- Q7: The last failed payment of each client.
-- (write your query here)

-- Q8: The first failure after the first High severity alert.
-- (write your query here)

-- Q9: Failed and total payments per hour.
-- (write your query here)

-- Q10: Minutes to first response for each ticket, against an example 15-minute target.
-- Why one result is NULL: (your words)
-- (write your query here)

-- Q11: With a CTE, failures per error code, keeping only codes with 3 or more failures.
-- (write your query here)

-- Q12: Failed payments within 15 minutes after each High alert.
-- Note: a time correlation does not prove the cause.
-- (write your query here)
