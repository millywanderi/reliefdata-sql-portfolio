# ReliefData — Humanitarian Operations & SQL Analytics

**A practical SQL portfolio project exploring humanitarian logistics, inventory monitoring, distribution analysis, and relief resource allocation.**

[![SQL](https://img.shields.io/badge/SQL-MySQL%208.0-blue)](https://www.mysql.com/)
[![Project Status](https://img.shields.io/badge/Status-Case%20Study%20Development-orange)](https://github.com/millywanderi/reliefdata-sql-portfolio)
[![Data](https://img.shields.io/badge/Data-Fictional%20Sample-green)](#data-and-privacy)

## About the Project

ReliefData is a hands-on SQL portfolio project demonstrating relational database concepts, analytical querying, and data-driven problem-solving through a fictional humanitarian relief operation.

Humanitarian organisations need reliable information about stock availability, warehouse capacity, relief distributions, and resource allocation. Structured operational data can help identify potential shortages, monitor distribution activity, and support better planning.

This project uses a fictional dataset to investigate these operational questions using MySQL.

The project began as a practical SQL learning exercise and is evolving into a documented analytical case study. It combines SQL scripts with interpreted findings, data-quality checks, and recommendations grounded in the available data.

## Objectives

- Practise SQL for retrieving, filtering, transforming, and analysing data.
- Apply relational database concepts and joins across related tables.
- Analyse warehouse capacity, inventory levels, and distribution transactions.
- Identify inventory records below minimum stock thresholds.
- Summarise distribution quantities by item and destination.
- Detect data-quality issues that affect operational reporting.
- Apply aggregations, subqueries, CTEs, and window functions.
- Communicate findings, limitations, and practical recommendations.
- Build a reproducible portfolio project relevant to data analytics and humanitarian technology.

## Technology Stack

| Technology | Purpose |
|---|---|
| MySQL 8.0 | Relational database and analytical SQL queries |
| SQL | Data retrieval, joins, aggregation, and analysis |
| Git | Version control |
| GitHub | Project hosting and portfolio presentation |
| Python | Potential future extension for data analysis |
| Data visualisation tools | Potential future extension for charts or dashboards |

The database is maintained in a local Ubuntu environment.

## Database Overview

The current database contains three tables:

| Table | Records | Purpose |
|---|---:|---|
| `warehouses` | 4 | Warehouse names, locations, and recorded capacities |
| `inventory` | 6 | Available stock quantities and minimum stock thresholds |
| `distributions` | 5 | Distribution transactions, items, quantities, destinations, and warehouse references |

The tables are related through `warehouse_id`. The distributions table permits a NULL warehouse reference, which provides an opportunity to examine data completeness and its impact on reporting.

## Case Study: Initial Analytical Findings

The initial case study examines warehouse capacity, inventory stock levels, distribution patterns, and data quality.

### 1. Warehouse Capacity

The four warehouses have a combined recorded capacity of **11,500**.

| Warehouse | Location | Capacity | Share of total |
|---|---|---:|---:|
| Nairobi Central | Nairobi | 5,000 | 43.5% |
| Mombasa Relief Store | Mombasa | 3,000 | 26.1% |
| Kisumu Emergency Store | Kisumu | 2,000 | 17.4% |
| Garissa Reserve Store | Garissa | 1,500 | 13.0% |

Nairobi Central has the largest recorded capacity, accounting for approximately 43.5% of the total.

These values describe recorded capacity, not current stock levels, physical occupancy, or warehouse utilisation.

### 2. Inventory Stock Risk

Four of the six inventory records are below their minimum stock thresholds, representing **66.7% of the records examined**.

| Warehouse | Item | Available | Minimum | Shortfall |
|---|---|---:|---:|---:|
| Nairobi Central | Rice | 120 | 500 | 380 |
| Mombasa Relief Store | Water | 90 | 300 | 210 |
| Kisumu Emergency Store | Rice | 250 | 400 | 150 |
| Garissa Reserve Store | Blankets | 60 | 150 | 90 |

The combined shortfall is **830 units relative to the respective minimum stock thresholds**.

These inventory records warrant review for replenishment. However, the shortfall alone does not determine urgency; item criticality, expected demand, supply lead times, and the needs of affected communities would also matter.

### 3. Distribution Activity

The five recorded distribution transactions total **1,900 units**.

| Item | Transactions | Total quantity |
|---|---:|---:|
| Rice | 2 | 850 |
| Water | 1 | 800 |
| Blankets | 1 | 200 |
| First Aid Kits | 1 | 50 |

Kisumu East has the largest recorded transaction, receiving 800 units of water. Rice accounts for 850 recorded units across two transactions.

These figures describe recorded transaction quantities. They do not measure beneficiary reach, distribution effectiveness, or humanitarian impact.

### 4. Data Quality

One transaction records 50 First Aid Kits sent to Remote Community without a warehouse assignment.

This limits the ability to attribute that transaction to a source warehouse and affects warehouse-level reporting.

A potential improvement is to validate warehouse references against the warehouse table when the source is known and flag unresolved references for investigation.

## SQL Skills Demonstrated

The project includes practical work with:

- `SELECT`, `WHERE`, `LIKE`, and `ORDER BY`
- Filtering using `AND`, `IN`, and `BETWEEN`
- Conditional expressions with `CASE`
- Missing-value handling with `NULL` and `COALESCE()`
- Aggregations using `COUNT()`, `SUM()`, and `AVG()`
- Grouping with `GROUP BY` and filtering groups with `HAVING`
- Joins, including `INNER JOIN` and `LEFT JOIN`
- Subqueries and derived tables
- Common Table Expressions (CTEs)
- Window functions, including `RANK()`, `ROW_NUMBER()`, `LAG()`, and `LEAD()`
- Partitioning and comparisons using `OVER()` and `PARTITION BY`
- Derived metrics, percentages, and data-quality checks

The repository's SQL scripts provide the implementation; the case study explains the business questions and the meaning and limitations of the results.

## Recommendations

Based on the current analysis:

1. Review the four inventory records below their minimum thresholds.
2. Determine replenishment priorities using demand, item criticality, lead times, and operational context.
3. Investigate the distribution transaction with no warehouse assignment.
4. Introduce dated records of stock receipts, distributions, and adjustments to improve stock movement tracking.
5. Extend future analysis with demand forecasts, stockout history, supplier lead times, and beneficiary data where appropriate.

These are preliminary recommendations based on a small fictional dataset, not operational instructions for a real relief programme.

## Limitations

- The dataset contains only four warehouses, six inventory records, and five distribution transactions.
- All operational records are fictional and intended for learning and portfolio demonstration.
- The unit of warehouse capacity and actual warehouse occupancy are not established.
- Distribution dates, opening balances, receipts, and stock adjustments are not available in the supplied records.
- Current inventory levels cannot be causally attributed to the recorded distributions.
- The analysis does not establish warehouse efficiency, beneficiary impact, or the real-world urgency of a stock shortage.

The findings demonstrate an analytical method and should not be generalised to real humanitarian operations without additional evidence.

## Project Structure

The repository is being developed incrementally. The following is the intended structure for the case study; filenames should be updated to match the actual repository contents.


```text
reliefdata-sql-portfolio/
├── README.md
└── sql/
    ├── 03_joins.sql
    ├── 04_inventory_analysis.sql
    ├── 06_warehouse_performance.sql
    ├── 07_distribution_insights.sql
    ├── 08_subqueries.sql
    ├── 09_ctes.sql
    ├── 10_window_functions.sql
    ├── 11_advanced_window_functions.sql
    ├── 12_case_study_analysis.sql
    └── 12_inventory_distribution_analysis.sql
```

### Directory Overview

- **`README.md`** — Project overview, objectives, technologies, SQL learning progress, analytical findings, and development roadmap.
- **`sql/03_joins.sql`** — Practice with SQL joins to combine related data from multiple tables.
- **`sql/04_inventory_analysis.sql`** — Inventory analysis using filtering, aggregation, and stock-level calculations.
- **`sql/06_warehouse_performance.sql`** — Warehouse-level performance analysis using distribution data and aggregations.
- **`sql/07_distribution_insights.sql`** — Analysis of relief distributions by item, destination, and other operational dimensions.
- **`sql/08_subqueries.sql`** — Nested queries and subqueries for more advanced analytical questions.
- **`sql/09_ctes.sql`** — Common Table Expressions (CTEs) to structure complex SQL queries into readable, reusable steps.
- **`sql/10_window_functions.sql`** — Window functions for comparing records and analysing results across rows.
- **`sql/11_advanced_window_functions.sql`** — Advanced window-function practice, including ranking and changes between records.
- **`sql/12_case_study_analysis.sql`** — Consolidated case-study queries examining warehouse capacity, inventory risk, distribution patterns, and data quality.
- **`sql/12_inventory_distribution_analysis.sql`** — Inventory and distribution analysis combining stock information with distribution records.

*Note: The filenames reflect the current repository. The numbering gaps are intentional for now and can be addressed later if I decide to reorganise the learning sequence.*

## Development Roadmap

### Completed learning and analysis work

- Practised filtering, sorting, and joins.
- Applied aggregation and grouped analysis.
- Worked with subqueries and CTEs.
- Practised ranking and window functions.
- Analysed warehouse capacity, inventory thresholds, and distribution transactions.
- Identified a missing warehouse reference in the distribution data.

### Next steps

- Validate and organise the final case-study SQL scripts.
- Export selected query results for documentation.
- Create clear charts illustrating verified findings.
- Prepare a polished case-study report.
- Improve the database design documentation and repository README.
- Explore a Python-based analysis or dashboard as a future extension.

## Data and Privacy

All operational records used in this project are fictional. The project is intended for educational and portfolio purposes and does not represent the actual operations of a humanitarian organisation.

The repository will not contain confidential employer data, real beneficiary identities, private contact details, or sensitive humanitarian records.

## Project Status

**Case study in development.**

The project has progressed beyond SQL practice exercises to include reproducible analytical queries and preliminary findings. Reporting, visualisation, and final repository documentation are the next development priorities.


## Case Study Report

The ReliefData case study analyzes fictional humanitarian warehouse capacity, inventory risk, and distribution activity using MySQL 8.0. It combines SQL analysis with Python visualizations to demonstrate how data can support operational reporting.

**[Read the full case study report](docs/case_study_report.md)**

### Visualizations

- [Warehouse capacity comparison](docs/warehouse_capacity.png)
- [Available inventory vs minimum stock](docs/inventory_vs_minimum.png)
- [Distribution quantities by item](docs/distribution_by_item.png)

**Data disclaimer:** All records are fictional sample data created for portfolio and learning purposes. They do not represent actual humanitarian operations.

## About the Author

**Millicent Wanderi**

Software Engineering | SQL & Data Analytics | Humanitarian Technology

My background combines software engineering, business performance analysis, and emergency-response experience. I am interested in applying technology and data to improve operational decision-making and humanitarian resource management.

ReliefData is part of my continued development in SQL, data analytics, and data-driven problem-solving.

## Connect

- GitHub: [@millywanderi](https://github.com/millywanderi)
- Project repository: [reliefdata-sql-portfolio](https://github.com/millywanderi/reliefdata-sql-portfolio)
