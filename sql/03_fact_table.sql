SET search_path TO analytics;

CREATE TABLE fct_orders AS
SELECT
    oi.order_item_id,
    o.order_id,
    o.customer_id AS customer_key,
    oi.product_id AS product_key,
    TO_CHAR(o.order_date, 'YYYYMMDD')::INT AS date_key,
    o.status AS order_status,
    oi.quantity,
    oi.unit_price_at_sale,
    oi.quantity * oi.unit_price_at_sale AS line_revenue
FROM shop.orders o
JOIN shop.order_item oi USING (order_id);

ALTER TABLE fct_orders ADD PRIMARY KEY (order_item_id);

ALTER TABLE fct_orders
    ADD CONSTRAINT fk_fct_customer FOREIGN KEY (customer_key)
        REFERENCES dim_customer (customer_key),
    ADD CONSTRAINT fk_fct_product FOREIGN KEY (product_key)
        REFERENCES dim_product (product_key),
    ADD CONSTRAINT fk_fct_date FOREIGN KEY (date_key)
        REFERENCES dim_date (date_key);

CREATE INDEX idx_fct_customer ON fct_orders (customer_key);
CREATE INDEX idx_fct_product ON fct_orders (product_key);
CREATE INDEX idx_fct_date ON fct_orders (date_key);
CREATE INDEX idx_fct_status ON fct_orders (order_status);

ANALYZE analytics.fct_orders;