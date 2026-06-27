WITH source AS (
    SELECT * FROM {{ source('raw', 'orders') }}
),
renamed AS (
    SELECT
        order_id,
        customer_id,
        order_date::DATE AS ordered_on,
        LOWER(status) AS status,
        total::NUMERIC(12,2) AS total_usd,
        EXTRACT(YEAR FROM order_date)::INT AS order_year,
        EXTRACT(MONTH FROM order_date)::INT AS order_month,
        CASE
            WHEN LOWER(status) IN ('delivered', 'cancelled') THEN TRUE
            ELSE FALSE
        END AS is_terminal
    FROM source
    WHERE total > 0
)
SELECT * FROM renamed