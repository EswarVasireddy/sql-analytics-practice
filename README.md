# SQL Analytics Practice

A small retail dataset (customers, products, orders, order items) used to
practice writing SQL for common business questions — the kind of query a
Data/Business Analyst gets asked in interviews and on the job.

## Schema

```
customers (customer_id, first_name, last_name, email, city, signup_date)
products  (product_id, product_name, category, unit_price)
orders    (order_id, customer_id -> customers, order_date, status)
order_items (order_item_id, order_id -> orders, product_id -> products, quantity)
```

`orders.status` is one of `completed`, `pending`, or `cancelled`. Revenue
queries filter to `completed` orders unless noted otherwise.

## Contents

| File | What it does |
|---|---|
| `schema.sql` | Creates the four tables above with primary/foreign keys |
| `seed_data.sql` | Inserts 10 customers, 8 products, 15 orders, and their line items |
| `queries.sql` | 15 standalone business-question queries, each with a comment explaining the ask |

## Business questions answered

1. Total revenue from completed orders
2. Revenue by product category
3. Top 3 customers by spend
4. Order count by status
5. Customers who never ordered (`LEFT JOIN` / `NULL` check)
6. Best-selling product by units
7. Monthly revenue trend
8. Average order value
9. Customer spend ranked within their city (`RANK() OVER PARTITION BY`)
10. Cancellation rate per customer
11. Products that have never been ordered
12. Running total of revenue by order date (window function)
13. Repeat customers (more than one completed order)
14. Average unit price by category (CTE)
15. New customers by signup month

## Getting started

Works with SQLite out of the box:

```bash
sqlite3 retail.db < schema.sql
sqlite3 retail.db < seed_data.sql
sqlite3 -header -column retail.db < queries.sql
```

For MySQL/Postgres, swap `AUTOINCREMENT` for `AUTO_INCREMENT` / `SERIAL`
(noted inline in `schema.sql`) — the queries themselves are standard ANSI
SQL and run unmodified on both.

## Notes

All 15 queries were run against the seed data to confirm they execute and
return sensible results before being committed here.
