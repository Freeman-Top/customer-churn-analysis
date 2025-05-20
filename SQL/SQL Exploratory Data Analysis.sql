CREATE DATABASE Customer_Churn_Analysis;

USE Customer_Churn_Analysis;


SELECT * FROM CustomerChurn;



--- Creating a New Table

CREATE TABLE CustomerChurnn (
    Customer_id INT IDENTITY(1,1) PRIMARY KEY,
    gender NVARCHAR(50),
    Senior_citizen INT,
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    tenure INT,
    PhoneService VARCHAR(20),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(50),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTv VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(50),
    PaperlessBilling VARCHAR(10),
    PaymentMethod NVARCHAR(50),
    MonthlyCharges FLOAT,
    TotalCharges FLOAT,
    Churn VARCHAR(10)
);

--- Poupalating my new table from the imported table

INSERT INTO CustomerChurnn (
    gender, 
    Senior_citizen, 
    Partner, 
    Dependents, 
    tenure, 
    PhoneService, 
    MultipleLines, 
    InternetService, 
    OnlineSecurity, 
    OnlineBackup, 
    DeviceProtection, 
    TechSupport, 
    StreamingTv, 
    StreamingMovies, 
    Contract, 
    PaperlessBilling, 
    PaymentMethod, 
    MonthlyCharges, 
    TotalCharges, 
    Churn
)
SELECT
    gender, 
    SeniorCitizen, 
    Partner, 
    Dependents, 
    tenure, 
    PhoneService, 
    MultipleLines, 
    InternetService, 
    OnlineSecurity, 
    OnlineBackup, 
    DeviceProtection, 
    TechSupport, 
    StreamingTv, 
    StreamingMovies, 
    Contract, 
    PaperlessBilling, 
    PaymentMethod, 
    MonthlyCharges, 
    TotalCharges, 
    Churn
FROM CustomerChurn;


--- To verify if my new table have been populated 

SELECT * FROM CustomerChurnn

--- Basic Information

SELECT COUNT(*) AS total_rows FROM CustomerChurnn;

SELECT TOP 5 * FROM CustomerChurnn;

--- Checking for Missing Values
SELECT
    SUM(CASE WHEN Customer_id IS NULL THEN 1 ELSE 0 END) AS Missing_customer_id,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS  Missing_gender,
    SUM(CASE WHEN TotalCharges IS NULL OR TRY_CAST(TotalCharges AS FLOAT) IS NULL THEN 1 ELSE 0 END) AS missing_total_charges
-- Add other columns as needed
FROM CustomerChurnn;


--- SUMMARY_STATISTICS
SELECT
    MIN(tenure) AS min_tenure,
    MAX(tenure) AS max_tenure,
    AVG(tenure) AS avg_tenure,
    MIN(MonthlyCharges) AS min_monthly,
    MAX(MonthlyCharges) AS max_monthly,
    AVG(MonthlyCharges) AS avg_monthly,
    AVG(TotalCharges) AS avg_total
FROM CustomerChurnn;


--- Categorical Column

SELECT Churn, COUNT(*) AS count FROM CustomerChurnn GROUP BY Churn;

SELECT Contract, COUNT(*) AS count FROM CustomerChurnn GROUP BY Contract;

SELECT InternetService, COUNT(*) AS count FROM CustomerChurnn GROUP BY InternetService;


--- Analyze churn patterns

--- Churn by contract type
SELECT Contract, Churn, COUNT(*) AS count
FROM CustomerChurnn
GROUP BY Contract, Churn
ORDER BY Contract, Churn;


--- Churn by Tenure Bucket

SELECT 
    CASE 
        WHEN tenure <= 12 THEN '0-1 year'
        WHEN tenure <= 24 THEN '1-2 years'
        WHEN tenure <= 36 THEN '2-3 years'
        WHEN tenure <= 48 THEN '3-4 years'
        WHEN tenure <= 60 THEN '4-5 years'
        ELSE '5+ years'
    END AS Tenure_group,
    Churn,
    COUNT(*) AS count
FROM CustomerChurnn
GROUP BY 
    CASE 
        WHEN tenure <= 12 THEN '0-1 year'
        WHEN tenure <= 24 THEN '1-2 years'
        WHEN tenure <= 36 THEN '2-3 years'
        WHEN tenure <= 48 THEN '3-4 years'
        WHEN tenure <= 60 THEN '4-5 years'
        ELSE '5+ years'
    END,
    Churn
