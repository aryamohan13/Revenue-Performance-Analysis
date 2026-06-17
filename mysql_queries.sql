-- Show all customers in the USA, ordered by customer name
USE classicmodels;

SELECT customerNumber,customerName,country
FROM customers
WHERE country = 'USA'
ORDER BY customerName ASC;

-- Show customer orders with order dates and payment amount
SELECT c.customerName,o.orderNumber,o.orderDate,p.amount
FROM customers c
INNER JOIN orders o 
	ON c.customerNumber=o.customerNumber
INNER JOIN payments p
	ON c.customerNumber=p.customerNumber
ORDER BY o.orderDate DESC;

-- Show all the customers even those who didnt place an order
SELECT c.customerName, o.orderNumber
FROM customers c
LEFT JOIN orders o on c.customerNumber=o.customerNumber
ORDER BY c.customerName ASC;

-- Show all orders even if customer information is missing
SELECT c.customerName,o.orderNumber
FROM customers c
RIGHT JOIN orders o on c.customerNumber=o.customerNumber
ORDER BY o.orderNumber ASC;

-- Show total amount paid by each customer
SELECT c.customerName, SUM(p.amount) AS total_paid
FROM customers c 
JOIN payments p on c.customerNumber=p.customerNumber
GROUP BY c.customerName
ORDER BY total_paid DESC;

-- Show customers who have paid more than $100,000
SELECT c.customerName, SUM(p.amount) AS total_paid
FROM customers c
JOIN payments p on c.customerNumber=p.customerNumber
GROUP BY c.customerName
HAVING total_paid > 100000
ORDER BY total_paid DESC;

-- Show customers whose total payments are above the average total payments of all customers
SELECT c.customerName, SUM(p.amount) AS total_paid
FROM customers c
JOIN  payments p on c.customerNumber=p.customerNumber
GROUP BY c.customerName
HAVING total_paid>(SELECT AVG(total_per_customer)
				   FROM
                       (SELECT SUM(amount) AS total_per_customer
					    FROM payments
					    GROUP BY customerNumber) AS avg_table)
ORDER BY total_paid DESC;

-- Create a view of customers who have paid more than $100,000 in total
CREATE VIEW high_value_customers AS 
SELECT c.customerName, SUM(p.amount) as total_paid
FROM customers c 
JOIN payments p on c.customerNumber=p.customerNumber
GROUP BY c.customerName
HAVING total_paid > 100000;

SELECT * FROM high_value_customers;

-- Create an index on the 'country' column of the customers table to speed up country-based searches
CREATE INDEX idx_country ON customers(country);

SELECT customerName, country
FROM customers
WHERE country = 'USA';
