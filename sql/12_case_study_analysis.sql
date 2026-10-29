
-- ============================================================
-- ReliefData Case Study
-- File: sql/12_case_study_analysis.sql
-- Purpose: Validate warehouse, inventory and distribution
--          findings for the portfolio case study.
-- Database: reliefdata (MySQL 8.0)
-- ============================================================

USE reliefdata;

-- 1. WAREHOUSE CAPACITY
-- Calculate total capacity and each warehouse's share.

SELECT
    warehouse_name,
    location,
    capacity,
    SUM(capacity) OVER () AS total_network_capacity,
    ROUND(
        capacity * 100.0 / SUM(capacity) OVER (),
        1
    ) AS capacity_share_pct
FROM warehouses
ORDER BY capacity DESC;


-- 2. INVENTORY STOCK STATUS
-- Identify records below, at, or above minimum stock.

SELECT
    w.warehouse_name,
    i.item,
    i.quantity_available,
    i.minimum_stock,
    i.quantity_available - i.minimum_stock AS stock_difference,
    CASE
        WHEN i.quantity_available < i.minimum_stock
            THEN 'Below minimum stock'
        WHEN i.quantity_available = i.minimum_stock
            THEN 'At minimum stock'
        ELSE 'Above minimum stock'
    END AS stock_status
FROM inventory AS i
INNER JOIN warehouses AS w
    ON i.warehouse_id = w.warehouse_id
ORDER BY stock_difference ASC;


-- 3. INVENTORY RISK SUMMARY
-- Count records below minimum and calculate total shortfall.

SELECT
    COUNT(*) AS total_inventory_records,
    SUM(
        CASE
            WHEN quantity_available < minimum_stock THEN 1
            ELSE 0
        END
    ) AS records_below_minimum,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN quantity_available < minimum_stock THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS percentage_below_minimum,
    SUM(
        CASE
            WHEN quantity_available < minimum_stock
                THEN minimum_stock - quantity_available
            ELSE 0
        END
    ) AS total_shortfall_units
FROM inventory;


-- 4. DISTRIBUTION SUMMARY BY ITEM

SELECT
    item,
    COUNT(*) AS transaction_count,
    SUM(quantity) AS total_quantity_distributed
FROM distributions
GROUP BY item
ORDER BY total_quantity_distributed DESC;


-- 5. DISTRIBUTION SUMMARY BY DESTINATION

SELECT
    destination,
    COUNT(*) AS transaction_count,
    SUM(quantity) AS total_quantity_received
FROM distributions
GROUP BY destination
ORDER BY total_quantity_received DESC;


-- 6. DATA QUALITY: MISSING WAREHOUSE REFERENCES

SELECT
    COUNT(*) AS transactions_without_warehouse,
    COALESCE(SUM(quantity), 0) AS quantity_without_warehouse
FROM distributions
WHERE warehouse_id IS NULL;


-- 7. DISTRIBUTION TOTALS BY WAREHOUSE AND ITEM
-- Exclude unassigned warehouse references from this
-- warehouse-level comparison because their origin is unknown.

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
    COALESCE(dt.total_distributed, 0) AS total_distributed
FROM inventory AS i
INNER JOIN warehouses AS w
    ON i.warehouse_id = w.warehouse_id
LEFT JOIN distribution_totals AS dt
    ON i.warehouse_id = dt.warehouse_id
    AND i.item = dt.item
ORDER BY
    w.warehouse_name,
    i.item;
