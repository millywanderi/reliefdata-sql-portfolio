
-- ============================================================
-- Project: ReliefData - Humanitarian Operations & SQL Analytics
-- File: 03_joins.sql
-- Purpose: Practise SQL JOINs using fictional relief data.
-- ============================================================

-- BUSINESS CONTEXT
-- Humanitarian organisations need to understand warehouse
-- capacity and relief distribution activity.

USE reliefdata;

-- ------------------------------------------------------------
-- EXERCISE 1: INNER JOIN
-- Question: Which warehouses have recorded distributions?
-- ------------------------------------------------------------

SELECT
    w.warehouse_id,
    w.warehouse_name,
    w.county,
    d.distribution_id,
    d.quantity
FROM warehouses AS w
INNER JOIN distributions AS d
    ON w.warehouse_id = d.warehouse_id;


-- ------------------------------------------------------------
-- EXERCISE 2: LEFT JOIN
-- Question: List every warehouse, including those with
-- no recorded distributions.
-- ------------------------------------------------------------

SELECT
    w.warehouse_id,
    w.warehouse_name,
    w.county,
    d.distribution_id,
    d.quantity
FROM warehouses AS w
LEFT JOIN distributions AS d
    ON w.warehouse_id = d.warehouse_id;


-- ------------------------------------------------------------
-- EXERCISE 3: RIGHT JOIN
-- Question: List every distribution, including any distribution
-- that has no matching warehouse record.
-- ------------------------------------------------------------

SELECT
    w.warehouse_name,
    d.distribution_id,
    d.warehouse_id,
    d.quantity
FROM warehouses AS w
RIGHT JOIN distributions AS d
    ON w.warehouse_id = d.warehouse_id;


-- ------------------------------------------------------------
-- EXERCISE 4: JOIN + AGGREGATION
-- Question: How much relief stock was distributed by each
-- warehouse, including warehouses with zero distributions?
-- ------------------------------------------------------------

SELECT
    w.warehouse_id,
    w.warehouse_name,
    COALESCE(SUM(d.quantity), 0) AS total_distributed
FROM warehouses AS w
LEFT JOIN distributions AS d
    ON w.warehouse_id = d.warehouse_id
GROUP BY
    w.warehouse_id,
    w.warehouse_name
ORDER BY total_distributed DESC;
