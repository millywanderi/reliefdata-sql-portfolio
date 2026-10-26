-- ============================================================
-- Project: ReliefData - Humanitarian Operations & SQL Analytics
-- File: sql/08_warehouse_performance.sql
-- Purpose: Analyse warehouse distribution performance.
-- Database: MySQL 8+
-- ============================================================

USE reliefdata;

-- ============================================================
-- identify distribution records with quantities larger than 
-- the average quantity across all distribution records
-- ============================================================

SELECT
    distribution_id,
    item,
    quantity, 
    destination
FROM distributions
WHERE quantity > 
    (SELECT AVG(quantity) 
    FROM distributions)
ORDER BY quantity DESC;

-- Find warehouses above the average warehouse total

SELECT
    w.warehouse_name,
    COALESCE(SUM(d.quantity), 0) AS total_quantity_distributed
FROM warehouses AS w
LEFT JOIN distributions AS d
    ON w.warehouse_id = d.warehouse_id
GROUP BY
    w.warehouse_id,
    w.warehouse_name
HAVING COALESCE(SUM(d.quantity), 0) > (
    SELECT AVG(warehouse_totals.total_quantity)
    FROM (
        SELECT
            w2.warehouse_id,
            COALESCE(SUM(d2.quantity), 0) AS total_quantity
        FROM warehouses AS w2
        LEFT JOIN distributions AS d2
            ON w2.warehouse_id = d2.warehouse_id
        GROUP BY
            w2.warehouse_id,
            w2.warehouse_name
    ) AS warehouse_totals
)
ORDER BY total_quantity_distributed DESC;

-- Find items above the average total quantity distributed
SELECT
    item,
    COALESCE(SUM(quantity), 0) AS total_quantity_distributed
FROM distributions
GROUP BY item
HAVING SUM(quantity) > (
    SELECT AVG(item_distributed.total_quantity)
    FROM (
        SELECT
            item,
            COALESCE(SUM(quantity), 0) AS total_quantity
        FROM distributions
        GROUP BY item
   ) AS item_distributed
)
ORDER BY total_quantity_distributed DESC;
