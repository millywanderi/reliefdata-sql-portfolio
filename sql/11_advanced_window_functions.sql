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
