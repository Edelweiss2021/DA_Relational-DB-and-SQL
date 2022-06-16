/*
===== RDB&SQL Assignment-4 (16 Jun 22) =============

Discount Effects (SampleRetail database)

Generate a report including product IDs and discount effects on whether the increase in the discount rate
positively impacts the number of orders for the products.

In this assignment, you are expected to generate a solution using SQL with a logical approach.     

Sample Result:
Product_id 		Discount Effect
1 				Positive
2 				Negative
3 				Negative
4 				Neutral

*/

USE SampleRetail


SELECT	product_id, discount, quantity
FROM	sale.order_item
GROUP BY product_id, discount, quantity
ORDER BY product_id;

-- let's see how many different discount rate exist (0.05, 0.07, 0.10, 0.20)
SELECT	 DISTINCT discount
FROM	sale.order_item
ORDER BY discount
;

-- number of orders per product for discount rate (0.05)
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_5percent
FROM	sale.order_item
WHERE discount = 0.05
GROUP BY product_id
ORDER BY product_id
;

-- number of orders per product for discount rate (0.07)
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_7percent
FROM	sale.order_item
WHERE discount = 0.07
GROUP BY product_id
ORDER BY product_id
;

-- number of orders per product for discount rate (0.10)
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_10percent
FROM	sale.order_item
WHERE discount = 0.10
GROUP BY product_id
ORDER BY product_id
;

-- number of orders per product for discount rate (0.20)
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_20percent
FROM	sale.order_item
WHERE discount = 0.20
GROUP BY product_id
ORDER BY product_id
;

-- aggregate all into a single table
SELECT A.product_id, A.number_of_orders_5percent, B.number_of_orders_7percent, C.number_of_orders_10percent, D.number_of_orders_20percent
FROM
(
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_5percent
FROM	sale.order_item
WHERE discount = 0.05
GROUP BY product_id
) A,
(
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_7percent
FROM	sale.order_item
WHERE discount = 0.07
GROUP BY product_id
) B,
(
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_10percent
FROM	sale.order_item
WHERE discount = 0.10
GROUP BY product_id
) C,
(
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_20percent
FROM	sale.order_item
WHERE discount = 0.20
GROUP BY product_id
) D
WHERE A.product_id = B.product_id AND A.product_id = C.product_id AND A.product_id = D.product_id
ORDER BY A.product_id
;

-- creating view
CREATE VIEW discount_effect AS
SELECT A.product_id, A.number_of_orders_5percent, B.number_of_orders_7percent, C.number_of_orders_10percent, D.number_of_orders_20percent
FROM
(
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_5percent
FROM	sale.order_item
WHERE discount = 0.05
GROUP BY product_id
) A,
(
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_7percent
FROM	sale.order_item
WHERE discount = 0.07
GROUP BY product_id
) B,
(
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_10percent
FROM	sale.order_item
WHERE discount = 0.10
GROUP BY product_id
) C,
(
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_20percent
FROM	sale.order_item
WHERE discount = 0.20
GROUP BY product_id
) D
WHERE A.product_id = B.product_id AND A.product_id = C.product_id AND A.product_id = D.product_id
;

SELECT *
FROM discount_effect
ORDER BY product_id
;

-- temp table
SELECT A.product_id, A.number_of_orders_5percent, B.number_of_orders_7percent, C.number_of_orders_10percent, D.number_of_orders_20percent
INTO #DiscountEffect
FROM
(
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_5percent
FROM	sale.order_item
WHERE discount = 0.05
GROUP BY product_id
) A,
(
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_7percent
FROM	sale.order_item
WHERE discount = 0.07
GROUP BY product_id
) B,
(
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_10percent
FROM	sale.order_item
WHERE discount = 0.10
GROUP BY product_id
) C,
(
SELECT	 DISTINCT product_id, COUNT(order_id) number_of_orders_20percent
FROM	sale.order_item
WHERE discount = 0.20
GROUP BY product_id
) D
WHERE A.product_id = B.product_id AND A.product_id = C.product_id AND A.product_id = D.product_id
;
--DROP TABLE #DiscountEffect

SELECT *
FROM #DiscountEffect
ORDER BY product_id
;

SELECT product_id,
	CASE
		WHEN number_of_orders_5percent > number_of_orders_7percent THEN 'Negative'
		WHEN number_of_orders_5percent = number_of_orders_7percent THEN 'Neutral'
		WHEN number_of_orders_5percent < number_of_orders_7percent THEN 'Positive'
	END AS DiscountEffect
FROM discount_effect
ORDER BY product_id
;

--GROUP BY  count_order and total_quantity
select	product_id, discount
		,count(order_id) count_order
		,sum(quantity) total_quantity
from sale.order_item
group by product_id, discount
order by product_id, discount


--WINDOW FUNC count_order and total_quantity
select	distinct product_id, discount
		,count(order_id) OVER(partition by product_id, discount) count_order
		,sum(quantity) OVER(partition by product_id, discount) total_quantity
from sale.order_item