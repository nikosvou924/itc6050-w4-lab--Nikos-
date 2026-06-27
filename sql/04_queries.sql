SET search_path TO analytics;

SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(DISTINCT f.order_id) AS orders,
    SUM(f.line_revenue) AS revenue
FROM fct_orders f
JOIN dim_date d USING (date_key)
GROUP BY d.year, d.month, d.month_name
ORDER BY d.year, d.month;

SELECT
    p.category,
    SUM(f.quantity) AS total_units,
    SUM(f.line_revenue) AS revenue
FROM fct_orders f
JOIN dim_product p USING (product_key)
GROUP BY p.category
ORDER BY revenue DESC
LIMIT 10;

SELECT
    d.is_weekend,
    COUNT(DISTINCT f.order_id) AS orders,
    SUM(f.line_revenue) AS revenue,
    AVG(f.line_revenue) AS avg_line_value
FROM fct_orders f
JOIN dim_date d USING (date_key)
GROUP BY d.is_weekend;