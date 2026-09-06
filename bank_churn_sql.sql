CREATE DATABASE bank_churn_analysis;
USE bank_churn_analysis;

SELECT COUNT(*) AS total_rows
FROM bank_churn;

SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN Exited = 1 THEN 1
        ELSE 0
    END) AS churned_customers,
    ROUND(SUM(CASE
                WHEN Exited = 1 THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS churn_rate
FROM
    bank_churn;
    
SELECT 
    Geography,
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN Exited = 1 THEN 1
        ELSE 0
    END) AS churned_customers,
    ROUND(SUM(CASE
                WHEN Exited = 1 THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS churn_rate
FROM
    bank_churn
GROUP BY Geography
ORDER BY churn_rate DESC;

SELECT 
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50+'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN Exited = 1 THEN 1
        ELSE 0
    END) AS churned_customers,
    ROUND(SUM(CASE
                WHEN Exited = 1 THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS churn_rate
FROM
    bank_churn
GROUP BY age_group
ORDER BY churn_rate DESC;

SELECT 
    CASE
        WHEN IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS member_status,
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN Exited = 1 THEN 1
        ELSE 0
    END) AS churned_customers,
    ROUND(SUM(CASE
                WHEN Exited = 1 THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS churn_rate
FROM
    bank_churn
GROUP BY IsActiveMember
ORDER BY churn_rate DESC;

SELECT 
    NumOfProducts,
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN Exited = 1 THEN 1
        ELSE 0
    END) AS churned_customers,
    ROUND(SUM(CASE
                WHEN Exited = 1 THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS churn_rate
FROM
    bank_churn
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

SELECT 
    CASE
        WHEN CreditScore < 500 THEN '<500'
        WHEN CreditScore BETWEEN 500 AND 599 THEN '500-599'
        WHEN CreditScore BETWEEN 600 AND 699 THEN '600-699'
        WHEN CreditScore BETWEEN 700 AND 799 THEN '700-799'
        ELSE '800+'
    END AS credit_score_group,
    COUNT(*) AS total_customers,
    SUM(CASE
        WHEN Exited = 1 THEN 1
        ELSE 0
    END) AS churned_customers,
    ROUND(SUM(CASE
                WHEN Exited = 1 THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS churn_rate
FROM
    bank_churn
GROUP BY credit_score_group
ORDER BY churn_rate DESC;

