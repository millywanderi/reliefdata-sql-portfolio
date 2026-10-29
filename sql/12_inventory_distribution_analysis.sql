-- ============================================================
-- Project: ReliefData - Humanitarian Operations & SQL Analytics
-- File: sql/12_inventory_distribution_analysis.sql
-- Purpose: Practise SQL JOINs using fictional relief data.
-- Database: MySQL 8+
-- ============================================================

USE reliefdata;


-- ReliefData: Inventory and Distribution Analysis
-- Compare current inventory with recorded distribution totals.

WITH distribution_totals AS (
    SELECT
        warehouse_id,
        item,
        SUM(quantity) AS total_distributed
    FROM distributions
    WHERE warehouse_id IS NOT NULL
    GROUP BY
        warehouse_id,
        item
)
SELECT
    w.warehouse_name,
    i.item,
    i.quantity_available,
    i.minimum_stock,
    i.quantity_available - i.minimum_stock AS stock_difference,
    COALESCE(dt.total_distributed, 0) AS total_distributed
FROM inventory AS i
INNER JOIN warehouses AS w
    ON i.warehouse_id = w.warehouse_id
LEFT JOIN distribution_totals AS dt
    ON i.warehouse_id = dt.warehouse_id
    AND i.item = dt.item
ORDER BY
    stock_difference ASC;
