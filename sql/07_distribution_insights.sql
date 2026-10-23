-- ============================================================
-- Project: ReliefData - Humanitarian Operations & SQL Analytics
-- File: sql/06_inventory_analysis.sql
-- Purpose: Warehouses distribute the most supplies and which items are being sent to communities.
-- Database: MySQL 8+
-- ============================================================

USE reliefdata;

-- Distribution totals by item

SELECT
    item,
    SUM(quantity) AS total_quantity
FROM distributions
GROUP BY item
ORDER BY total_quantity DESC;