ORDER BY Tenure_group, Churn;

-- Count total records
SELECT COUNT(*) AS total_customers FROM CustomerChurnn;

--- CHURN RATE ANALYSIS 

-- Overall churn rate
SELECT 
    Churn,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM CustomerChurnn), 2) AS percentage
FROM CustomerChurnn
GROUP BY Churn;

-- 26.5% churn rate (sample dataset).
-- High-risk business impact—losing over a quarter of customers



-- CHURN RATE BY GENDER
SELECT 
    gender,
    Churn,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY gender), 2) AS percentage
FROM CustomerChurnn
GROUP BY gender, Churn
ORDER BY gender, Churn;

-- CHURN RATE BY SENIOR CITIZENSHIP

SELECT 
    CASE WHEN Senior_citizen = 1 THEN 'Senior' ELSE 'Non-Senior' END AS Senior_Status,
    Churn,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Senior_citizen), 2) AS percentage
FROM CustomerChurnn
GROUP BY Senior_citizen, Churn
ORDER BY Senior_Status, Churn;


--- SERVICE USAGE ANALYSIS

-- Internet service type distribution and churn
SELECT 
    InternetService,
    COUNT(*) AS Total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_rate
FROM CustomerChurnn
GROUP BY InternetService
ORDER BY churn_rate DESC;

-- Phone service and multiple lines impact on churn
SELECT 
    PhoneService,
    MultipleLines,
    COUNT(*) AS Total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM CustomerChurnn
GROUP BY PhoneService, MultipleLines
ORDER BY Churn_rate DESC;


--- CONTRACT AND BILLING ANALYSIS

-- Churn by Contract type
SELECT 
    Contract,
    COUNT(*) AS Total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM CustomerChurnn
GROUP BY Contract
ORDER BY Churn_rate DESC;

-- Paperless billing impact
SELECT 
    PaperlessBilling,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_rate
FROM CustomerChurnn
GROUP BY PaperlessBilling
ORDER BY Churn_rate DESC;

-- Payment method analysis
SELECT 
    PaymentMethod,
    COUNT(*) AS Total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_rate
FROM CustomerChurnn
GROUP BY PaymentMethod
ORDER BY Churn_rate DESC;


--- TENURE AND CHARGES ANALYSIS

-- Average tenure by churn status
SELECT 
    Churn,
    AVG(tenure) AS avg_tenure_months,
    MIN(tenure) AS min_tenure,
    MAX(tenure) AS max_tenure
FROM CustomerChurnn
GROUP BY Churn;

-- Monthly charges comparison
SELECT 
    Churn,
    AVG(MonthlyCharges) AS avg_monthly_charge,
    MIN(MonthlyCharges) AS min_charge,
    MAX(MonthlyCharges) AS max_charge
FROM CustomerChurnn
GROUP BY Churn;

-- Total charges comparison
SELECT 
    Churn,
    AVG(TotalCharges) AS avg_total_charge,
    MIN(TotalCharges) AS min_total_charge,
    MAX(TotalCharges) AS max_total_charge
FROM CustomerChurnn
GROUP BY Churn;

-- Tenure groups analysis

