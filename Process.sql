-- What are total sales and total profits of each year?
select date_part('year',"OrderDate") as year ,sum(sales) as sales ,sum(profit) as profit
from sales
group by 1 
order by 1

-- What are the total profits and total sales per year,quarter?
select date_part('year',"OrderDate") as year , date_part('quarter',"OrderDate") as quarter,sum(sales) as sales ,sum(profit) as profit
from sales
group by 1 , 2
order by 1 , 2

SELECT
date_part('year', "OrderDate") AS year,
CASE
WHEN date_part('month', "OrderDate") IN (1,2,3) THEN 'Q1'
WHEN date_part('month', "OrderDate") IN (4,5,6) THEN 'Q2'
WHEN date_part('month', "OrderDate") IN (7,8,9) THEN 'Q3'
ELSE 'Q4'
END AS quarter,
SUM(sales) AS sales,
SUM(profit) AS profit
FROM sales
group by 1 ,2
order by 1,2


select quarter , sum(sales) , sum(profit)
from(SELECT
date_part('year', "OrderDate") AS year,
CASE
WHEN date_part('month', "OrderDate") IN (1,2,3) THEN 'Q1'
WHEN date_part('month', "OrderDate") IN (4,5,6) THEN 'Q2'
WHEN date_part('month', "OrderDate") IN (7,8,9) THEN 'Q3'
ELSE 'Q4'
END AS quarter,
SUM(sales) AS sales,
SUM(profit) AS profit
FROM sales
group by 1 ,2
order by 1,2) a
group by 1 

-- What region generates the highest sales and profits ?
select region , sum(sales) as sales , sum(profit) as profit
from sales 
group by 1 
order by profit desc 

-- Profit margin
select region , round(sum(profit)/sum(sales)*100,2) profit_margin 
from sales 
group by 1 
order by profit_margin desc 

-- What state and city brings in the highest sales and profits ?
-- states:-
-- top 10
select "state" , sum(sales) sales , sum(profit) profit , round(sum(profit)/sum(sales)*100,2) profit_margin 
from sales 
group by 1 
order by profit desc 
limit 10 
-- bottom 10
select "state" , sum(sales) sales , sum(profit) profit , round(sum(profit)/sum(sales)*100,2) profit_margin 
from sales 
group by 1 
order by profit Asc 
limit 10 
  
-- Cities :-
select city , sum(sales) sales , sum(profit) profit , round(sum(profit)/sum(sales)*100,2) profit_margin 
from sales 
group by 1 
order by profit desc   
limit 10 

select city , sum(sales) sales , sum(profit) profit , round(sum(profit)/sum(sales)*100,2) profit_margin 
from sales 
group by 1 
order by profit asc
limit 10 

-- The relationship between discount and sales and the total discount per category

