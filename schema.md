# Database Schema – E-commerce Sales & Customer Analytics

## Table Name: ecommerce_sales

This table contains transactional-level data for analyzing sales performance and customer behavior.

---

## Columns Description

| Column Name        | Data Type      | Description |
|--------------------|---------------|------------|
| order_id           | INT           | Unique ID for each order |
| order_date         | DATE          | Date when the order was placed |
| customer_id        | INT           | Unique identifier for customer |
| customer_name      | VARCHAR(100)  | Name of the customer |
| product_category   | VARCHAR(50)   | Category of the product |
| product_name       | VARCHAR(100)  | Name of the product |
| quantity           | INT           | Quantity purchased |
| revenue            | DECIMAL(10,2) | Total revenue from the order |

---

## Primary Key
- order_id

---

## Business Use Cases
- Track monthly revenue trends
- Identify high-value customers (LTV)
- Detect churned customers
- Analyze category-wise revenue
- Calculate average order value (AOV)