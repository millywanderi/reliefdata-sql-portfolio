# ReliefData — Humanitarian Operations & SQL Analytics

**A practical SQL portfolio project exploring humanitarian logistics, emergency response, inventory monitoring, and relief resource allocation.**

[![SQL](https://img.shields.io/badge/SQL-Learning%20%26%20Practice-blue)](https://en.wikipedia.org/wiki/SQL)
[![Project Status](https://img.shields.io/badge/Status-In%20Development-orange)](#project-status)
[![Data](https://img.shields.io/badge/Data-Synthetic-green)](#data-privacy)

## About the Project

ReliefData is a hands-on portfolio project developed to demonstrate practical SQL, relational database concepts, and data analysis skills through a fictional humanitarian relief operation.

Humanitarian organisations must make decisions about stock availability, warehouse operations, relief distributions, and resource allocation, often under time pressure. Reliable data can help decision-makers identify shortages, monitor distribution activities, and improve operational planning.

This project uses a fictional dataset to explore how SQL can help answer these questions.

The project is being developed alongside my SQL studies. Each stage introduces new concepts and applies them to practical business questions.

## Objectives

- Practise SQL queries for retrieving, filtering, and sorting data.
- Understand relational database design and relationships between tables.
- Apply `INNER JOIN`, `LEFT JOIN`, and `RIGHT JOIN`.
- Analyse inventory and relief distribution records.
- Identify stock shortages and distribution patterns.
- Develop skills in data aggregation, subqueries, CTEs, and window functions.
- Document SQL solutions and explain their operational significance.
- Build a portfolio demonstrating practical analytical and technical skills.

## Technology Stack

| Technology | Purpose |
|---|---|
| SQL | Querying, transforming, and analysing relational data |
| Relational databases | Storing and connecting operational records |
| Git | Version control and tracking changes |
| GitHub | Project hosting and portfolio presentation |
| Python | Potential future extension for data analysis |
| Data visualisation tools | Potential future extension for dashboards |

The database platform will be documented once the project environment is finalised.

## Project Structure

```text
reliefdata-sql-portfolio/
├── README.md
├── sql/
│   ├── 01_table_creation.sql
│   ├── 02_filtering_and_sorting.sql
│   └── 03_joins.sql
├── data/
│   └── sample_data.csv
└── docs/
    └── database_design.md
```

The structure above represents the planned organisation. Files will be added as the project develops.

## SQL Skills and Learning Progress

### Topics studied

- Retrieving records using `SELECT`
- Filtering records using `WHERE`
- Sorting records using `ORDER BY`
- Combining tables using `INNER JOIN`
- Combining tables using `LEFT JOIN`
- Combining tables using `RIGHT JOIN`

### Topics to practise and develop

- Creating tables and defining relationships
- Primary keys and foreign keys
- Aggregate functions: `COUNT()`, `SUM()`, `AVG()`, `MIN()`, and `MAX()`
- Grouping records with `GROUP BY`
- Filtering grouped results with `HAVING`
- Handling missing values with `NULL`, `COALESCE()`, and related expressions
- Subqueries and Common Table Expressions (CTEs)
- Window functions and analytical ranking
- Indexes and query optimisation
- Database design and normalisation

These topics will be marked as completed as I practise and implement them.

## Planned Business Questions

The database will progressively be developed to answer questions such as:

1. Which warehouses hold the lowest quantities of relief supplies?
2. Which warehouses have no recorded distributions?
3. How much relief stock has each warehouse distributed?
4. Which counties have received the largest quantities of supplies?
5. Which products may require replenishment?
6. How do distribution patterns vary by location and period?
7. How can operational data support better resource allocation?

Each question will be addressed with SQL queries, sample results, and a short explanation of the findings.

## Development Roadmap

### Phase 1 — SQL Fundamentals

- Practise data retrieval, filtering, and sorting.
- Apply joins to combine related operational tables.
- Save working queries in organised SQL scripts.

### Phase 2 — Database Design

- Create tables for warehouses, inventory, distributions, beneficiaries, and emergency incidents.
- Define primary and foreign keys.
- Establish relationships between tables.
- Load fictional sample data.

### Phase 3 — Data Analysis

- Summarise inventory and distributions.
- Identify stock shortages.
- Compare activity across warehouses and counties.
- Use subqueries and CTEs to answer more complex questions.

### Phase 4 — Advanced SQL

- Apply window functions.
- Explore indexing and query execution plans.
- Improve query readability and performance.

### Phase 5 — Reporting and Presentation

- Document analytical findings.
- Create a database relationship diagram.
- Explore Python-based analysis or dashboard integration.
- Prepare the repository for review by recruiters and other developers.

## Data and Privacy

All sample operational records will be fictional or appropriately anonymised.

This project is intended for educational and portfolio purposes. It will not include confidential employer data, real beneficiary identities, private contact details, or sensitive humanitarian records.

## Project Status

**In development.**

The repository documents my ongoing practical SQL learning journey. SQL scripts, sample datasets, database documentation, and analytical findings will be added incrementally as each stage is completed.

## About the Author

**Millicent Wanderi**

Software Engineering | SQL & Data Analytics | Humanitarian Technology

My background combines software engineering, business performance analysis, and emergency-response experience. I am interested in using technology and data to improve operational decision-making and humanitarian resource management.

This project is part of my continued development in SQL, data analytics, and data-driven problem-solving.

## Connect

- GitHub: [@millywanderi](https://github.com/millywanderi)
- Project repository: [reliefdata-sql-portfolio](https://github.com/millywanderi/reliefdata-sql-portfolio)
