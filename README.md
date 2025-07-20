# 💳 The Pulse of Banking: Detecting User Behavior Through SQL

## 🏦 Introduction

Have you ever wondered how banks detect unusual user behavior or identify dormant accounts among millions of transactions?  
In the ever-evolving world of digital finance, understanding user engagement is vital for ensuring customer retention and preventing risk.

As a data analyst passionate about financial systems, I embarked on a journey to explore real banking data using SQL —  
a language that transforms raw transaction logs into powerful insights.

---

## 🎯 Objective

The aim of this project is to **detect patterns in user behavior** in the banking sector — from identifying active vs. dormant users,  
to understanding transaction types, retention rates, and zero-balance anomalies.

Using SQL, I explored how customer segments behave, how frequently they interact with their accounts,  
and what signals suggest potential drop-off or disengagement.

---

## 🛠️ What I Have Done Using SQL

I used SQL to perform an in-depth analysis of financial customer data.

Key SQL techniques used:

- `SELECT`, `JOIN`, `GROUP BY`, `ORDER BY`
- Aggregate functions: `COUNT()`, `SUM()`, `AVG()`
- Subqueries & Common Table Expressions (CTEs)
- Window functions: `RANK()`, `ROW_NUMBER()`
- Conditional logic using `CASE WHEN`

Main tasks performed:

- User retention rate analysis
- User behavior by channel and region
- Risk customer detection
- Customer segmentation by transaction type and frequency


---

## 📊 Key Insights
- Retention Rate by Customer Segment: Middle Income (40.9%), High Income (32.95%), Low Income (23%)
- Retention Rate by Transaction Type: Fee (18.46%), Loan Payment (17.96%), Deposit (17.49%), Card Payment (17.39%), Transfer (17.22%), Withdrawal (17.21%)
- Transaction Amount by Channel: ATM transactions recorded the highest amount across all income segments
- Most Used Currency by Volume: EUR is the dominant currency across all customer segments
- Highest-Fee Product Subcategories for Loan Payments: Business and Student loans
- Segment with the Highest Loan Payment Fees: Low Income customers

## ✅ Conclusion

This project demonstrates how **SQL can unveil patterns hidden in financial data** — from identifying risk customers to detecting user behavior by channel and region.

Understanding these behaviors is crucial for banks aiming to:

- Improve user retention  
- Minimize financial risk  
- Personalize marketing & services  

> 💡 The financial world isn’t just numbers — it’s behavior.  
> And behavior can be detected.  
> **With SQL, we know exactly where to look.**

---

## 📂 Files in This Repository

| File Name           | Description                                      |
|---------------------|--------------------------------------------------|
| `banking_users.sql` | SQL queries for behavior detection               |
| `banking_customer.csv` | Retention insights (exported results)        |
| `README.md`         | Project summary and key findings (this file)     |
