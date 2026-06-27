-- sql/02_dimensions.sql
SET search_path TO analytics;

-- dim_date (date spine για 2023-01-01 → 2026-12-31)
CREATE TABLE dim_date AS
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INT AS date_key,
    d::DATE AS full_date,
    EXTRACT(YEAR FROM d)::INT AS year,
    EXTRACT(MONTH FROM d)::INT AS month,
    TO_CHAR(d, 'Month') AS month_name,
    EXTRACT(QUARTER FROM d)::INT AS quarter,
    EXTRACT(DOY FROM d)::INT AS day_of_year,
    EXTRACT(DOW FROM d)::INT AS day_of_week,
    TO_CHAR(d, 'Day') AS day_name,
    CASE WHEN EXTRACT(DOW FROM d) IN (0,6)
        THEN TRUE ELSE FALSE END AS is_weekend
FROM generate_series(
    '2023-01-01'::DATE,
    '2026-12-31'::DATE,
    INTERVAL '1 day'
) g(d);

ALTER TABLE dim_date ADD PRIMARY KEY (date_key);

-- dim_customer
CREATE TABLE dim_customer AS
SELECT
    customer_id AS customer_key,
    email,
    first_name,
    last_name,
    first_name || ' ' || last_name AS full_name,
    created_at::DATE AS customer_since
FROM shop.customer;

ALTER TABLE dim_customer ADD PRIMARY KEY (customer_key);

-- dim_product
CREATE TABLE dim_product AS
SELECT
    p.product_id AS product_key,
    p.name AS product_name,
    c.name AS category,
    p.unit_price AS current_price
FROM shop.product p
JOIN shop.category c USING (category_id);

ALTER TABLE dim_product ADD PRIMARY KEY (product_key);