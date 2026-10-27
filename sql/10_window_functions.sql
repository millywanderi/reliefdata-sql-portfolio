-- ============================================================
-- Project: ReliefData - Humanitarian Operations & SQL Analytics
-- File: sql/10_window_functions.sql
-- Purpose: Analyse warehouse distribution performance.
-- Database: MySQL 8+
-- ============================================================

USE reliefdata;

-- Find relief items that received the highest total distribution quantities, ranked from highest to lowest

SELECT
    item,
    SUM(quantity) AS total_quantity,
    RANK () OVER(ORDER BY SUM(quantity) DESC) AS item_rank
FROM distributions
GROUP BY item
ORDER BY total_quantity DESC;

-- Compare each relief item with the overall total

WITH item_totals AS (
    SELECT
        item,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY item
)
SELECT
    item,
    total_quantity,
    SUM(total_quantity) OVER() AS overall_quantity,
    CONCAT(
        ROUND((total_quantity / SUM(total_quantity) OVER()) *100, 2),
        '%'
    ) AS percentage_of_total
FROM item_totals
ORDER BY total_quantity DESC;
