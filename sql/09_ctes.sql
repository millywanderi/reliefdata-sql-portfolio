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
