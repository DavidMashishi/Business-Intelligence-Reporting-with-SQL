-- Analyze Sales Performance over time Months

SELECT 
	MONTH(order_date)AS Order_Year,
	SUM(sales_amount) AS Total_Sales,
	COUNT(DISTINCT customer_key) as Total_customers,
	SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);