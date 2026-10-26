-- ============================================================
-- Project: ReliefData - Humanitarian Operations & SQL Analytics
-- File: sql/09_ctes.sql
-- Purpose: Analyse warehouse distribution performance.
-- Database: MySQL 8+
-- ============================================================

USE reliefdata;

-- Find high-volume humanitarian items

WITH item_totals AS (
    SELECT
        item,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY item
)
SELECT
    item,
    total_quantity
FROM item_totals
WHERE total_quantity > 300
ORDER BY total_quantity DESC;

-- Warehouse performance report

WITH warehouse_totals AS (
    SELECT
        w.warehouse_name,
        COALESCE(SUM(d.quantity), 0) AS total_quantity
    FROM warehouses AS w
    LEFT JOIN distributions AS d
        ON w.warehouse_id = d.warehouse_id
    GROUP BY
        w.warehouse_id,
        w.warehouse_name
)
SELECT
    warehouse_name,
    total_quantity
FROM warehouse_totals
ORDER BY total_quantity DESC;
