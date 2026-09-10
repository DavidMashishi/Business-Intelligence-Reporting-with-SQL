-- Analyze Sales Performance over time year

SELECT 
	YEAR(order_date)AS Order_Year,
	SUM(sales_amount) AS Total_Sales,
	COUNT(DISTINCT customer_key) as Total_customers,
	SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);
-- Analyze Sales Performance over time month
SELECT 
	MONTH(order_date)AS Order_Year,
	SUM(sales_amount) AS Total_Sales,
	COUNT(DISTINCT customer_key) as Total_customers,
	SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);
--------------------------------------------------------------------------------------------------------------------
-- Cumulative Analysis
-- Calculate the total sales per month and the running total of sales over time
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER (ORDER BY order_date ) AS running_total_sales,
AVG(avg_price) OVER (ORDER BY order_date ) AS moving_average
	FROM
(SELECT 
	DATETRUNC(YEAR,order_date) AS order_date,
	SUM(sales_amount) AS total_sales,
	AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR,order_date)
)t;
----------------------------------------------------------------------------------------------------------------------
-- Performance Analysis
-- Analyze the yearly performance of product's by comparing each products sales to both
-- its average sales performance and previous year's sales
WITH yearly_product_sale AS
(
	SELECT 
		YEAR(f.order_date) AS order_year,
		p.product_name,
		SUM(f.sales_amount) AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(f.order_date),p.product_name
)

SELECT 
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'below avg'
		 ELSE 'Avg'
	END avg_change,
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) as prev_year_sales
FROM yearly_product_sale
ORDER BY product_name,order_year
------------------------------------------------------------------------------------------------------------------------- 
 -- Part To Whole Analysis
 -- Which categories contribute the most to overall sales
WITH category_sales AS (	
	SELECT 
		category,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales f
	LEFT JOIN  gold.dim_products p
	ON p.product_key = f.product_key
	GROUP BY category)
SELECT
	Category,
	total_sales,
	SUM(total_sales) OVER () AS overall_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT)/ SUM(total_sales) OVER ()) * 100,2),'%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
--------------------------------------------------------------------------------------------------------------------
-- Data Segmentation
-- Segment products into cost ranges and count how many products fall into each segment
WITH 	product_segment AS (
	SELECT 
		Product_key,
		product_name,
		cost,
		CASE WHEN cost < 100 THEN 'Below'
			WHEN cost  BETWEEN 100 AND 500 THEN '100 - 500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500 - 1000'
			ELSE 'Above 1000'
		END cost_range
	FROM gold.dim_products)

SELECT 
	 cost_range,
	 COUNT(product_key) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC;

-- /*Group customers into three segments based on their spending behaviour:
-- VIP: Customers with at least 12 months of history and spedning more the 5,000
-- Regular: Customers with at least 12 months of history but spending 5000 or less
-- New Customers with a lifespan less than 12 months
-- and find total number of customers by each group */
WITH customer_spending AS (
	SELECT 
		c.customer_key,
		SUM(f.sales_amount) AS total_spending,
		MIN(order_date) AS first_order,
		MAX(order_date) AS last_order,
		DATEDIFF(MONTH,min(order_date), MAX(order_date)) AS lifespan
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON f.customer_key = c.customer_key
	GROUP BY c.customer_key
	)

	SELECT 
		customer_segment,
		COUNT(customer_key) AS total_customers
	FROM (
		SELECT 
		customer_key,
		CASE WHEN lifespan >=  12 AND total_spending > 5000 THEN 'Vip'
			 WHEN Lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
			 ELSE 'New'
		END customer_segment
	FROM customer_spending)t
GROUP BY customer_segment 
ORDER BY total_customers;
--------------------------------------------------------------------------------------------
/*-- Reporting  
	Purpose: This report consolidates key customer metrics and behaviours 
	Highlight:
	Essential fields such as names, ages, and transactional details.
	segment products by revenue to identify high performers, mid range and low performers
	Aggregate prduct level metrics by 
		total sales
		total orders
		total quantity sold 
		lifespan (in months)
	KPIs:
		receny (months since last order)
		average order value (AOR)
		average monthly spend
*/

WITH base_query AS(
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
SELECT
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
	DATEDIFF(year, c.birthdate, GETDATE()) age
	FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL)

, customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_date) AS last_order_date,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
	customer_key,
	customer_number,
	customer_name,
	age
)
SELECT
customer_key,
customer_number,
customer_name,
age,
CASE 
	 WHEN age < 20 THEN 'Under 20'
	 WHEN age between 20 and 29 THEN '20-29'
	 WHEN age between 30 and 39 THEN '30-39'
	 WHEN age between 40 and 49 THEN '40-49'
	 ELSE '50 and above'
END AS age_group,
CASE 
    WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
    WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
    ELSE 'New'
END AS customer_segment,
last_order_date,
DATEDIFF(month, last_order_date, GETDATE()) AS recency,
total_orders,
total_sales,
total_quantity,
total_products
lifespan,
--  average order value (AVO)
CASE WHEN total_sales = 0 THEN 0
	 ELSE total_sales / total_orders
END AS avg_order_value,
--  average monthly spend
CASE WHEN lifespan = 0 THEN total_sales
     ELSE total_sales / lifespan
END AS avg_monthly_spend
FROM customer_aggregation;
----------------------------------------------------------------------------------------------------

/*-- Reporting 2
-- Purpose: This report consolidates key product metric and behaviour
Highlight:
	segment products by revenue to identify high performers, mid range and low performers
	Aggregate prduct level metrics by 
		total sales
		total orders
		total quantity sold 
		total customers (unique)
	KPIs:
		receny (months since last sale)
		average order revenue (AOR)
		average monthly revenue
*/

WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
    SELECT
	    f.order_number,
        f.order_date,
		f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL  -- only consider valid sales dates
),

product_aggregations AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
    MAX(order_date) AS last_sale_date,
    COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query

GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost
)

/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- Average Order Revenue (AOR)
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,

	-- Average Monthly Revenue
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_revenue
FROM product_aggregations;
