-- ============================================================
-- Project: ReliefData - Humanitarian Operations & SQL Analytics
-- File: sql/08_warehouse_performance.sql
-- Purpose: Analyse warehouse distribution performance.
-- Database: MySQL 8+
-- ============================================================

USE reliefdata;

-- identify distribution records with quantities larger than the average quantity across all distribution records

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
