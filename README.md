# Customer Retention Strategy Analysis for Retail Banking

> A retail bank wants to understand which customer characteristics and behaviors are associated with customer churn.

## Business Context

A retail bank wants to understand which customer characteristics and behaviors are associated with customer churn. The analysis is positioned from the perspective of a data analyst supporting customer retention decisions. The decision trigger is the need to understand where customer attrition is concentrated so retention efforts can be targeted rather than applied broadly. The analysis focuses on turning a messy customer/account dataset into a validated analytical dataset and then using EDA and SQL to identify high-risk customer segments and practical retention opportunities.

## Objectives

* Measure the overall customer churn rate to understand the scale of customer attrition.
* Identify customer characteristics associated with higher churn, including geography, age, credit score, and account balance.
* Analyze whether customer engagement and product usage are associated with churn.
* Identify high-risk customer segments based on demographic, behavioral, and product-related characteristics.
* Translate the findings into actionable customer retention strategies.

## Business Questions

1. What is the overall customer churn rate?
2. Which geography has the highest customer churn rate?
3. Which age groups have the highest customer churn?
4. Are inactive customers more likely to churn?
5. Does the number of products a customer holds affect churn?
6. Is credit score associated with customer churn?
7. Are customers with higher account balances more likely to churn?
8. Which combinations of customer characteristics define the highest-risk segments?

## Data

### Source

`Bank_Churn_Messy.xlsx`, provided with the project, containing two source sheets:

* `Customer_Info` — customer-level demographic, credit, tenure, and salary information.
* `Account_Info` — account/product, activity, card, tenure, and churn information.

The cleaned analytical output is saved as `cleaned_bank_churn.csv`.

### Grain

**One row per customer** in the final analytical dataset, identified by `CustomerId`.

### Time Span

**Not available in the source data.** The dataset contains no date/timestamp field, so this project evaluates customer attributes and churn status rather than churn trends over time.

### Volume

| Stage                            | Records |
| -------------------------------- | ------: |
| `Customer_Info` source sheet     |  10,001 |
| `Account_Info` source sheet      |  10,002 |
| Final cleaned analytical dataset |  10,000 |

### Schema

| Column             | Type     | Description                            | Role               |
| ------------------ | -------- | -------------------------------------- | ------------------ |
| `CustomerId`       | Integer  | Unique customer identifier             | Key                |
| `Surname`          | Text     | Customer surname                       | Customer attribute |
| `CreditScore`      | Integer  | Customer credit score                  | Feature            |
| `Geography`        | Text     | Customer market/country                | Feature            |
| `Gender`           | Text     | Customer gender                        | Feature            |
| `Age`              | Numeric  | Customer age                           | Feature            |
| `Tenure`           | Integer  | Customer tenure                        | Feature            |
| `EstimatedSalary`  | Numeric  | Estimated customer salary              | Feature            |
| `Balance`          | Numeric  | Account balance                        | Feature            |
| `NumOfProducts`    | Integer  | Number of products held                | Feature            |
| `HasCrCard`        | Text     | Whether customer has a credit card     | Feature            |
| `IsActiveMember`   | Text     | Whether customer is an active member   | Feature            |
| `Exited`           | Integer  | Churn flag: 1 = churned, 0 = retained  | Target             |
| `AgeGroup`         | Category | Derived age band used for EDA          | Derived            |
| `CreditScoreGroup` | Category | Derived credit-score band used for EDA | Derived            |

## Methodology

### 1. Data Preparation

The source workbook was split across customer and account information, so the first step was to combine the two datasets on `CustomerId`. A left join was used to preserve the customer-level population while bringing in account attributes.

The duplicate `Tenure` field created by the merge was resolved by keeping one tenure column. Duplicate records were then removed so the analytical grain remained one row per customer.

### 2. Data Cleaning

The following cleaning decisions were applied:

* Removed duplicate rows after merging the source sheets.
* Converted `EstimatedSalary` from currency-formatted text to numeric values.
* Converted `Balance` from currency-formatted text to numeric values.
* Replaced missing surnames with `MISSING` and missing ages with the median age.
* Replaced the invalid salary placeholder `-999999` with the median estimated salary.
* Standardized France geography values (`FRA`, `French`, and `France`) into a single `France` category.

