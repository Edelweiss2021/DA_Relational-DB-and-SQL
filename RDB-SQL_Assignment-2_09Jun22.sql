/*
===== RDB&SQL Assignment-2 (09 Jun 22) =============

You need to create a report on whether customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the products below or not.

1. 'Polk Audio - 50 W Woofer - Black' -- (first_product)

2. 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' -- (second_product)

3. 'Virtually Invisible 891 In-Wall Speakers (Pair)' -- (third_product)


To generate this report, you are required to use the appropriate SQL Server Built-in string functions (ISNULL(), NULLIF(), etc.) and Joins, as well as basic SQL knowledge.

*/

SELECT *
FROM product.product
WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD';

-- product id for '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
SELECT product_id
FROM product.product
WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD';

-- customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
SELECT DISTINCT O.customer_id AS InitialBuyer
FROM sale.order_item I
INNER JOIN sale.orders O
ON I.order_id = O.order_id
WHERE I.product_id = (	SELECT product_id
						FROM product.product
						WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD')
ORDER BY InitialBuyer ASC;

-- product id for 'Polk Audio - 50 W Woofer - Black'
SELECT product_id
FROM product.product
WHERE product_name = 'Polk Audio - 50 W Woofer - Black';

-- customers who purchased the product named 'Polk Audio - 50 W Woofer - Black'
SELECT DISTINCT O.customer_id AS FirstBuyer
FROM sale.order_item I
INNER JOIN sale.orders O
ON I.order_id = O.order_id
WHERE I.product_id = (	SELECT product_id
						FROM product.product
						WHERE product_name = 'Polk Audio - 50 W Woofer - Black')
ORDER BY FirstBuyer ASC;

-- customers who purchased the product named 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'
SELECT DISTINCT O.customer_id AS SecondBuyer
FROM sale.order_item I
INNER JOIN sale.orders O
ON I.order_id = O.order_id
WHERE I.product_id = (	SELECT product_id
						FROM product.product
						WHERE product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)')
ORDER BY SecondBuyer ASC;

-- customers who purchased the product named 'Virtually Invisible 891 In-Wall Speakers (Pair)'
SELECT DISTINCT O.customer_id AS ThirdBuyer
FROM sale.order_item I
INNER JOIN sale.orders O
ON I.order_id = O.order_id
WHERE I.product_id = (	SELECT product_id
						FROM product.product
						WHERE product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)')
ORDER BY ThirdBuyer ASC;


SELECT DISTINCT C.customer_id, C.first_name, C.last_name
FROM sale.orders O
INNER JOIN sale.customer C
ON O.customer_id = C.customer_id
INNER JOIN sale.order_item I
ON O.order_id = I.order_id
WHERE C.customer_id IN (SELECT DISTINCT O.customer_id
						FROM sale.order_item I
						INNER JOIN sale.orders O
						ON I.order_id = O.order_id
						WHERE I.product_id = (	SELECT product_id
												FROM product.product
												WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'));





