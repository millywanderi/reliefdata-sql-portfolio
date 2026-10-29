#!usr/bin/env python3

import matplotlib.pyplot as plt
from pathlib import Path

# Output folder: docs/
OUTPUT_DIR = Path(__file__).resolve().parent.parent / "docs"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# All values below are based on the verified fictional sample data.

# Chart 1: Warehouse capacity
warehouses = [
    "Nairobi Central",
    "Mombasa Relief Store",
    "Kisumu Emergency Store",
    "Garissa Reserve Store",
]
capacity = [5000, 3000, 2000, 1500]

plt.figure(figsize=(9, 5))
plt.barh(warehouses[::-1], capacity[::-1])
plt.xlabel("Recorded capacity")
plt.title("Warehouse Capacity Comparison")
plt.tight_layout()
plt.savefig(OUTPUT_DIR / "warehouse_capacity.png", dpi=200)
plt.close()

# Chart 2: Available inventory versus minimum stock
labels = [
    "Nairobi Central — Rice",
    "Mombasa Relief Store — Water",
    "Kisumu Emergency Store — Rice",
    "Garissa Reserve Store — Blankets",
    "Mombasa Relief Store — First Aid Kits",
    "Nairobi Central — Blankets",
]
available = [120, 90, 250, 60, 450, 800]
minimum = [500, 300, 400, 150, 100, 200]

positions = list(range(len(labels)))
height = 0.38

plt.figure(figsize=(11, 6))
plt.barh(
    [p + height / 2 for p in positions],
    available,
    height=height,
    label="Available quantity",
)
plt.barh(
    [p - height / 2 for p in positions],
    minimum,
    height=height,
    label="Minimum stock",
)
plt.yticks(positions, labels)
plt.xlabel("Quantity (units)")
plt.title("Available Inventory vs Minimum Stock")
plt.legend()
plt.gca().invert_yaxis()
plt.tight_layout()
plt.savefig(OUTPUT_DIR / "inventory_vs_minimum.png", dpi=200)
plt.close()

# Chart 3: Distribution totals by item
items = ["Rice", "Water", "Blankets", "First Aid Kits"]
distributed = [850, 800, 200, 50]

plt.figure(figsize=(8, 5))
plt.bar(items, distributed)
plt.ylabel("Recorded quantity distributed (units)")
plt.title("Distribution Quantities by Item")
plt.tight_layout()
plt.savefig(OUTPUT_DIR / "distribution_by_item.png", dpi=200)
plt.close()

print("Charts created:")
for filename in [
    "warehouse_capacity.png",
    "inventory_vs_minimum.png",
    "distribution_by_item.png",
]:
    print(OUTPUT_DIR / filename)