SELECT 
    CASE 
        WHEN [tenure] < 12 THEN '0-12 months'
        WHEN [tenure] >= 12 AND [tenure] < 24 THEN '12-24 months'
        WHEN [tenure] >= 24 AND [tenure] < 36 THEN '24-36 months'
        WHEN [tenure] >= 36 AND [tenure] < 48 THEN '36-48 months'
        WHEN [tenure] >= 48 AND [tenure] < 60 THEN '48-60 months'
        ELSE '60+ months'
    END AS Tenure_group,
    COUNT(*) AS Total_customers,
    SUM(CASE WHEN [Churn] = 'Yes' THEN 1 ELSE 0 END) AS Churned_customers,
    ROUND(SUM(CASE WHEN [Churn] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_rate
FROM [CustomerChurnn]
WHERE [tenure] IS NOT NULL
GROUP BY 
    CASE 
        WHEN [tenure] < 12 THEN '0-12 months'
        WHEN [tenure] >= 12 AND [tenure] < 24 THEN '12-24 months'
        WHEN [tenure] >= 24 AND [tenure] < 36 THEN '24-36 months'
        WHEN [tenure] >= 36 AND [tenure] < 48 THEN '36-48 months'
        WHEN [tenure] >= 48 AND [tenure] < 60 THEN '48-60 months'
        ELSE '60+ months'
    END
ORDER BY Churn_rate DESC;



--- ADDITIONAL SERVICES ANALYSIS

-- Online security impact
SELECT 
    OnlineSecurity,
    COUNT(*) AS Total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_rate
FROM  CustomerChurnn
GROUP BY OnlineSecurity
ORDER BY Churn_rate DESC;

-- Tech support impact
SELECT 
    TechSupport,
    COUNT(*) AS Total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_rate
FROM  CustomerChurnn
GROUP BY TechSupport
ORDER BY Churn_rate DESC;

-- Streaming services impact

SELECT 
    StreamingTV,
    StreamingMovies,
    COUNT(*) AS Total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_rate
FROM  CustomerChurnn
GROUP BY StreamingTV, StreamingMovies
ORDER BY Churn_rate DESC;


--- DEMOGRAPHIC ANALYSIS

-- Partner and dependents status
SELECT 
    Partner,
    Dependents,
    COUNT(*) AS Total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_rate
FROM CustomerChurnn
GROUP BY Partner, Dependents
ORDER BY Churn_rate DESC;

-- Gender and partner status combination
SELECT 
    gender,
    Partner,
    COUNT(*) AS Total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Churn_rate
FROM CustomerChurnn
GROUP BY gender, Partner
ORDER BY gender, Churn_rate DESC;


--- HIGH VALUE CUSTOMER ANALYSIS 

-- High monthly charges customers (top 25%)
WITH Charge_Threshold AS (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MonthlyCharges) OVER() AS Threshold
    FROM CustomerChurnn
)
SELECT 
    'High Monthly Charges' AS Segment,
    COUNT(*) AS Total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM CustomerChurnn, Charge_Threshold
WHERE MonthlyCharges >= Threshold;

-- Long tenure customers (top 25%)
WITH tenure_threshold AS (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY tenure) OVER() AS threshold
    FROM CustomerChurnn
)
SELECT 
    'Long Tenure' AS segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM CustomerChurnn, tenure_threshold
WHERE tenure >= threshold;



--- Key Insights from the EDA:

-- Overall Churn Rate: The dataset shows a churn rate of about 26.5% (based on sample queries).
-- High-risk business impact—losing over a quarter of customers.
-- No significant gender difference (Male: 26%, Female: 27%). 
-- Gender doesn't show a significant difference in churn rates.
-- Senior citizens churn at 42% vs. 24% for non-seniors.
-- Senior citizens have slightly higher churn rates
-- Fiber optic users churn at 41% (highest).
-- DSL users churn at 19%.
-- No internet service: 7% churn.
-- Month-to-month contracts churn at 43%.
-- One-year contracts: 12% churn.
-- Two-year contracts: 3% churn.
-- Electronic check users churn at 45% (highest).
-- Automatic payments (bank/credit card) churn at 10-15%.
-- Paperless billing users churn at 34% vs. 17% for paper bills.
-- Highest churn in first year (0-12 months: 40%).
-- Lowest churn after 5+ years (60+ months: 5%).
-- High-spenders ($100+) churn at 42%.
-- Low-spenders (<$50) churn at 12%



---  TARGETED RETENTION STRATEGIES:

-- Immediate Actions (High Impact)
-- Focus on high-churn segments:
-- Fiber optic users → Improve service reliability.
-- Month-to-month contracts → Offer long-term incentives.
-- Electronic check payers → Push auto-pay discounts.
-- Reduce early churn (0-12 months):
-- Onboarding support (dedicated agent for first 3 months).
-- Free trial extensions for hesitant customers.
-- Retain high-spenders ($100+):
-- VIP customer service (priority support).
-- Exclusive perks (free streaming subscriptions).
-- Long-Term Strategies
-- Improve digital experience:
-- AI chatbot for billing questions.
-- Personalized usage insights dashboard.
--  Proactive churn prevention:
-- Predictive modeling to flag at-risk customers.
-- Automated retention offers (e.g., "We miss you—here’s 10% off").
-- Enhance loyalty programs:
-- Points for tenure milestones (e.g., 5-year reward).
-- Family plan discounts to reduce attrition.

-- CONCLUSION

-- Key Takeaways:
-- Fiber, month-to-month contracts, and electronic check users are highest risk.
-- Senior citizens and high-spenders need special attention.
-- Long-term contracts and auto-pay reduce churn significantly.


