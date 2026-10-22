
-- ============================================================
-- Project: ReliefData - Humanitarian Operations & SQL Analytics
-- File: sql/06_warehouse_performance.sql
-- Purpose: Analyse warehouse distribution performance.
-- Database: MySQL 8+
-- ============================================================

USE reliefdata;

-- EXERCISE 1: Count distributions per warehouse
SELECT
    w.warehouse_name,
    COUNT(d.distribution_id) AS number_of_distributions
FROM warehouses AS w
LEFT JOIN distributions AS d
    ON w.warehouse_id = d.warehouse_id
GROUP BY
    w.warehouse_id,
    w.warehouse_name
ORDER BY number_of_distributions DESC;


-- EXERCISE 2: Calculate total quantity distributed
SELECT
    w.warehouse_name,
    COALESCE(SUM(d.quantity), 0) AS total_quantity
FROM warehouses AS w
LEFT JOIN distributions AS d
    ON w.warehouse_id = d.warehouse_id
GROUP BY
    w.warehouse_id,
    w.warehouse_name
ORDER BY total_quantity DESC;


-- EXERCISE 3: Calculate average distribution quantity
SELECT
    AVG(quantity) AS average_quantity,
    MIN(quantity) AS smallest_distribution,
    MAX(quantity) AS largest_distribution
FROM distributions;


-- EXERCISE 4: Find warehouses distributing more than
-- 500 units in total
SELECT
    w.warehouse_name,
    SUM(d.quantity) AS total_quantity
FROM warehouses AS w
INNER JOIN distributions AS d
    ON w.warehouse_id = d.warehouse_id
GROUP BY
    w.warehouse_id,
    w.warehouse_name
HAVING SUM(d.quantity) > 500
ORDER BY total_quantity DESC;
