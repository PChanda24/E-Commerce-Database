-- SAMPLE QUERIES FOR TESTING THE DATABASE

-- RETRIEVING DATA OF ORDERS THAT DO NOT HAVE SHIPPERS 
SELECT o.order_id, o.order_date, s.shipper_name, s.shipper_id
FROM orders o
LEFT JOIN shippers s
USING(shipper_id)
WHERE s.shipper_id IS NULL


-- RETRIEVING DATA OF CUSTOMERS HAVING POINTS>4000 WHO ARE PROVIDED A DISCOUNT OF 85%
SELECT c.customer_id, c.first_name, c.last_name, sum(oi.total) as original_price, sum((0.85*oi.total)) as effective_price, c.points
FROM customers c 
JOIN order_payments_details opd 
USING(customer_id)
JOIN order_items oi 
USING(order_id)
GROUP BY c.customer_id
HAVING c.points > 4000

-- RETRIEVING DATA OF PRODUCTS THAT ARE MORE EXPENSIVE THAN MILK 
SELECT * 
FROM products 
WHERE unit_price > (
	SELECT unit_price 
    FROM products 
    WHERE product_name="Milk - 2%"
    )

-- RETRIEVING PRODUCT_ID AND PRODUCT_NAME OF PRODUCTS THAT WERE NEVER ORDERED 
SELECT DISTINCT product_id, product_name
FROM products 
WHERE product_id NOT IN (
	SELECT DISTINCT product_id 
    FROM order_items )
 
 -- RETRIEVING CUSTOMER ID'S OF CUSTOMERS WHO HAVE SPENT MORE THAN AVERAGE
SELECT customer_id, first_name, last_name
FROM customers 
JOIN order_payments_details
USING(customer_id)
JOIN order_items
USING(order_id)
GROUP BY customer_id 
HAVING SUM(total)>
(SELECT AVG(sum) 
FROM (
	SELECT customer_id, SUM(total) AS sum
	FROM customers 
	JOIN order_payments_details
	USING(customer_id)
	JOIN order_items
	USING(order_id)
	GROUP BY customer_id) AS m)

-- RETRIEVING THE CUSTOMERS WHO BOUGHT PRODUCTS FOR LESS THAN THE AVERAGE UNIT PRICE
select c.customer_id, c.first_name, p.product_id, p.product_name, oi.unit_price, 
oi.quantity
from customers c 
join order_payments_details opd
using(customer_id)
join orders o
using(order_id)
join order_items oi
using(order_id)
join products p
using(product_id)
where oi.unit_price < (select avg(unit_price) from order_items where product_id = 
p.product_id); 

-- RETRIEVING NAMES OF ALL CUSTOMERS WHO ORDERED CABBAGE AND TEA
SELECT first_name, last_name
FROM customers
WHERE customer_id IN(
	SELECT customer_id
	FROM order_payments_details
	WHERE order_id IN(
		SELECT order_id
		FROM order_items
		WHERE product_id IN(
			SELECT product_id
			FROM products 
			WHERE product_name IN ('Cabbage - Nappa', 'Tea - Green'))))
 
 -- The product_id and product_name of those products which are present in more than 10 orders
SELECT P.product_id, P.product_name
FROM products AS P
WHERE 10 <
(SELECT COUNT(*)
 FROM order_items AS OI
 WHERE P.product_id = OI.product_id)
 
  -- The customer_id, first_name, last_name and state of each customer who has the highest number of points of all the customers in the same state.
 
 SELECT C1.customer_id, C1.first_name, C1.last_name, C1.state
 FROM customers AS C1
 WHERE C1.points >= ALL
 (SELECT C2.points
  FROM customers AS C2
  WHERE C1.state = C2.state)
  
  -- shipper_name of all the shippers who have delivered their products

SELECT shipper_name 
FROM shippers AS S
WHERE EXISTS(
	SELECT *
    FROM orders AS O
    WHERE S.shipper_id = O.shipper_id
    AND o.status_id = 3)
    
-- specify the category of each customer according to their points earned
SELECT customer_id, first_name, last_name, points,
CASE
	WHEN (points BETWEEN 1 AND 3000) THEN 'Tier 3'
    WHEN (points BETWEEN 3000 AND 6000) THEN 'Tier 2'
    WHEN (points > 6000) THEN 'Tier 1'
END AS customer_category
FROM customers

    
    
    
    
    
    
    
    







