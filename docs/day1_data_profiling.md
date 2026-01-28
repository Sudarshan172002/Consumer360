# Day 1 — Raw Data Profiling Report (Consumer360)

## Project
Product: Consumer360  
Module: Customer Segmentation & CLV Engine  
Phase: Week 1 — Data Engineering  
Day: Day 1 — Raw Data Ingestion & Profiling  

---

## 1. Dataset Information

Source: Online Retail Transaction Dataset  
File Name: OnlineRetail.csv  
Load Method: Python (Pandas → SQLAlchemy → MySQL)  
Target Table: raw_sales  

---

## 2. Row Counts

Total rows loaded: 541909

---

## 3. Missing Values Analysis

customer_id NULLs: 135080  
description NULLs: 1454
invoice_no NULLs: 0  
stock_code NULLs: 0 

---

## 4. Returns & Cancellations

Cancelled invoices (invoice_no LIKE 'C%'):9288   
Rows with negative or zero quantity/price: 11809 

---

## 5. Date Coverage

Earliest invoice_date: 2010-12-01 08:26:00 
Latest invoice_date: 2011-12-09 12:50:00  

---

## 6. Geographic Distribution (Top 10 Countries)
+----------------+--------+
| country        | orders |
+----------------+--------+
| United Kingdom | 495478 |
| Germany        |   9495 |
| France         |   8557 |
| EIRE           |   8196 |
| Spain          |   2533 |
| Netherlands    |   2371 |
| Belgium        |   2069 |
| Switzerland    |   2002 |
| Portugal       |   1519 |
| Australia      |   1259 |
+----------------+--------+

---

## 7. Distinct Entity Counts

Distinct customers: 4372  
Distinct products: 3958  
Distinct invoices: 25900  

---

## 8. Revenue Sanity Check

Total revenue (quantity × unit_price): 9747747.93  

---

## 9. Initial Observations

- Percentage of NULL customers :  24.93
- % Cancelled Orders : 1.71
- % Negative Quantity or Price : 2.18
- Country Concentration
+----------------+--------+
| country        | cnt    |
+----------------+--------+
| United Kingdom | 495478 |
| Germany        |   9495 |
| France         |   8557 |
| EIRE           |   8196 |
| Spain          |   2533 |
+----------------+--------+

---

## 10. Data Quality Issues Identified

- Missing customer identifiers  
- Cancelled invoices  
- Negative quantities  
- Zero prices  
- Quantity outliers  
- Text inconsistencies in product descriptions  

---

## 11. Proposed Cleaning Rules for Staging Layer (Day-2)

- Remove cancelled invoices (invoice_no LIKE 'C%')
- Remove rows where quantity <= 0
- Remove rows where unit_price <= 0
- Exclude rows with NULL customer_id
- Standardize product descriptions (trim spaces, uppercase)
- Convert invoice_date to standard timestamp
- Remove duplicate invoice/product rows if found

---


