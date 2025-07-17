-- Explore Total of Customer
SELECT
    COUNT(DISTINCT CustomerID) AS TotalOfCustomer
FROM
    banking_customer
-- Explore Total of Customer : 8025


-- Total of Tracsaction
SELECT
    COUNT(DISTINCT TransactionID) AS TotalOfTransaction
FROM
    banking_customer
-- There are 20000 Number Of Transaction


-- Explore Unique Value
SELECT DISTINCT CustomerSegment FROM banking_customer;  -- Middle Income Segment, High Income Segment, Low Income Segment
SELECT DISTINCT TransactionType FROM banking_customer;  -- Card Payment, Deposit, Transfer, Withdrawal, Fee, Loan Payment
SELECT DISTINCT ProductCategory FROM banking_customer;  -- Checking Account, Mortgage, Loan, Savings Account, Credit Card
SELECT DISTINCT ProductSubcategory FROM banking_customer;  -- Gold, Plantinum, Standard, Student, Business
SELECT DISTINCT BranchCity FROM banking_customer;  -- Seville, Murcia, Malaga, Bilbao, Valencia, Madrid, Barcelona, Zaragoza
SELECT DISTINCT Channel FROM banking_customer;  -- Branch, ATM, Mobile, Online
SELECT DISTINCT Currency FROM banking_customer;  -- EUR, USD
SELECT DISTINCT RecommendedOffer FROM banking_customer; -- Mid-tier Savings Booster, Financial Literacy Program Access, Premium Investment Services, Personal Loan Cashback Offer, Gold Card with Travel Benifits, No-fee Basic Account, Exclusive Plantinum Package


-- Requirement 1: Understand how different customer segments behave financially

-- Q1: Average Monthly Income, Average Amount, Average Fee Per Customer Segment
SELECT
    CustomerSegment,
    ROUND(AVG(MonthlyIncome), 2) AS AvgMonthlyIncome,
    ROUND(AVG(Amount), 2) AS AvgAmount,
    ROUND(AVG(CreditCardFees + InsuranceFees + LatePaymentAmount), 2) AS AvgTotalFee
FROM
    banking_customer
GROUP BY
    CustomerSegment
ORDER BY
    AvgMonthlyIncome DESC;
-- The High Income segment ranks highest in average monthly income.
-- In contrast, the Middle Income segment leads in both average transaction amount and average total fees. The Low Income segment consistently ranks lowest across all three metrics



-- Q2: Top 2 per CustomerSegment by Average Amount, Average TotalFee
WITH base AS (
    SELECT
        CustomerSegment,
        TransactionType,
        ROUND(AVG(Amount), 2) AS AvgAmount,
        ROUND(AVG(CreditCardFees + InsuranceFees + LatePaymentAmount), 2) AS AvgTotalFee
    FROM
        banking_customer
    GROUP BY
        CustomerSegment, TransactionType
),

ranked_amount AS (
    SELECT *,
           RANK() OVER (PARTITION BY CustomerSegment ORDER BY AvgAmount DESC) AS rank_amount
    FROM base
),

ranked_fee AS (
    SELECT *,
           RANK() OVER (PARTITION BY CustomerSegment ORDER BY AvgTotalFee DESC) AS rank_fee
    FROM base
)

SELECT
    CustomerSegment,
    TransactionType,
    AvgAmount,
    NULL AS AvgTotalFee,
    'Top Avg Amount' AS MetricType,
    AvgAmount AS SortValue
FROM ranked_amount
WHERE rank_amount <= 2

UNION ALL

SELECT
    CustomerSegment,
    TransactionType,
    NULL AS AvgAmount,
    AvgTotalFee,
    'Top Avg Fee' AS MetricType,
    AvgTotalFee AS SortValue
FROM ranked_fee
WHERE rank_fee <= 2
-- For average total fees, Loan Payment consistently leads across all three customer segments, with a significant margin compared to the second-highest transaction type.
-- The second place varies — Transfer ranks second for both the Middle and Low Income segments, while Withdrawal holds that position for the High Income segment.
-- In terms of average transaction amount, the top two transaction types differ across segments, but the gaps between them are relatively small.


