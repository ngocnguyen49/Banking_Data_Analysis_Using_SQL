DROP TABLE IF EXISTS banking_customer;

CREATE TABLE banking_customer (
    TransactionID INTEGER,
    CustomerID INTEGER,
    TransactionDate DATE,
    TransactionType VARCHAR(50),
    Amount FLOAT,
    ProductCategory VARCHAR(100),
    ProductSubcategory VARCHAR(100),
    BranchCity VARCHAR(100),
    BranchLat FLOAT,
    BranchLong FLOAT,
    Channel VARCHAR(50),
    Currency VARCHAR(10),
    CreditCardFees FLOAT,
    InsuranceFees FLOAT,
    LatePaymentAmount FLOAT,
    CustomerScore INTEGER,
    MonthlyIncome FLOAT,
    CustomerSegment VARCHAR(50),
    RecommendedOffer VARCHAR(100)
);

COPY banking_customer
FROM 'D:\Banking\banking_customer.csv'
ENCODING 'ISO-8859-1'
DELIMITER ','
CSV HEADER;
