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
GROUP BY item;
