-- ============================================================
-- Project: ReliefData - Humanitarian Operations & SQL Analytics
-- File: sql/04_inventory_analysis.sql
-- Purpose: Monitor relief inventory and identify low stock.
-- Database: MySQL 8+
-- ============================================================

USE reliefdata;

-- ------------------------------------------------------------
-- STEP 1: CREATE THE INVENTORY TABLE
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS inventory (
    inventory_id INT PRIMARY KEY,
    warehouse_id INT NOT NULL,
    item VARCHAR(100) NOT NULL,
    quantity_available INT NOT NULL,
    minimum_stock INT NOT NULL,
    FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id)
);

-- ------------------------------------------------------------
-- STEP 2: INSERT SAMPLE INVENTORY
-- Run this INSERT only once.
-- ------------------------------------------------------------

INSERT INTO inventory
    (inventory_id, warehouse_id, item, quantity_available, minimum_stock)
    VALUES
        (1, 1, 'Rice', 120, 500),
        (2, 1, 'Blankets', 800, 200),
        (3, 2, 'Water', 90, 300),
        (4, 2, 'First Aid Kits', 450, 100),
        (5, 3, 'Rice', 250, 400),
        (6, 4, 'Blankets', 60, 150);

-- ------------------------------------------------------------
-- STEP 3: VIEW ALL INVENTORY
-- ------------------------------------------------------------

SELECT * FROM inventory;

-- ------------------------------------------------------------
-- STEP 4: CLASSIFY INVENTORY STATUS
-- ------------------------------------------------------------

SELECT
    w.warehouse_name,
    i.item,
    i.quantity_available,
    i.minimum_stock,
    CASE
        WHEN i.quantity_available <= i.minimum_stock
            THEN 'LOW STOCK'
        ELSE 'NORMAL'
    END AS stock_status
FROM inventory as i
INNER JOIN warehouses as w
    ON i.warehouse_id = w.warehouse_id
ORDER BY i.quantity_available ASC;
