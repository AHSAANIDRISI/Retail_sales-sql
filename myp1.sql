create database mysql_p1;
use mysql_p1;
drop table if exists retail_sales;
create table retail_sales(
    transactions_id int primary key, 
	sale_date date, 
    sale_time time, 
    customer_id	int,
    gender varchar(15),
	age int ,
	category varchar(15),
    quantiy int,
	price_per_unit	float,
    cogs float,
    total_sale int 
);

DROP TABLE retail_sales;
-- total sales made
 select count(*) total_sale from retail_sales;
 select * from retail_sales limit 30;
-- total unique customers 
select count(distinct customer_id) as  total_sale from retail_sales; 
 -- total unique category
 
 -- Bussiness Analysis 
 -- sales made on specific date 
 select * from retail_sales where sale_date='2022-11-05';
 
 SELECT category, COUNT(*) AS total_sale
FROM retail_sales
WHERE category = 'Clothing'
  AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
  AND quantiy > 2
  group by category;
-- total sales by category   
select category,sum(total_sale) as net_sales from retail_sales 
group by category;
-- avg age of persons doing sales by category
select category,avg(age) as avg_age from retail_sales 
group by category;
-- avg age of persons doing sales by beauty category 
select category,avg(age) as avg_age from retail_sales 
where category='Beauty'
group by category;
-- transactions greater than 1000
select * from retail_sales 
where total_sale>1000;
--
select category,
gender ,
count(*) as transactions
from retail_sales 
group by category,
gender;
-- custoners with most sales in a year and month 
SELECT sales_year, sales_month, total_sales
FROM (
    SELECT 
        YEAR(sale_date) AS sales_year,
        MONTH(sale_date) AS sales_month,
        SUM(total_sale) AS total_sales,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY SUM(total_sale) DESC) AS rnk
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS monthly_sales
WHERE rnk = 1;
-- top customers with the sales 
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC;
-- grouping unique customers based on the category 
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sales
GROUP BY category;
--  grouping sales made based on shifts morning evening and night 
WITH hourly_sales AS (
    SELECT *,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
)
SELECT shift,
       COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;