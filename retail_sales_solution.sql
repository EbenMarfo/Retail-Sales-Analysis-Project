-------------------------------------------
-- Retail Sales Data Analysis
-------------------------------------------

-- Business Questions --

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT 
	* 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' 
	-- and the quantity sold is more than 4 in the month of Nov-2022
SELECT 
	*
FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY 1;

-- Q4. Write a SQL query to find the average age of customers who purchased items from 
	--	the 'Beauty' category.
SELECT 
	ROUND(AVG(age), 1) AS AVG_age
FROM retail_sales
WHERE category = 'Beauty'

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
	* 
FROM retail_sales
WHERE 	
	total_sale > 1000;

-- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by 
	-- each gender in each category.
SELECT 
	category,
	gender,
	COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1;

-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling 
	--month in each year
SELECT 
	year,
	month,
	avg_sale
FROM 
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		TO_CHAR(sale_date, 'month') AS month,
		round(AVG(total_sale)::numeric, 2) AS avg_sale,
		RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) 
			ORDER BY AVG(total_sale)DESC) AS rank
	FROM retail_sales
	GROUP BY 1, 2
) 
WHERE rank = 1

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT
	customer_id,
	SUM(total_sale) total_sales
FROM retail_sales
GROUP BY 1
LIMIT 5

-- Q9. Write a SQL query to find the number of unique customers who purchased items 
	-- from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY 1

-- Q10. Write a SQL query to create each shift and number of orders 
	-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale AS (
  SELECT *, 
    CASE 
      WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning' 
      WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 16 THEN 'Afternoon' 
      ELSE 'Evening' 
    END as shift 
  FROM retail_sales
)
SELECT shift, COUNT(*) as total_orders 
FROM hourly_sale 
GROUP BY shift
ORDER BY 2 DESC

/*
SELECT 
  CASE 
    WHEN sale_time < '12:00:00' THEN 'Morning' 
    WHEN sale_time >= '12:00:00' AND sale_time < '17:00:00' THEN 'Afternoon' 
    ELSE 'Evening' 
  END AS shift_category, 
  COUNT(*) AS orders 
FROM retail_sales 
GROUP BY shift_category
ORDER BY 2 DESC;
*/






