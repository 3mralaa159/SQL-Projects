-- 1. How Are Orders Distributed by Country?
SELECT 
    "COUNTRY", 
    COUNT(DISTINCT "ORDERNUMBER") AS "Total_Orders", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "COUNTRY"
ORDER BY 
    "Total_Sales" DESC;

-- 2. What Are the Most Common Customer Locations (e.g., City, State)?
SELECT 
    "CITY", 
    "STATE", 
    COUNT(DISTINCT "ORDERNUMBER") AS "Total_Orders", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "CITY", "STATE"
ORDER BY 
    "Total_Sales" DESC;

-- 3. Which Regions Have the Highest Order Volume?
SELECT 
    "TERRITORY", 
    COUNT(DISTINCT "ORDERNUMBER") AS "Total_Orders"
FROM 
    "sales_data_sample"
GROUP BY 
    "TERRITORY"
ORDER BY 
    "Total_Orders" DESC;

-- 4. What Is the Average Delivery Time by Territory?
SELECT 
    "TERRITORY", 
    AVG(DATE_PART('day', "DELIVERYDATE" - "ORDERDATE")) AS "Avg_Delivery_Time_Days"
FROM 
    "sales_data_sample"
WHERE 
    "DELIVERYDATE" IS NOT NULL
GROUP BY 
    "TERRITORY"
ORDER BY 
    "Avg_Delivery_Time_Days";

-- 5. Shipping Patterns Based on Address Information
SELECT 
    "CITY", 
    "STATE", 
    COUNT(DISTINCT "ORDERNUMBER") AS "Total_Orders", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "CITY", "STATE"
ORDER BY 
    "Total_Sales" DESC;
