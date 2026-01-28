# Day 2 — Data Warehouse Build (Consumer360)

## Phase
Week 1 — Data Engineering

## Focus
Star Schema Modeling, Staging Layer, Dimension & Fact Population

---

## Objectives

- Build clean staging layer
- Design star schema
- Create dimension tables
- Load fact table
- Add foreign keys
- Optimize joins with indexes

---

## Architecture

RAW → STAGING → DIMENSIONS → FACT

Tables:

- raw_sales
- staging_sales_clean
- dim_customer
- dim_product
- dim_date
- fact_sales

---

## Task 1 — Staging Layer

Created `staging_sales_clean` applying:

- Removed cancelled invoices
- Removed negative quantity
- Removed zero prices
- Removed NULL customers
- Trimmed product descriptions

---

## Task 2 — Star Schema Design

### Dimensions

dim_customer  
dim_product  
dim_date  

### Fact

fact_sales

---

## Task 3 — Dimension Population

- Customers grouped by customer_id + country
- Products deduplicated by stock_code
- Calendar dimension created from invoice_date

---

## Task 4 — Fact Load

Joined:

- staging_sales_clean
- dim_customer
- dim_product
- dim_date

Calculated:

revenue = quantity × unit_price

---

## Task 5 — Optimization & Integrity

Indexes added on:

- staging join keys
- dimension business keys
- fact foreign keys

Foreign keys enforced between:

- fact_sales → dim_customer
- fact_sales → dim_product
- fact_sales → dim_date

---

## Performance Notes

- Initial fact load slow due to missing indexes
- Indexes reduced disk usage and join cost
- Fact table now optimized for BI tools

---

## Day-2 Deliverables

- staging_sales_clean built
- star schema created
- dimensions populated
- fact table loaded
- indexes & constraints applied
- SQL scripts saved
- ERD diagram prepared

---


