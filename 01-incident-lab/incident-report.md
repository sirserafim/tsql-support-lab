# Incident Report — Failed Payments

**Environment:** Personal SQL Server Lab  
**Data:** Synthetic payment, monitoring and support-ticket records  
**Incident date:** 19 October 2026  
**Status:** Simulated investigation — root cause not confirmed

## 1. Summary

A simulated payment-processing incident was investigated using T-SQL queries against synthetic transaction, monitoring-alert and support-ticket data.

Of 22 recorded payments, 14 failed, affecting three demonstration clients.

The most frequent error was `API_TIMEOUT`, followed by `DB_CONN` and `CARD_DECLINED`.

## 2. Timeline

- **09:01** — High-severity alert: increased payment-gateway response times.
- **09:02** — First failed payment after the alert.
- **09:13** — Medium-severity database connection-pool warning.
- **10:10** — Information alert reporting that the latency condition had cleared.
- **After 10:10** — Five additional failed payments were recorded.
- **11:21** — Most recent failed payment in the sample.

## 3. Business Impact

The synthetic dataset contains 14 failures affecting three clients:

- Demo Bank A: 7 failed payments.
- Demo Finance B: 5 failed payments.
- Demo Credit C: 2 failed payments.

Failure codes:

- `API_TIMEOUT`: 9
- `DB_CONN`: 3
- `CARD_DECLINED`: 2

Not all failures should automatically be treated as resulting from the same technical incident. Card declines may represent a different type of outcome.

## 4. Evidence

**Q1–Q2:** Identified failed transactions and the affected time window.

**Q3–Q6:** Identified affected clients, failure distribution and total transaction counts.

**Q8–Q9:** Compared alert times with hourly payment failures.

**Q10:** Investigated first-response times for three support tickets using an illustrative 15-minute target.

**Q11–Q12:** Identified recurring error codes and payments occurring shortly after a high-severity alert.

## 5. What We Cannot Confirm

The root cause cannot be established from these database records alone.

Further investigation would require payment-gateway and application logs, correlation IDs, database connection-pool metrics and information about deployments or configuration changes around the affected period.

A temporal relationship between a monitoring alert and failed payments does not establish causality.

## 6. Escalation to L2

A simulated payment-processing issue has affected three demonstration clients, with 14 failed transactions out of 22 sampled payments.

Nine failures contain `API_TIMEOUT`, three contain `DB_CONN`, and two contain `CARD_DECLINED`.

A high-severity gateway-latency alert was recorded at 09:01, and a database connection-pool warning followed at 09:13. Failures continued after the gateway alert was marked as cleared.

**Root cause remains unconfirmed.**

Please investigate the relevant application and gateway logs, correlation IDs, database connectivity metrics and any changes or deployments during the affected period.

## 7. Example Client Update

"We are investigating an increased number of failed transactions during the affected period.

Our initial checks have identified relevant technical alerts, and the investigation has been escalated to the appropriate team.

We do not yet have a confirmed root cause or resolution estimate.

We will provide another update at the agreed time."

## 8. Important Limitations

This is a personal learning exercise using synthetic data.

It does not represent an actual incident, real systems or customer information.

The investigation consisted of read-only queries and incident documentation. No production changes were made.