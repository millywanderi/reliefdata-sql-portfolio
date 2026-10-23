-- ============================================================
-- Project: ReliefData - Humanitarian Operations & SQL Analytics
-- File: sql/07_inventory_analysis.sql
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

-- Number of destinations served

SELECT
    destination,
    COUNT(*) AS distribution_records
FROM distributions
GROUP BY destination
ORDER BY distribution_records DESC;

-- High-volume items

SELECT
    item,
    SUM(quantity) AS distributed_quantity
FROM distributions
GROUP BY item
HAVING distributed_quantity > 300
ORDER BY distributed_quantity DESC;

-- Warehouse distribution summary
SELECT
    warehouses.warehouse_name,
    COALESCE(SUM(distributions.quantity), 0) AS total_quantity_distributed
FROM warehouses
    LEFT JOIN distributions
        ON warehouses.warehouse_id = distributions.warehouse_id
GROUP BY 
     warehouses.warehouse_id,
     warehouses.warehouse_name;