Median imputation was preferred to mean imputation for the numeric missing/placeholder cases because it is less sensitive to extreme values, while categorical standardization prevents the same market from being split across multiple labels.

### 3. Data Validation

Validation checks were used to make sure the cleaned dataset was analytically usable:

* Confirmed final dataset dimensions and column names.
* Checked data types and remaining missing values.
* Confirmed zero duplicate rows after cleaning.
* Checked categorical values for `Geography`, `Gender`, `IsActiveMember`, and `Exited`.
* Checked numerical fields for negative values.
* Checked that ages were not below 18.
* Checked that credit scores fell within 300–850.
* Checked that `NumOfProducts` was greater than zero.
* Checked that `Exited` contained only 0/1.

The resulting cleaned dataset contains **10,000 rows and 15 columns**, with **0 missing values and 0 duplicate rows**.

### 4. Exploratory Analysis

Churn was analyzed using group-level counts and churn rates. This approach was chosen because the project is focused on explaining **where churn is concentrated** and producing business-readable segment insights rather than building a predictive model.

* **Overall churn rate:** direct count-and-rate calculation to establish the size of the retention problem.
* **Geography, age, activity, products, and credit score:** grouped churn-rate comparisons to make differences between customer segments easy to interpret.
* **Account balance:** distribution comparison between retained and churned customers to assess whether financial value may be associated with churn.
* **High-risk segmentation:** combinations of geography, age group, activity status, and product count were evaluated, with a minimum segment size of 50 customers to reduce the chance of over-interpreting very small groups.

No predictive machine-learning model was used in this phase because the stated objectives are descriptive and diagnostic: identify patterns, quantify segment risk, and turn those patterns into retention actions.

## Key Findings

### 1. Churn is material: about 1 in 5 customers churned

The final dataset contains **10,000 customers**, of whom **2,037 churned**, producing an overall churn rate of **20.37%**.

**What it means:** customer retention is a significant business issue, large enough to justify targeted retention analysis rather than isolated case-by-case intervention.

### 2. Germany is the highest-churn market

| Geography | Customers | Churned | Churn Rate |
| --------- | --------: | ------: | ---------: |
| Germany   |     2,509 |     814 | **32.44%** |
| Spain     |     2,477 |     413 |     16.67% |
| France    |     5,014 |     810 |     16.15% |

**What it means:** churn is disproportionately concentrated in Germany, so market-specific investigation should be a priority.

### 3. Churn increases sharply with age in the analyzed age bands

| Age Group | Customers | Churned | Churn Rate |
| --------- | --------: | ------: | ---------: |
| Under 30  |     1,641 |     124 |      7.56% |
| 30–39     |     4,347 |     473 |     10.88% |
| 40–49     |     2,617 |     806 |     30.80% |
| 50+       |     1,395 |     634 | **45.45%** |

**What it means:** the 50+ segment has the highest observed churn rate and deserves closer examination of service needs, engagement, and product fit.

### 4. Inactive members are substantially more likely to churn

| Member Status | Customers | Churned | Churn Rate |
| ------------- | --------: | ------: | ---------: |
| Active        |     5,151 |     735 |     14.27% |
| Inactive      |     4,849 |   1,302 | **26.85%** |

**What it means:** lower engagement is associated with materially higher churn, making inactivity a useful retention-monitoring signal.

### 5. Product count shows the strongest segmentation effect in the analysis

| Products Held | Customers | Churned |  Churn Rate |
| ------------- | --------: | ------: | ----------: |
| 1             |     5,084 |   1,409 |      27.71% |
| 2             |     4,590 |     348 |       7.58% |
| 3             |       266 |     220 |  **82.71%** |
| 4             |        60 |      60 | **100.00%** |

**What it means:** the 3–4 product segments are extremely high-churn groups, but they are also much smaller than the 1–2 product groups. These results should therefore trigger product-fit and data-quality investigation rather than automatic assumptions about causation.

### 6. Lower credit scores show somewhat higher churn, but the relationship is weaker

