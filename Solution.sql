--- 1. Count the total number of customers who joined in 2023.

SELECT 
		COUNT(DISTINCT customer_id) AS count_cutomer_joined_2023,
		EXTRACT(YEAR FROM join_date) AS join_year
FROM customers
GROUP BY  join_year;

--- 2. For each customer return customer_id, full_name, total_revenue (sum of total_amount from orders). Sort descending.

SELECT  
		C.customer_id,
		C.full_name,
		SUM(O.total_amount) AS total_revenue
FROM customers C
INNER JOIN orders O
ON C.customer_id = O.customer_id
GROUP BY C.customer_id, O.total_amount
ORDER BY O.total_amount DESC;

--- 3. Return the top 5 customers by total_revenue with their rank.

SELECT  
		c.customer_id,
		c.full_name,
		SUM(o.total_amount) AS total_revenue,
		RANK() OVER( ORDER BY SUM(O.total_amount) DESC ) AS customer_rank
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, o.total_amount
ORDER BY o.total_amount DESC
LIMIT 5;

--- 4. Produce a table with year, month, monthly_revenue for all months in 2023 ordered chronologically.

SELECT 
		EXTRACT(YEAR FROM order_date) AS year,
		EXTRACT(MONTH FROM order_date) AS month,
		SUM(total_amount) AS monthly_revenue
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2023
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY month ASC;

--- 5. Find customers with no orders in the last 60 days relative to 2023-12-31 (i.e., consider last active date up to 2023-12-31). 
---    Return customer_id, full_name, last_order_date.
SELECT
		c.customer_id,
		c.full_name,
		MAX(o.order_date) AS last_order_date,
		('2023-12-31':: date - MAX(o.order_date)) AS days_interval
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name, o.order_date
HAVING ('2023-12-31':: date - MAX(o.order_date)) > 60
ORDER BY o.order_date ASC;

--- 6. Calculate average order value (AOV) for each customer: return customer_id, full_name, 
---     aov (average total_amount of their orders). Exclude customers with no orders.
SELECT 
		c.customer_id,
		c.full_name,
		ROUND(AVG(o.total_amount),1) AS average_order_value
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY average_order_value DESC;

--- 7. For all customers who have at least one order, compute customer_id, full_name, total_revenue, 
---   spend_rank where spend_rank is a dense rank, highest spender = rank 1.

SELECT 
		c.customer_id,
		c.full_name,
		SUM(o.total_amount) AS total_revenue,
		DENSE_RANK() OVER( ORDER BY SUM(o.total_amount) DESC) AS dense_rank
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;




SELECT * FROM orders
