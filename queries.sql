-- queries.sql
-- Business questions answered against the schema/data in this repo.
-- Each query is written to run standalone after schema.sql + seed_data.sql.

-- 1. Total revenue from completed orders.
SELECT ROUND(SUM(p.unit_price * oi.quantity), 2) AS total_revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'completed';

-- 2. Revenue by product category, highest first.
SELECT p.category,
       ROUND(SUM(p.unit_price * oi.quantity), 2) AS category_revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY p.category
ORDER BY category_revenue DESC;

-- 3. Top 3 customers by total completed spend.
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer_name,
       ROUND(SUM(p.unit_price * oi.quantity), 2) AS total_spent
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 3;

-- 4. Number of orders per status.
SELECT status, COUNT(*) AS order_count
FROM orders
GROUP BY status
ORDER BY order_count DESC;

-- 5. Customers who have never placed an order (LEFT JOIN + NULL check).
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer_name
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- 6. Best-selling product by units sold (completed orders only).
SELECT p.product_name, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id
ORDER BY units_sold DESC
LIMIT 1;

-- 7. Monthly revenue trend (completed orders only).
SELECT strftime('%Y-%m', o.order_date) AS month,
       ROUND(SUM(p.unit_price * oi.quantity), 2) AS monthly_revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY month
ORDER BY month;

-- 8. Average order value (completed orders only).
SELECT ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
    SELECT o.order_id, SUM(p.unit_price * oi.quantity) AS order_total
    FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    JOIN orders o ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY o.order_id
);

-- 9. Customers ranked by spend within their city (window function).
SELECT c.city, c.first_name || ' ' || c.last_name AS customer_name,
       ROUND(SUM(p.unit_price * oi.quantity), 2) AS total_spent,
       RANK() OVER (
           PARTITION BY c.city
           ORDER BY SUM(p.unit_price * oi.quantity) DESC
       ) AS rank_in_city
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id;

-- 10. Cancellation rate per customer (orders placed vs. cancelled).
SELECT c.first_name || ' ' || c.last_name AS customer_name,
       COUNT(*) AS orders_placed,
       SUM(CASE WHEN o.status = 'cancelled' THEN 1 ELSE 0 END) AS orders_cancelled,
       ROUND(100.0 * SUM(CASE WHEN o.status = 'cancelled' THEN 1 ELSE 0 END) / COUNT(*), 1) AS cancel_rate_pct
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING orders_cancelled > 0;

-- 11. Products that have never been ordered.
SELECT p.product_name
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL;

-- 12. Running total of completed revenue by order date (window function).
SELECT o.order_date, o.order_id,
       ROUND(SUM(p.unit_price * oi.quantity), 2) AS order_total,
       ROUND(SUM(SUM(p.unit_price * oi.quantity)) OVER (ORDER BY o.order_date, o.order_id), 2) AS running_total
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY o.order_id
ORDER BY o.order_date, o.order_id;

-- 13. Repeat customers — placed more than one completed order.
SELECT c.first_name || ' ' || c.last_name AS customer_name,
       COUNT(*) AS completed_orders
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id
HAVING completed_orders > 1;

-- 14. Average unit price by category, using a CTE.
WITH category_prices AS (
    SELECT category, unit_price FROM products
)
SELECT category, ROUND(AVG(unit_price), 2) AS avg_price
FROM category_prices
GROUP BY category
ORDER BY avg_price DESC;

-- 15. New customers per signup month (customer acquisition trend).
SELECT strftime('%Y-%m', signup_date) AS signup_month,
       COUNT(*) AS new_customers
FROM customers
GROUP BY signup_month
ORDER BY signup_month;