The `<500` credit-score group has the highest observed churn rate at **23.73%**, while the other credit-score bands are close to the overall rate.

**What it means:** credit score appears useful as a supporting segmentation variable, but it is not as sharply differentiated in this analysis as geography, age, activity, or product count.

### 7. Churned customers have higher account balances on average

| Customer Status | Average Balance | Median Balance |
| --------------- | --------------: | -------------: |
| Retained        |       72,745.30 |      92,072.68 |
| Churned         |   **91,108.54** | **109,349.29** |

**What it means:** churn is not necessarily limited to low-balance customers. Retention teams should consider **value at risk** as well as churn probability when prioritizing outreach.

### 8. High-risk combinations are more informative than single variables alone

Among segments with at least 50 customers, the highest observed churn rates include:

| Geography | Age   | Activity | Products | Customers | Churn Rate |
| --------- | ----- | -------- | -------: | --------: | ---------: |
| Germany   | 50+   | Inactive |        1 |       126 | **88.89%** |
| France    | 50+   | Inactive |        1 |       148 | **87.16%** |
| Spain     | 50+   | Inactive |        1 |        52 | **82.69%** |
| Germany   | 40–49 | Inactive |        1 |       247 | **64.37%** |

**What it means:** combinations of age, geography, engagement, and product ownership can isolate much higher-risk groups than broad population averages.

## Recommendations

| Recommendation                       | Owner / Team                            | Evidence                                                  | Suggested Action                                                                                                                                                             |
| ------------------------------------ | --------------------------------------- | --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Prioritize high-risk customer lists  | CRM / Customer Retention                | High churn in multi-factor segments                       | Build an outreach list combining geography, age, activity, products, and balance; prioritize customers before churn occurs.                                                  |
| Re-engage inactive members           | CRM / Relationship Management           | 26.85% churn vs. 14.27% for active members                | Trigger personalized calls, digital nudges, service check-ins, and relevant product recommendations for inactive customers.                                                  |
| Investigate Germany specifically     | Germany Market / Customer Experience    | 32.44% churn, highest geography                           | Review service quality, product fit, pricing, customer experience, and local competitive pressures before deploying market-specific retention actions.                       |
| Review unusual product combinations  | Product / Customer Experience           | 82.71% churn for 3 products and 100% for 4 products       | Audit those segments first for product-fit issues, customer dissatisfaction, operational problems, and data anomalies; avoid broad cross-selling based on this result alone. |
| Protect high-value customers at risk | Relationship Managers / Premium Banking | Churned customers have higher average and median balances | Combine churn indicators with balance to identify financially important customers for proactive relationship-manager intervention.                                           |

> **Decision principle:** prioritize customers by a combination of **churn risk and value at risk**, not churn rate alone.

## Limitations & Assumptions

* The dataset has **no date field**, so this analysis cannot explain when churn occurred, whether churn is accelerating, or how retention changed over time.
* The analysis is **descriptive**. The observed relationships are associations, not evidence that age, geography, inactivity, credit score, balance, or product count causes churn.
* Customer satisfaction, complaints, service interactions, pricing, competitor activity, tenure history, and marketing-contact history are not available, limiting root-cause analysis.
* The extreme churn rates in the 3- and 4-product groups occur in relatively small populations (266 and 60 customers respectively), so those groups should be investigated and validated before being used for broad policy decisions.
* Missing age and invalid salary placeholders were imputed using medians; this preserves the dataset for analysis but may reduce uncertainty visible in those fields.
* The project assumes that `Exited = 1` represents churn and `Exited = 0` represents retention.
* The final analytical dataset is treated at the customer level after duplicate removal, so repeated source records are not interpreted as separate customers.

## Repository Guide

```text
bank-churn-analysis/
│
├── README.md
├── data/
│   ├── Bank_Churn_Messy.xlsx
│   └── cleaned_bank_churn.csv
│
├── notebooks/
│   └── Bank_Churn_Prep.ipynb
│
├── sql/
│   └── bank_churn_sql.sql
│
├── screenshots/
│   └── sql/
│
├── requirements.txt
└── .gitignore
```


## Project Status

**Next phase:** Power BI dashboard and interactive storytelling layer.
