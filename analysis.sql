CREATE DATABASE ecommerce_analytics;
USE ecommerce_analytics;

-- customers
CREATE TABLE customers (
  customer_id VARCHAR(50) PRIMARY KEY,
  customer_name VARCHAR(100),
  city VARCHAR(50),
  state VARCHAR(50),
  signup_date DATE,
  segment VARCHAR(30)
);

-- orders
CREATE TABLE orders (
  order_id VARCHAR(50) PRIMARY KEY,
  customer_id VARCHAR(50),
  order_date DATE,
  status VARCHAR(30),
  payment_value DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- products
CREATE TABLE products (
  product_id VARCHAR(50) PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50)
);

-- order items
CREATE TABLE order_items (
  order_id VARCHAR(50),
  product_id VARCHAR(50),
  quantity INT,
  price DECIMAL(10,2),
  discount DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- insert customers
INSERT INTO customers VALUES
('C001','Aarav Sharma','Hyderabad','TS','2023-01-15','Consumer'),
('C002','Meghana D','Bangalore','KA','2023-02-10','Corporate'),
('C003','Rahul Verma','Mumbai','MH','2023-03-05','Consumer'),
('C004','Sneha Patel','Ahmedabad','GJ','2023-03-20','Consumer'),
('C005','Anjali Singh','Delhi','DL','2023-04-02','Corporate'),
('C006','Rohit Kumar','Chennai','TN','2023-04-18','Consumer'),
('C007','Priya Nair','Kochi','KL','2023-05-01','Consumer');

-- insert products
INSERT INTO products VALUES
('P001','Wireless Mouse','Electronics'),
('P002','Laptop Backpack','Accessories'),
('P003','Bluetooth Headphones','Electronics'),
('P004','Office Chair','Furniture'),
('P005','Notebook','Stationery'),
('P006','Desk Lamp','Furniture'),
('P007','USB Keyboard','Electronics');

-- insert orders
INSERT INTO orders VALUES
('O1001','C001','2023-06-10','delivered',1500.00),
('O1002','C002','2023-06-15','delivered',3200.00),
('O1003','C001','2023-07-01','cancelled',800.00),
('O1004','C003','2023-07-12','delivered',2100.00),
('O1005','C004','2023-08-05','delivered',4200.00),
('O1006','C005','2023-08-10','delivered',950.00),
('O1007','C006','2023-09-01','delivered',2800.00),
('O1008','C001','2023-09-15','delivered',1800.00),
('O1009','C007','2023-10-05','delivered',2300.00),
('O1010','C003','2023-10-20','delivered',1600.00);

-- insert order items
INSERT INTO order_items VALUES
('O1001','P001',1,1200,100),
('O1001','P005',2,150,0),
('O1002','P003',1,3000,200),
('O1003','P005',5,160,0),
('O1004','P002',1,2000,100),
('O1005','P004',1,4000,300),
('O1006','P001',1,900,0),
('O1007','P007',1,2500,200),
('O1008','P003',1,1700,0),
('O1009','P006',1,2100,200),
('O1010','P002',1,1500,100);

-- cheking for duplicates
SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- checking nulls
SELECT COUNT(*) FROM orders WHERE order_date IS NULL;

-- monthly revenue trend
SELECT 
  DATE_FORMAT(order_date,'%Y-%m') AS month,
  SUM(payment_value) AS revenue
FROM orders
WHERE status='delivered'
GROUP BY month
ORDER BY month;

-- total revenue
SELECT SUM(payment_value) AS total_revenue
FROM orders
WHERE status='delivered';

-- category wise revenue
SELECT 
  p.category,
  SUM(oi.price*oi.quantity - oi.discount) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id=p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- customer lifetime values
SELECT 
  c.customer_id,
  c.customer_name,
  SUM(o.payment_value) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id,c.customer_name
ORDER BY lifetime_value DESC;

-- top 5 customers by lifetime values
SELECT *
FROM (
  SELECT 
    c.customer_name,
    SUM(o.payment_value) AS ltv,
    DENSE_RANK() OVER (ORDER BY SUM(o.payment_value) DESC) AS rnk
  FROM customers c
  JOIN orders o ON c.customer_id=o.customer_id
  GROUP BY c.customer_name
) t
WHERE rnk<=5;

-- orders per customer
SELECT 
  customer_id,
  COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id;

-- customer segmentation
SELECT 
  CASE
    WHEN order_count=1 THEN 'One-time'
    WHEN order_count BETWEEN 2 AND 4 THEN 'Repeat'
    ELSE 'Loyal'
  END AS customer_type,
  COUNT(*) AS customers
FROM (
  SELECT customer_id,COUNT(order_id) AS order_count
  FROM orders
  GROUP BY customer_id
) t
GROUP BY customer_type;

-- last order date per customer
SELECT 
  customer_id,
  MAX(order_date) AS last_order_date
FROM orders
GROUP BY customer_id;


-- Churned customers (90+ days inactive)
WITH last_order AS (
  SELECT customer_id, MAX(order_date) AS last_order_date
  FROM orders
  GROUP BY customer_id
)
SELECT *
FROM last_order
WHERE last_order_date < CURDATE() - INTERVAL 90 DAY;

-- top 5 products by revenue
SELECT 
  p.product_name,
  SUM(oi.price*oi.quantity) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id=p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;

-- products with low sales
SELECT 
  p.product_name,
  COUNT(oi.order_id) AS total_orders
FROM products p
LEFT JOIN order_items oi ON p.product_id=oi.product_id
GROUP BY p.product_name
HAVING total_orders < 2;

-- revenue contribution % per product
SELECT 
  p.product_name,
  SUM(oi.price*oi.quantity) AS revenue,
  ROUND(
    SUM(oi.price*oi.quantity) /
    (SELECT SUM(price*quantity) FROM order_items) * 100,2
  ) AS revenue_pct
FROM order_items oi
JOIN products p ON oi.product_id=p.product_id
GROUP BY p.product_name
ORDER BY revenue_pct DESC;

-- running total of revenue
SELECT 
  order_date,
  payment_value,
  SUM(payment_value) OVER (ORDER BY order_date) AS running_revenue
FROM orders
WHERE status='delivered';