-- Q3: Highest Channel per CustomerSegment by Average Amount, Average TotalFee
WITH base AS (
    SELECT
        CustomerSegment,
        Channel,
        ROUND(AVG(Amount), 2) AS AvgAmount,
        ROUND(AVG(CreditCardFees + InsuranceFees + LatePaymentAmount), 2) AS AvgTotalFee
    FROM
        banking_customer
    GROUP BY
        CustomerSegment, Channel
),

ranked_amount AS (
    SELECT *,
           RANK() OVER (PARTITION BY CustomerSegment ORDER BY AvgAmount DESC) AS rank_amount
    FROM base
),

ranked_fee AS (
    SELECT *,
           RANK() OVER (PARTITION BY CustomerSegment ORDER BY AvgTotalFee DESC) AS rank_fee
    FROM base
)

-- Top 1 Channel by AvgAmount
SELECT
    CustomerSegment,
    Channel,
    AvgAmount,
    NULL AS AvgTotalFee,
    'Top Avg Amount' AS MetricType
FROM ranked_amount
WHERE rank_amount = 1

UNION ALL

-- Top 1 Channel by AvgTotalFee
SELECT
    CustomerSegment,
    Channel,
    NULL AS AvgAmount,
    AvgTotalFee,
    'Top Avg Fee' AS MetricType
FROM ranked_fee
WHERE rank_fee = 1

ORDER BY CustomerSegment, MetricType;

-- ATM leads in average transaction amount across all customer segments. For average total fees, Mobile ranks highest for High Income, Online for Middle Income, and Branch for Low Income segments.


-- Q4: Total Number of Transaction Using Currency By Customer Segment
SELECT
    CustomerSegment,
    Currency,
    COUNT(*) AS TotalTransactions
FROM
    banking_customer
GROUP BY
    CustomerSegment, Currency
ORDER BY
    CustomerSegment, TotalTransactions DESC;
-- EUR is the most used currency across all customer segments based on transaction count.
-- Additionally, USD is more commonly used by the Middle Income segment compared to the High and Low Income segments.


-- Requirement 2: Identify high-fee and high-risk patterns for cost control and opportunity
-- Q5: Top 10 customer with highest TotalFee 
SELECT
    CustomerID,
    ROUND(SUM(CreditCardFees + InsuranceFees + LatePaymentAmount), 2) AS TotalFee,
    ROUND(MIN(MonthlyIncome), 2) AS MonthlyIncome,
    ROUND(SUM(CreditCardFees + InsuranceFees + LatePaymentAmount) * 100.0 / NULLIF(MIN(MonthlyIncome), 0), 2) AS FeeRatePercentage,
    MIN(CustomerScore) AS CustomerScore
FROM
    banking_customer
GROUP BY
    CustomerID
ORDER BY
    TotalFee DESC
LIMIT 10;
-- 4083, 2646, 6599, 1224 can be considered to be high-risk customer cause their FeeRatePercentage compare to MonthlyIncome quite high.


-- Q6: Top 10 customer with lowest CustomerScore
WITH fee_summary AS (
    SELECT 
        CustomerID,
        MIN(CustomerScore) AS CustomerScore,
        MIN(MonthlyIncome) AS MonthlyIncome,
        SUM(CreditCardFees + InsuranceFees + LatePaymentAmount) AS TotalFee
    FROM banking_customer
    GROUP BY CustomerID
),
ranked_customers AS (
    SELECT 
        CustomerID,
        CustomerScore,
        MonthlyIncome,
        TotalFee,
        ROUND((TotalFee / NULLIF(MonthlyIncome, 0)) * 100, 2) AS FeeRatePercentage
    FROM fee_summary
)
SELECT *
FROM ranked_customers
ORDER BY CustomerScore ASC
LIMIT 10;
-- 2646 can be considered to be high-risk customer cause their FeeRatePercentage compare to MonthlyIncome quite high and Customer Score quite low.


