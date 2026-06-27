# ITC6050 — Week 4 Lab: Building a Tiny Warehouse

## Grain of fct_orders
One row represents a single order line item (one product within one order), identified by `order_item_id`.

## Query Results

### Q1
year | month |    month_name     | orders |    revenue

------+-------+-------------------+--------+---------------

2023 |     1 | January           |   2734 |  4284729.08

2023 |     2 | February          |   2461 |  3834333.83

2023 |     3 | March             |   2706 |  4290227.11

2023 |     4 | April             |   2616 |  4101593.60

2023 |     5 | May               |   2754 |  4326569.47

### Q2
category  | total_units |   revenue

------------+-------------+--------------

Category 8 |       30026 | 3173551.39

Category 34|       30155 | 3170452.09

...

### Q3
is_weekend | orders |   revenue    |    avg_line_value

------------+--------+--------------+----------------------

f          |  71429 | 112591562.62 | 315.25

t          |  28571 |  44856091.84 | 313.99

## Concept Checks

## dim_date
A pre-built date dimension is better than computing date parts on the fly because it moves the computation cost from query time to build time, making every analytical query faster. It also enables custom attributes like `is_weekend` and `fiscal_quarter` that cannot be derived from a simple `EXTRACT()` call.

## Degenerate Dimension (order_status)
Storing `order_status` directly in `fct_orders` is valid when the number of distinct values is small and stable (e.g. 5 statuses), since a separate `dim_status` table would add a JOIN with minimal benefit. You would move it to its own dimension table if status had many attributes (description, SLA, color codes) or if it changed frequently and needed slowly changing dimension (SCD) tracking.

## OLTP vs OLAP Query Comparison (Q1)
The star schema query is longer to set up (required building dimensions and a fact table) but much clearer to read — a simple JOIN to `dim_date` replaces complex `EXTRACT()` calls scattered across every query. Analytical schemas trade write complexity (ETL/ELT effort) for read simplicity (fast, readable queries for analysts).