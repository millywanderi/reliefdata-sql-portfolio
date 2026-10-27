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

-- Warehouse performance report

WITH warehouse_totals AS (
    SELECT
        w.warehouse_name,
        COALESCE(SUM(d.quantity), 0) AS total_quantity
    FROM warehouses AS w
    LEFT JOIN distributions AS d
        ON w.warehouse_id = d.warehouse_id
    GROUP BY
        w.warehouse_id,
        w.warehouse_name
)
SELECT
    warehouse_name,
    total_quantity
FROM warehouse_totals
ORDER BY total_quantity DESC;

-- Find total quantities greater than the average total across all warehouses

WITH warehouse_totals AS (
    SELECT
        w.warehouse_name,
        COALESCE(SUM(d.quantity), 0) AS total_quantity
    FROM warehouses AS w
    LEFT JOIN distributions AS d
        ON w.warehouse_id = d.warehouse_id
    GROUP BY
        w.warehouse_id,
        w.warehouse_name
)
SELECT
    warehouse_name,
    total_quantity
FROM warehouse_totals
WHERE total_quantity > (
    SELECT AVG(total_quantity)
        FROM warehouse_totals
)
ORDER BY total_quantity DESC;

-- Find items with total distributed quantity greater than the average quantity

WITH item_totals AS (
    SELECT
        item,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY item
),
average_item_quantity AS (
    SELECT
        AVG(total_quantity) AS average_quantity
    FROM item_totals
)
SELECT
    item,
    total_quantity
FROM item_totals
WHERE total_quantity > (
    SELECT
        average_quantity
    FROM average_item_quantity
)
ORDER BY total_quantity DESC;

-- Find destinations more supplies than the average quantity distributed

WITH destination_totals AS (
    SELECT
        destination,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY destination
),
average_destination_quantity AS (
    SELECT
        AVG(total_quantity) AS average_quantity
    FROM destination_totals
)
SELECT
    destination,
    total_quantity
FROM destination_totals
WHERE total_quantity > (
    SELECT
        average_quantity 
    FROM
        average_destination_quantity
)
ORDER BY total_quantity DESC;

-- Find each warehouse's total quantity distributed alongside the number of distribution records it has handled

WITH warehouse_totals AS (
    SELECT
        w.warehouse_name,
        COALESCE(SUM(d.quantity), 0) AS total_quantity,
        COUNT(d.distribution_id) AS distribution_count
    FROM warehouses as w
    LEFT JOIN distributions as d
        ON w.warehouse_id = d.warehouse_id
    GROUP BY
        w.warehouse_id,
        w.warehouse_name
),
warehouse_counts AS (
    SELECT
        w.warehouse_name,
        COUNT(d.distribution_id) AS distribution_count
    FROM warehouses AS w
    LEFT JOIN distributions AS d
        ON w.warehouse_id = d.warehouse_id
    GROUP BY
        w.warehouse_id,
        w.warehouse_name
)
SELECT
    wt.warehouse_name,
    wt.total_quantity,
    wc.distribution_count
FROM warehouse_totals AS wt
JOIN warehouse_counts AS wc
    ON wt.warehouse_name = wc.warehouse_name
ORDER BY wt.total_quantity DESC;

-- Find how much of each warehouse's capacity has been used by distributed supplies

WITH warehouse_capacity AS (
    SELECT
        w.warehouse_name,
        w.capacity,
        COALESCE(SUM(d.quantity), 0) AS total_quantity
    FROM warehouses AS w
    LEFT JOIN distributions AS d
        ON w.warehouse_id = d.warehouse_id
    GROUP BY
        w.warehouse_id,
        w.warehouse_name,
        w.capacity
)
SELECT
    warehouse_name,
    capacity,
    total_quantity,
    capacity - total_quantity AS remaining_capacity,
    ROUND((total_quantity / capacity) * 100, 2)
        AS utilization_percentage,
    CONCAT(
        ROUND((total_quantity / capacity) * 100, 2),
       '%' 
    ) AS utilization_display
FROM warehouse_capacity
ORDER BY utilization_percentage DESC;

-- Find total distributed quantity is greater than the average total quantity per item

WITH distribution_items AS (
    SELECT
        item,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY item
),
average_distributed_items AS (
    SELECT
        AVG(total_quantity) AS average_item_quantity
    FROM distribution_items
)
SELECT
    di.item,
    di.total_quantity,
    adi.average_item_quantity
FROM distribution_items AS di
CROSS JOIN average_distributed_items AS adi
WHERE di.total_quantity > adi.average_item_quantity
ORDER BY di.total_quantity DESC;

