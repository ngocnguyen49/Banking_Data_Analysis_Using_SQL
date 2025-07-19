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
- Zero-balance account detection
- Monthly transaction volume tracking
- Segmentation by transaction type and frequency
- First vs. last activity comparisons

---

## 📊 Key Insights

### 🧾 User Retention Rate by Segment
- Premium users: **73%** retention  
- Savings users: **60%** retention  
- Basic users: **42%** retention  

---

### 💤 Dormant Accounts with Zero Balance
- **18% of accounts** showed **zero balance** for over **6 months**.

---

### 💸 Most Active Transaction Types
- Transfers and bill payments dominate activity logs.  
- Loan repayments show **cyclical patterns**.  
- Credit card payments spike at **month-end**.

---

### 📈 Monthly Transaction Volume Trends
- Peaks in **March**, **June**, and **November**  
  (aligned with salary bonuses and tax deadlines).

---

### 📅 First vs. Last Transaction Gap
- Churned users: **92-day average gap**  
- Active users: **< 14-day** transaction gaps  

---

### 🏆 High-Value Customers
- Top **5% of customers** contribute **40% of total volume**.

---

## ✅ Conclusion

This project demonstrates how **SQL can unveil patterns hidden in financial data** — from identifying loyal customers to detecting dormant accounts.

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
| `retention_report.csv` | Retention insights (exported results)        |
| `README.md`         | Project summary and key findings (this file)     |
