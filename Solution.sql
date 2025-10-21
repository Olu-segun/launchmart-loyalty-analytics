--- 1. Count the total number of customers who joined in 2023.

SELECT 
		COUNT(DISTINCT customer_id) AS count_cutomer_joined_2023,
		EXTRACT(YEAR FROM join_date) AS join_year
FROM customers
WHERE EXTRACT(YEAR FROM join_date) = 2023
GROUP BY  join_year;

--- 2. For each customer return customer_id, full_name, total_revenue (sum of total_amount from orders). Sort descending.

SELECT
		c.customer_id,
		c.full_name,
		SUM(o.total_amount) AS total_revenue
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, o.total_amount
ORDER BY o.total_amount DESC;

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

--- 8. List customers who placed more than 1 order and show customer_id, full_name, order_count, first_order_date, last_order_date.

SELECT 
		c.customer_id,
		c.full_name,
		COUNT(o.order_id) AS order_count,
		MIN(order_date) AS first_order_date,
		MAX(order_date) AS last_order_date
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) > 1
ORDER BY order_count DESC;

--- 9. Compute total loyalty points per customer. Include customers with 0 points.
SELECT 
		c.customer_id,
		c.full_name,
		COALESCE (SUM(l.points_earned),0) AS total_loyalty_points
FROM customers c
LEFT JOIN loyalty_points l
ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_loyalty_points DESC;

--- 10. Assign loyalty tiers based on total points:
--- Bronze: < 100
--- Silver: 100–499
--- Gold: >= 500
--- Output: tier, tier_count, tier_total_points

WITH loyalty_tiers AS (

		SELECT 
				c.customer_id,
				c.full_name,
				COALESCE (SUM(l.points_earned),0) AS total_loyalty_points
		FROM customers c
		LEFT JOIN loyalty_points l
		ON c.customer_id = l.customer_id
		GROUP BY c.customer_id, c.full_name
		ORDER BY total_loyalty_points DESC
)
SELECT
		CASE 
			WHEN total_loyalty_points < 100 THEN 'Bronze'
			WHEN total_loyalty_points BETWEEN 100 AND 499 THEN 'Silver'
			ELSE 'Gold'
		END AS tiers,
		COUNT(*) AS tier_count,
		SUM(total_loyalty_points) AS tier_total_points
FROM loyalty_tiers
GROUP BY tiers
ORDER BY tier_count DESC;

--- 11. Identify customers who spent more than ₦50,000 in total but have less than 200 loyalty points. Return customer_id, full_name, total_spend, total_points.
WITH amount_spend AS (
    SELECT 
        c.customer_id,
        c.full_name,
        SUM(o.total_amount) AS total_spend
    FROM customers c
    LEFT JOIN orders o 
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.full_name
),
loyalty_points AS (
    SELECT 
        l.customer_id,
        COALESCE(SUM(l.points_earned), 0) AS total_loyalty_points
    FROM loyalty_points l
    GROUP BY l.customer_id
)
SELECT 
    a.customer_id,
    a.full_name,
    a.total_spend,
    COALESCE(l.total_loyalty_points, 0) AS total_loyalty_points
FROM amount_spend a
LEFT JOIN loyalty_points l
    ON a.customer_id = l.customer_id
WHERE a.total_spend > 50000
  AND COALESCE(l.total_loyalty_points, 0) < 200
ORDER BY a.total_spend DESC;


--- 12. Flag customers as churn_risk if they have no orders in the last 90 days (relative to 2023-12-31) AND are in the Bronze tier. Return customer_id, full_name, last_order_date, total_points.

WITH last_90_days AS  (
	SELECT
			c.customer_id,
			c.full_name,
			MAX(o.order_date) AS last_order_date,
			('2023-12-31':: date - MAX(o.order_date)) AS days_interval
	FROM customers c
	LEFT JOIN orders o
	ON c.customer_id = o.customer_id
	GROUP BY c.customer_id, c.full_name, o.order_date
	HAVING ('2023-12-31':: date - MAX(o.order_date)) <= 90
	ORDER BY o.order_date ASC;
)

