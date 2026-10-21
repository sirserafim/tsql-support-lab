# checks.ps1 - first-line checks for the support lab

# 1. Find commands and examples on your own (run Update-Help once if examples are missing)
Get-Command *service*
Get-Help Get-Service -Examples

# 2. Are SQL Server and SQL Server Agent running?
Get-Service *SQL* | Select-Object Name, DisplayName, Status

# 3. A test log, and a search for errors in it
New-Item -ItemType Directory -Path C:\lab -Force | Out-Null
"2026-10-21 02:10 ERROR nightly load failed" | Out-File C:\lab\log.txt -Append
Get-Content C:\lab\log.txt -Tail 20
Select-String -Path C:\lab\log.txt -Pattern "ERROR"

# 4. Newest files in a folder: did tonight's file arrive?
Get-ChildItem C:\lab | Sort-Object LastWriteTime -Descending |
    Select-Object -First 5 Name, LastWriteTime, Length

# 5. When did a scheduled task last run, and with what result?
Get-ScheduledTask | Select-Object -First 5 TaskName, State
Get-ScheduledTask -TaskName "PUT-A-NAME-HERE" | Get-ScheduledTaskInfo

# 6. A SQL query from PowerShell
#    One-time install: Install-Module SqlServer -Scope CurrentUser
Invoke-Sqlcmd -ServerInstance localhost -Database SupportIncidentLab -TrustServerCertificate `
    -Query "SELECT * FROM dbo.DailyLoad"

# 7. Did the nightly job fail? Latest history from msdb
Invoke-Sqlcmd -ServerInstance localhost -Database msdb -TrustServerCertificate `
    -Query "EXEC dbo.sp_help_jobhistory @job_name = N'Nightly load', @mode = N'FULL'" |
    Select-Object -First 5 step_id, step_name, run_status, sql_message_id, message