--Q7: ProductSubcategory with the highest fee by Loan Payment 
SELECT 
    ProductSubcategory,
    AVG(CreditCardFees + InsuranceFees + LatePaymentAmount) AS AvgTotalFee,
    AVG(MonthlyIncome) AS AvgMonthlyIncome,
    AVG(CreditCardFees + InsuranceFees + LatePaymentAmount) / AVG(MonthlyIncome)*100 AS FeeToIncomeRate
FROM banking_customer
WHERE TransactionType = 'Loan Payment'
GROUP BY ProductSubcategory
ORDER BY FeeToIncomeRate DESC
-- Prority Business and Student for Offer related to Loan Payment


--Q8: CustomerSegment with the highest fee by Loan Payment 
SELECT 
    CustomerSegment,
    AVG(CreditCardFees + InsuranceFees + LatePaymentAmount) AS AvgTotalFee,
    AVG(MonthlyIncome) AS AvgMonthlyIncome,
    AVG(CreditCardFees + InsuranceFees + LatePaymentAmount) / AVG(MonthlyIncome)*100 AS FeeToIncomeRate
FROM banking_customer
WHERE TransactionType = 'Loan Payment'
GROUP BY ProductSubcategory
ORDER BY FeeToIncomeRate DESC
-- Priority Low Income Segment for Offer related to Loan Payment




-- Requirement 3: Evaluate operational efficiency by channel and region
-- Q9: City with the highest FeeToIcomeRate by Loan Payment 
SELECT 
    BranchCity,
    AVG(CreditCardFees + InsuranceFees + LatePaymentAmount) AS AvgTotalFee,
    AVG(MonthlyIncome) AS AvgMonthlyIncome,
    AVG(CreditCardFees + InsuranceFees + LatePaymentAmount) / AVG(MonthlyIncome)   *100 AS FeeToIncomeRate
FROM banking_customer
WHERE TransactionType = 'Loan Payment'
GROUP BY BranchCity
ORDER BY FeeToIncomeRate DESC
-- Murcia, Bilbao, Barcelona are top 3 cities with highest FeeToIncomeRate by Loan Payment.


-- Q10: Channel with the highest FeeToIcomeRate by Loan Payment 
SELECT 
    Channel,
    AVG(CreditCardFees + InsuranceFees + LatePaymentAmount) AS AvgTotalFee,
    AVG(MonthlyIncome) AS AvgMonthlyIncome,
    AVG(CreditCardFees + InsuranceFees + LatePaymentAmount) / AVG(MonthlyIncome)*100 AS FeeToIncomeRate
FROM banking_customer
WHERE TransactionType = 'Loan Payment'
GROUP BY Channel
ORDER BY FeeToIncomeRate DESC
-- Branch, Mobile are the higher FeeToIcomeRate Channel by Loan Payment.


-- Q11: City with the highest FeeToIcomeRate by Card Payment
SELECT 
    BranchCity,
    AVG(CreditCardFees + InsuranceFees + LatePaymentAmount) AS AvgTotalFee,
    AVG(MonthlyIncome) AS AvgMonthlyIncome,
    AVG(CreditCardFees + InsuranceFees + LatePaymentAmount) / AVG(MonthlyIncome)   *100 AS FeeToIncomeRate
FROM banking_customer
WHERE TransactionType = 'Card Payment'
GROUP BY BranchCity
ORDER BY FeeToIncomeRate DESC
-- Malaga, Madrid, Bilbao are top 3 cities with highest FeeToIncomeRate by Card Payment.


-- Q12: Channel with the highest fee by Card Payment 
SELECT 
    Channel,
    AVG(CreditCardFees + InsuranceFees + LatePaymentAmount) AS AvgTotalFee,
    AVG(MonthlyIncome) AS AvgMonthlyIncome,
    AVG(CreditCardFees + InsuranceFees + LatePaymentAmount) / AVG(MonthlyIncome)*100 AS FeeToIncomeRate
