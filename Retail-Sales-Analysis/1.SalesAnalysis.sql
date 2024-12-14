-- 1. Total Revenue Generated Over Time
SELECT 
    "ORDERDATE", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "ORDERDATE"
ORDER BY 
    "ORDERDATE";

-- 2. Monthly, Quarterly, and Yearly Sales Trends
-- Monthly Sales Trend
SELECT 
    "YEAR_ID", "MONTH_ID", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "YEAR_ID", "MONTH_ID"
ORDER BY 
    "YEAR_ID", "MONTH_ID";

-- Quarterly Sales Trend
SELECT 
    "YEAR_ID", "QTR_ID", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "YEAR_ID", "QTR_ID"
ORDER BY 
    "YEAR_ID", "QTR_ID";

-- Yearly Sales Trend
SELECT 
    "YEAR_ID", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "YEAR_ID"
ORDER BY 
    "YEAR_ID";

-- 3. Highest and Lowest Sales by Month and Quarter
-- Highest Sales by Month
SELECT 
    "YEAR_ID", "MONTH_ID", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "YEAR_ID", "MONTH_ID"
ORDER BY 
    "Total_Sales" DESC
LIMIT 1;

-- Lowest Sales by Month
SELECT 
    "YEAR_ID", "MONTH_ID", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "YEAR_ID", "MONTH_ID"
ORDER BY 
    "Total_Sales" ASC
LIMIT 1;

-- 4. Average Order Value (AOV) Over Time
SELECT 
    "ORDERDATE", 
    AVG("SALES" / "QUANTITYORDERED") AS "Avg_Order_Value"
FROM 
    "sales_data_sample"
GROUP BY 
    "ORDERDATE"
ORDER BY 
    "ORDERDATE";
-----------------------------------------------------------
