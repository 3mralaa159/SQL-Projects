-- 1. Total Sales by Order
SELECT 
    "ORDERNUMBER", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "ORDERNUMBER"
ORDER BY 
    "Total_Sales" DESC;

-- 2. Total Quantity Ordered by Order
SELECT 
    "ORDERNUMBER", 
    SUM("QUANTITYORDERED") AS "Total_Quantity_Ordered"
FROM 
    "sales_data_sample"
GROUP BY 
    "ORDERNUMBER"
ORDER BY 
    "Total_Quantity_Ordered" DESC;

-- 3. Average Sales per Order
SELECT 
    "ORDERNUMBER", 
    AVG("SALES") AS "Avg_Sales_Per_Order"
FROM 
    "sales_data_sample"
GROUP BY 
    "ORDERNUMBER"
ORDER BY 
    "Avg_Sales_Per_Order" DESC;

-- 4. Orders by Status (e.g., Completed, Pending)
SELECT 
    "STATUS", 
    COUNT("ORDERNUMBER") AS "Total_Orders", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "STATUS"
ORDER BY 
    "Total_Sales" DESC;

-- 5. Highest and Lowest Sales by Transaction
SELECT 
    "ORDERNUMBER", 
    "SALES"
FROM 
    "sales_data_sample"
ORDER BY 
    "SALES" DESC
LIMIT 1;

SELECT 
    "ORDERNUMBER", 
    "SALES"
FROM 
    "sales_data_sample"
ORDER BY 
    "SALES" ASC
LIMIT 1;

-- 6. Number of Orders in Each Quarter
SELECT 
    "YEAR_ID", 
    "QTR_ID", 
    COUNT(DISTINCT "ORDERNUMBER") AS "Total_Orders"
FROM 
    "sales_data_sample"
GROUP BY 
    "YEAR_ID", "QTR_ID"
ORDER BY 
    "YEAR_ID", "QTR_ID";

-- 7. Total Sales and Quantity Ordered by Product
SELECT 
    "PRODUCTCODE", 
    SUM("SALES") AS "Total_Sales", 
    SUM("QUANTITYORDERED") AS "Total_Quantity_Ordered"
FROM 
    "sales_data_sample"
GROUP BY 
    "PRODUCTCODE"
ORDER BY 
    "Total_Sales" DESC;

-- 8. Average Order Value (AOV) for Each Customer
SELECT 
    "CUSTOMERNAME", 
    AVG("SALES" / "QUANTITYORDERED") AS "Avg_Order_Value"
FROM 
    "sales_data_sample"
GROUP BY 
    "CUSTOMERNAME"
ORDER BY 
    "Avg_Order_Value" DESC;

-- 9. Distribution of Sales Over Time (e.g., Yearly, Monthly)
SELECT 
    "YEAR_ID", 
    "MONTH_ID", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "YEAR_ID", "MONTH_ID"
ORDER BY 
    "YEAR_ID", "MONTH_ID";
