-- 1. Which Contacts Have the Most Orders?
SELECT 
    "CONTACTFIRSTNAME", 
    "CONTACTLASTNAME", 
    COUNT(DISTINCT "ORDERNUMBER") AS "Total_Orders"
FROM 
    "sales_data_sample"
GROUP BY 
    "CONTACTFIRSTNAME", "CONTACTLASTNAME"
ORDER BY 
    "Total_Orders" DESC;

-- 2. Which Contacts Have the Highest Sales Contribution?
SELECT 
    "CONTACTFIRSTNAME", 
    "CONTACTLASTNAME", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "CONTACTFIRSTNAME", "CONTACTLASTNAME"
ORDER BY 
    "Total_Sales" DESC;

-- 3. How Does Sales Break Down by Contact Territory?
SELECT 
    "TERRITORY", 
    "CONTACTFIRSTNAME", 
    "CONTACTLASTNAME", 
    SUM("SALES") AS "Total_Sales"
FROM 
    "sales_data_sample"
GROUP BY 
    "TERRITORY", "CONTACTFIRSTNAME", "CONTACTLASTNAME"
ORDER BY 
    "Total_Sales" DESC;

-- 4. Are There Contacts with No Sales?
SELECT 
    "CONTACTFIRSTNAME", 
    "CONTACTLASTNAME"
FROM 
    "sales_data_sample"
GROUP BY 
    "CONTACTFIRSTNAME", "CONTACTLASTNAME"
HAVING 
    SUM("SALES") = 0;