FROM banking_customer
WHERE TransactionType = 'Card Payment'
GROUP BY Channel
ORDER BY FeeToIncomeRate DESC
-- ATM, Branch are the higher FeeToIcomeRate Channel by Card Payment.


-- Requirement 4: Develop data-driven strategies to boost engagement and retention
-- Q13: Highest Retention Rate by TransactionType
SELECT 
  TransactionType,
  COUNT(DISTINCT CustomerID) AS total_customers,
  COUNT(DISTINCT CASE 
    WHEN txn_count > 1 THEN CustomerID 
  END) AS returning_customers,
  ROUND(
    100.0 * COUNT(DISTINCT CASE 
      WHEN txn_count > 1 THEN CustomerID 
    END) / COUNT(DISTINCT CustomerID),
    2
  ) AS retention_rate_percent
FROM (
  SELECT 
    CustomerID,
    TransactionType,
    COUNT(DISTINCT CAST(TransactionDate AS DATE)) AS txn_count
  FROM banking_customer
  GROUP BY CustomerID, TransactionType
)
GROUP BY TransactionType
ORDER BY retention_rate_percent DESC;
-- Fee and Loan Payment are the highest retention rate by TransactionType


-- Q14: Highest Retention Rate by CustomerSegment
SELECT 
  CustomerSegment,
  COUNT(DISTINCT CustomerID) AS total_customers,
  COUNT(DISTINCT CASE 
    WHEN txn_count > 1 THEN CustomerID 
  END) AS returning_customers,
  ROUND(
    100.0 * COUNT(DISTINCT CASE 
      WHEN txn_count > 1 THEN CustomerID 
    END) / COUNT(DISTINCT CustomerID),
    2
  ) AS retention_rate_percent
FROM (
  SELECT 
    CustomerID,
    CustomerSegment,
    COUNT(DISTINCT CAST(TransactionDate AS DATE)) AS txn_count
  FROM banking_customer
  GROUP BY CustomerID, CustomerSegment
)
GROUP BY CustomerSegment
ORDER BY retention_rate_percent DESC;
-- Middle Income Segment is the highest retention rate by CustomerSegment


-- Q15: Personal Loan Cashback Offer Rate by each ProductSubCategory using Loan Payment in TransactionType
SELECT 
  lp.ProductSubcategory,
  COUNT(DISTINCT plo.CustomerID) * 1.0 / COUNT(DISTINCT lp.CustomerID) AS offer_rate,
  COUNT(DISTINCT plo.CustomerID) AS offered_customers,
  COUNT(DISTINCT lp.CustomerID) AS loan_payment_customers
FROM banking_customer lp
LEFT JOIN banking_customer plo
  ON lp.CustomerID = plo.CustomerID 
  AND lp.ProductSubcategory = plo.ProductSubcategory
  AND plo.RecommendedOffer = 'Personal Loan Cashback Offer'
WHERE lp.TransactionType = 'Loan Payment'
GROUP BY lp.ProductSubcategory
ORDER BY offer_rate DESC;
-- Standard is the highest Personal Loan Cashback Offer Rate using Loan Payment in TransactionType


-- Q16: Mid-tier Savings Booster Rate by each ProductSubCategory using Savings Account in ProductCategory
SELECT 
  sa.ProductSubcategory,
  COUNT(DISTINCT msb.CustomerID) * 1.0 / COUNT(DISTINCT sa.CustomerID) AS offer_rate,
  COUNT(DISTINCT msb.CustomerID) AS offered_customers,
  COUNT(DISTINCT sa.CustomerID) AS saving_account_customers
FROM banking_customer sa
LEFT JOIN banking_customer msb
  ON sa.CustomerID = msb.CustomerID 
  AND sa.ProductSubcategory = msb.ProductSubcategory
  AND msb.RecommendedOffer = 'Mid-tier Savings Booster'
WHERE sa.ProductCategory = 'Savings Account'
GROUP BY sa.ProductSubcategory
ORDER BY offer_rate DESC;
-- Student is the highest Mid-tier Savings Booster Rate using Savings Account in ProductCategory














