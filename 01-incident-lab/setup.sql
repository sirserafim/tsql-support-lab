/* Support incident lab - setup script
   Personal practice lab. Synthetic data only. Not affiliated with any company.
   Run ONLY on a local SQL Server instance you control (SQL Server 2025 Developer + SSMS).
   Re-running drops and recreates only the four lab tables below. */

USE master;
GO
IF DB_ID(N'SupportIncidentLab') IS NULL
    CREATE DATABASE SupportIncidentLab;
GO
USE SupportIncidentLab;
GO

-- Repeatable: drop only the four lab tables, in foreign-key order
IF OBJECT_ID(N'dbo.SupportTickets', N'U') IS NOT NULL DROP TABLE dbo.SupportTickets;
IF OBJECT_ID(N'dbo.MonitorAlerts', N'U') IS NOT NULL DROP TABLE dbo.MonitorAlerts;
IF OBJECT_ID(N'dbo.Payments', N'U') IS NOT NULL DROP TABLE dbo.Payments;
IF OBJECT_ID(N'dbo.Clients', N'U') IS NOT NULL DROP TABLE dbo.Clients;
GO

CREATE TABLE dbo.Clients (
    ClientId   INT          PRIMARY KEY,
    ClientName NVARCHAR(80) NOT NULL
);

CREATE TABLE dbo.Payments (
    PaymentId     INT           PRIMARY KEY,
    ClientId      INT           NOT NULL REFERENCES dbo.Clients(ClientId),
    CreatedAt     DATETIME2(0)  NOT NULL,
    Amount        DECIMAL(10,2) NOT NULL,
    PaymentStatus VARCHAR(16)   NOT NULL,
    ErrorCode     VARCHAR(32)   NULL
);

CREATE TABLE dbo.MonitorAlerts (
    AlertId   INT           PRIMARY KEY,
    AlertTime DATETIME2(0)  NOT NULL,
    Component VARCHAR(40)   NOT NULL,
    Severity  VARCHAR(16)   NOT NULL,
    Message   NVARCHAR(180) NOT NULL
);

CREATE TABLE dbo.SupportTickets (
    TicketId        INT           PRIMARY KEY,
    OpenedAt        DATETIME2(0)  NOT NULL,
    ClientId        INT           NOT NULL REFERENCES dbo.Clients(ClientId),
    Summary         NVARCHAR(150) NOT NULL,
    Priority        VARCHAR(10)   NOT NULL,
    TicketStatus    VARCHAR(20)   NOT NULL,
    FirstResponseAt DATETIME2(0)  NULL
);

INSERT INTO dbo.Clients (ClientId, ClientName) VALUES
(101, N'Demo Bank A'),
(102, N'Demo Finance B'),
(103, N'Demo Credit C');

INSERT INTO dbo.Payments (PaymentId, ClientId, CreatedAt, Amount, PaymentStatus, ErrorCode) VALUES
(1,  101, '2026-10-19T08:45:00', 100, 'Completed', NULL),
(2,  101, '2026-10-19T09:02:00',  45, 'Failed',    'API_TIMEOUT'),
(3,  101, '2026-10-19T09:05:00',  80, 'Failed',    'API_TIMEOUT'),
(4,  101, '2026-10-19T09:07:00',  30, 'Failed',    'CARD_DECLINED'),
(5,  102, '2026-10-19T09:12:00',  99, 'Failed',    'API_TIMEOUT'),
(6,  102, '2026-10-19T09:13:00',  77, 'Completed', NULL),
(7,  103, '2026-10-19T09:15:00',  49, 'Failed',    'DB_CONN'),
(8,  101, '2026-10-19T09:20:00',  64, 'Failed',    'API_TIMEOUT'),
(9,  102, '2026-10-19T09:25:00',  74, 'Failed',    'API_TIMEOUT'),
(10, 103, '2026-10-19T09:31:00',  10, 'Completed', NULL),
(11, 101, '2026-10-19T10:03:00',  90, 'Failed',    'DB_CONN'),
(12, 102, '2026-10-19T10:07:00', 110, 'Failed',    'DB_CONN'),
(13, 103, '2026-10-19T10:16:00',  35, 'Failed',    'API_TIMEOUT'),
(14, 101, '2026-10-19T10:32:00',  55, 'Completed', NULL),
(15, 102, '2026-10-19T10:42:00',  50, 'Failed',    'CARD_DECLINED'),
(16, 103, '2026-10-19T10:47:00',  20, 'Completed', NULL),
(17, 101, '2026-10-19T11:01:00',  25, 'Failed',    'API_TIMEOUT'),
(18, 102, '2026-10-19T11:08:00', 125, 'Failed',    'API_TIMEOUT'),
(19, 103, '2026-10-19T11:15:00',  40, 'Completed', NULL),
(20, 101, '2026-10-19T11:21:00',  31, 'Failed',    'API_TIMEOUT'),
(21, 103, '2026-10-19T08:56:00',  61, 'Completed', NULL),
(22, 102, '2026-10-19T11:30:00',  85, 'Completed', NULL);

INSERT INTO dbo.MonitorAlerts (AlertId, AlertTime, Component, Severity, Message) VALUES
(901, '2026-10-19T09:01:00', 'PaymentGateway', 'High',   N'Increased upstream response times'),
(902, '2026-10-19T09:13:00', 'DatabasePool',   'Medium', N'Connection pool warning'),
(903, '2026-10-19T10:10:00', 'PaymentGateway', 'Info',   N'Latency alert cleared');

INSERT INTO dbo.SupportTickets (TicketId, OpenedAt, ClientId, Summary, Priority, TicketStatus, FirstResponseAt) VALUES
(501, '2026-10-19T09:06:00', 101, N'Payment timeout complaints',   'High',   'Assigned', '2026-10-19T09:18:00'),
(502, '2026-10-19T09:19:00', 102, N'Intermittent failed payments', 'Medium', 'Assigned', '2026-10-19T09:43:00'),
(503, '2026-10-19T11:17:00', 103, N'Customer requests status',     'Low',    'New',      NULL);
GO

-- Check: expect 22 and 14
SELECT COUNT(*) AS PaymentRows FROM dbo.Payments;
SELECT COUNT(*) AS FailedRows  FROM dbo.Payments WHERE PaymentStatus = 'Failed';
