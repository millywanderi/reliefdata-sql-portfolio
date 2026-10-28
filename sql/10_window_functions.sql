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

-- Running total of relief distributions

WITH quantity_distributed_accumulates AS (
    SELECT
        item,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY item
)
SELECT
    item,
    total_quantity,
    SUM(total_quantity) OVER(ORDER BY total_quantity DESC) AS running_total
FROM quantity_distributed_accumulates
ORDER BY total_quantity DESC;

-- Compare each item with the previous item

WITH compare_quantity_distributed AS (
    SELECT
        item,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY item
)
SELECT
    item,
    total_quantity,
    LAG(total_quantity) OVER (
        ORDER BY total_quantity DESC
    ) AS previous_item_quantity,
    total_quantity - LAG(total_quantity) OVER (
        ORDER BY total_quantity DESC
    ) AS quantity_difference
FROM compare_quantity_distributed
ORDER BY total_quantity DESC;

-- Identify large drops in distributions

WITH large_drops_distributions AS (
    SELECT
        item,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY item
)
SELECT
    item,
    total_quantity,
    LAG(total_quantity) OVER (
        ORDER BY total_quantity DESC
    ) AS previous_item_quantity,
    LAG(total_quantity) OVER (
        ORDER BY total_quantity DESC
    ) - total_quantity AS quantity_drop
FROM large_drops_distributions
ORDER BY total_quantity DESC;

-- Find items with a drop greater than 100

WITH distribution_item_drop AS (
    SELECT
        item,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY item
),
previous_distributed_item AS (
    SELECT
        item,
        total_quantity,
        LAG(total_quantity) OVER (
            ORDER BY total_quantity DESC
        ) AS previous_item_quantity,
        LAG(total_quantity) OVER (
            ORDER BY total_quantity DESC
        ) - total_quantity AS quantity_drop
        FROM distribution_item_drop
)
SELECT
    item,
    total_quantity,
    previous_item_quantity,
    quantity_drop
FROM previous_distributed_item
WHERE quantity_drop > 100
ORDER BY total_quantity DESC;

-- Find items with an above-average drop

WITH distribution_above_average AS (
    SELECT
        item,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY item
),
above_average_drop AS (
    SELECT
        item,
        total_quantity,
        LAG(total_quantity) OVER (
            ORDER BY total_quantity DESC
        ) AS previous_item_quantity,
        LAG(total_quantity) OVER (
            ORDER BY total_quantity DESC
        ) - total_quantity AS quantity_drop
    FROM distribution_above_average
),
above_average_cte AS (
    SELECT AVG(quantity_drop) AS average_drop
    FROM above_average_drop
)

SELECT
    d.item,
    d.total_quantity,
    d.previous_item_quantity,
    d.quantity_drop,
    a.average_drop
FROM above_average_drop AS d
CROSS JOIN above_average_cte AS a
WHERE quantity_drop > average_drop
ORDER BY total_quantity DESC;

-- Look ahead to the next item

WITH look_ahead_next AS (
    SELECT
        item,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY item
),
next_item AS (
    SELECT
        item,
        total_quantity,
        LEAD(total_quantity) OVER (
            ORDER BY total_quantity DESC
        ) AS next_item_quantity
    FROM look_ahead_next
)
SELECT
    item,
    total_quantity,
    next_item_quantity,
    total_quantity - next_item_quantity AS quantity_difference
FROM next_item
ORDER BY total_quantity DESC;

-- Find items whose quantity exceeds the next item's quantity by more than 100

WITH look_ahead_next AS (
    SELECT
        item,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY item
),
next_item AS (
    SELECT
        item,
        total_quantity,
        LEAD(total_quantity) OVER (
            ORDER BY total_quantity DESC
        ) AS next_item_quantity,
        total_quantity - LEAD(total_quantity) OVER (
            ORDER BY total_quantity DESC
        ) AS quantity_difference
    FROM look_ahead_next
)
SELECT
    item,
    total_quantity,
    next_item_quantity,
    quantity_difference
FROM next_item
WHERE quantity_difference > 100
ORDER BY total_quantity DESC;

-- Give every item a unique position

WITH item_unique_position AS (
    SELECT
        item,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY item
)
SELECT
    item,
    total_quantity,
    ROW_NUMBER () OVER (
        ORDER BY total_quantity DESC
    ) AS item_position
FROM item_unique_position
ORDER BY total_quantity DESC;

-- Find the top two relief items

WITH top_relief_items AS (
    SELECT
        item,
        SUM(quantity) AS total_quantity
    FROM distributions
    GROUP BY item
),
row_number_cte AS (
    SELECT
        item,
        total_quantity,
        ROW_NUMBER () OVER (
            ORDER BY total_quantity DESC
        ) AS item_position
    FROM top_relief_items
)
SELECT
    item,
    total_quantity,
    item_position
FROM row_number_cte
WHERE item_position IN (1, 2)
ORDER BY total_quantity DESC;
