# E-commerce SQL Analytics Project

## Overview
This project analyzes an e-commerce database to extract actionable insights on *sales performance, customer behavior, and product trends* using SQL. The analysis helps businesses understand revenue trends, identify top customers and products, and detect churned customers.

## Database Schema
The database consists of the following tables:

- *customers*: customer_id, customer_name, city, state, signup_date, segment  
- *products*: product_id, product_name, category  
- *orders*: order_id, customer_id, order_date, status, payment_value  
- *order_items*: order_id, product_id, quantity, price, discount  

You can find the full schema [here](schema.md).

## Key Analytics Queries
The SQL queries included in this project cover:

1. Monthly revenue trend  
2. Total revenue  
3. Category-wise revenue  
4. Customer Lifetime Value (CLV) & Top 5 Customers  
5. Orders per customer & segmentation  
6. Last order date per customer  
7. Churned customers (90+ days inactive)  
8. Top 5 products by revenue  
9. Products with low sales  
10. Revenue contribution % per product  
11. Running total of revenue  

All SQL code is available in [analysis.sql](analysis.sql).

## Screenshots / Visual Insights

### Monthly Revenue Trend
![Monthly Revenue Trend](monthly_revenue.png)

### Top Customers by Lifetime Value
![Top Customers by LTV](top_customers.png)

### Churned Customers
![Churned Customers](churned_customers.png)

## Tools & Skills
- *Tools:* MySQL, SQL Workbench  
- *Skills:* SQL queries, Joins, Aggregations, Window Functions, Data Analysis, Business Insights  

## How to Use
1. Clone the repository.  
2. Open analysis.sql in MySQL Workbench or any SQL editor.  
3. Run the queries to reproduce the analysis.  
4. Refer to screenshots for example outputs.

---
