-- ============================================================
-- Project: ReliefData - Humanitarian Operations & SQL Analytics
-- File: sql/11_advanced_window_functions.sql
-- Purpose: Practise SQL JOINs using fictional relief data.
-- Database: MySQL 8+
-- ============================================================

USE reliefdata;

-- Rank warehouses by distribution performance

WITH warehouse_distribution_performance AS (
    SELECT
        w.warehouse_name,
        COALESCE(SUM(d.quantity), 0) AS total_distributed
        FROM warehouses AS w
        LEFT JOIN distributions AS d
            ON w.warehouse_id = d.warehouse_id
        GROUP BY
            w.warehouse_id,
            w.warehouse_name
),
warehouse_rank_cte AS (
    SELECT
        warehouse_name,
        total_distributed,
        RANK () OVER (
            ORDER BY total_distributed DESC
        ) AS warehouse_rank
    FROM warehouse_distribution_performance
)
SELECT
    warehouse_name,
    total_distributed,
    warehouse_rank
FROM warehouse_rank_cte
WHERE warehouse_rank IN (1,2)
ORDER BY total_distributed DESC;

-- Compare each warehouse with the previous warehouse

WITH previous_quantity_distributed AS (
    SELECT
        w.warehouse_name,
        COALESCE(SUM(d.quantity), 0) AS total_distributed
    FROM warehouses AS w
    LEFT JOIN distributions AS d
        ON w.warehouse_id = d.warehouse_id
    GROUP BY
        w.warehouse_id,
        w.warehouse_name
),
previous_quantity_cte AS (
    SELECT
        warehouse_name,
        total_distributed,
        LAG(total_distributed) OVER (
            ORDER BY total_distributed DESC
        ) AS previous_warehouse_quantity
    FROM previous_quantity_distributed
)
SELECT
    warehouse_name,
    total_distributed,
    previous_warehouse_quantity,
    total_distributed - previous_warehouse_quantity AS quantity_difference
FROM previous_quantity_cte
ORDER BY total_distributed DESC;

-- Calculate the percentage change between warehouses

WITH percentage_change_cte AS (
    SELECT
        w.warehouse_name,
        COALESCE(SUM(d.quantity), 0) AS total_distributed
    FROM warehouses AS w
    LEFT JOIN distributions AS d
        ON w.warehouse_id = d.warehouse_id
    GROUP BY
        w.warehouse_id,
        w.warehouse_name
),
previous_quantity_cte AS (
    SELECT
        warehouse_name,
        total_distributed,
        LAG(total_distributed) OVER (
            ORDER BY total_distributed DESC
        ) AS previous_warehouse_quantity
    FROM percentage_change_cte
)
SELECT
    warehouse_name,
    total_distributed,
    previous_warehouse_quantity,
    ROUND(
        (
            (total_distributed - previous_warehouse_quantity) 
            / NULLIF(previous_warehouse_quantity, 0)
        ) * 100, 2
    ) AS percentage_change
FROM previous_quantity_cte
ORDER BY total_distributed DESC;

-- Compare each warehouse with the average

WITH warehouse_average_cte AS (
    SELECT
        w.warehouse_name,
        COALESCE(SUM(d.quantity), 0) AS total_distributed
    FROM warehouses AS w
    LEFT JOIN distributions AS d
        ON w.warehouse_id = d.warehouse_id
    GROUP BY
        w.warehouse_id,
        w.warehouse_name
),
average_distributed_cte AS (
    SELECT
        warehouse_name,
        total_distributed,
        AVG(total_distributed) OVER () AS average_distributed
    FROM warehouse_average_cte
)
SELECT
    warehouse_name,
    total_distributed,
    average_distributed,
    total_distributed - average_distributed AS difference_from_average
FROM average_distributed_cte
ORDER BY difference_from_average DESC;
