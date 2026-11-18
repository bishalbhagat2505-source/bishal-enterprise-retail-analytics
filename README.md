# Bishal Enterprise – Retail Analytics

A practical analytics project based on a smartphone wholesale and retail business. The goal is to use business data to answer questions about sales, products, customers, purchases, inventory and customer feedback.

I am building this project in stages, starting with the database and SQL analysis, then adding Python analysis, machine learning/NLP experiments and dashboards.

## Project status

- [x] Database schema and table design
- [x] Sample/master data and transaction data scripts
- [x] Data quality checks
- [x] SQL analysis queries and business views
- [ ] Python data connection and exploratory analysis
- [ ] Machine learning and customer feedback/NLP experiments
- [ ] Power BI or Tableau dashboard
- [ ] Simple application to present selected analysis

## Current repository structure

```text
bishal-enterprise-retail-analytics/
└── SQL/
    ├── 1-smartphone_wholesale_retail_schema.sql
    ├── 2-master_data.sql
    ├── 3-Product_data.sql
    ├── 4-purchase_data.sql
    ├── 5-inventory_data.sql
    ├── 6-sales_data.sql
    ├── 7-Payment_data.sql
    ├── 8-repairs_feedback.sql
    ├── 9-data_quality_checks.sql
    ├── 10-data_analysis.sql
    ├── 11-Business_views.sql
    └── smartphone_wholesale_ERD.pdf
```

## Tools and technologies

- MySQL
- SQL
- Python (planned for the next project stage)
- Power BI / Tableau (planned for dashboarding)

## Business questions

The analysis is intended to help explore questions such as:

- How are sales and revenue changing over time?
- Which brands and products contribute most to sales?
- Which customers purchase most frequently?
- How does inventory relate to sales?
- What do customer reviews and feedback tell us?

## How to use the SQL files

Run the scripts in numerical order in MySQL Workbench, starting with the schema and then loading the data before running the quality checks and analysis queries. Review each script before executing it in your own database.

## Note

This is a learning and portfolio project. The dataset is prepared for analysis and should not be treated as actual customer or business records.
