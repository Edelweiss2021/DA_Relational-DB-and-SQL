/*
===== Lab-3 (10 Jun 22) Assignment-2 Solution ========

-- RDB&SQL Assignment-2

You need to create a report on whether customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the products below or not.

1. 'Polk Audio - 50 W Woofer - Black' -- (first_product)

2. 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' -- (second_product)

3. 'Virtually Invisible 891 In-Wall Speakers (Pair)' -- (third_product)

To generate this report, you are required to use the appropriate SQL Server Built-in string functions (ISNULL(), NULLIF(), etc.) and Joins, as well as basic SQL knowledge.



*/

-- customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
SELECT	DISTINCT A.customer_id, A.first_name, A.last_name, D.product_id, D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id AND
		B.order_id = C.order_id AND
		C.product_id = D.product_id AND
		D.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
;

-- customers who purchased the product named 'Polk Audio - 50 W Woofer - Black'
SELECT	DISTINCT A.customer_id, A.first_name, A.last_name, D.product_id, D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id AND
		B.order_id = C.order_id AND
		C.product_id = D.product_id AND
		D.product_name = 'Polk Audio - 50 W Woofer - Black'
;

-- View
CREATE VIEW Customer_product AS
SELECT	DISTINCT A.customer_id, A.first_name, A.last_name, D.product_id, D.product_name
FROM	sale.customer A, sale.orders B, sale.order_item C, product.product D
WHERE	A.customer_id = B.customer_id AND
		B.order_id = C.order_id AND
		C.product_id = D.product_id;

SELECT *
FROM Customer_product;

SELECT *
FROM Customer_product
WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD';

-- customer_id, first name, last name, first product, second product, third product

-- nullif, isnull

SELECT A.customer_id, A.first_name, A.last_name, -- A.product_name, B.product_name, C.product_name, D.product_name,

ISNULL(NULLIF (ISNULL(B.product_name, 'NO'), B.product_name), 'YES') First_product,
ISNULL(NULLIF (ISNULL(C.product_name, 'NO'), C.product_name), 'YES') Second_product,
ISNULL(NULLIF (ISNULL(D.product_name, 'NO'), D.product_name), 'YES') Third_product

FROM
	(
	SELECT *
	FROM Customer_product
	WHERE product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
	) A LEFT JOIN
	(
	SELECT *
	FROM Customer_product
	WHERE product_name =  'Polk Audio - 50 W Woofer - Black'
	) B
ON A.customer_id = B.customer_id
	LEFT JOIN
	(
	SELECT *
	FROM Customer_product
	WHERE product_name =  'SB-2000 12 500W Subwoofer (Piano Gloss Black)'
	) C
ON A.customer_id = C.customer_id
	LEFT JOIN
	(
	SELECT *
	FROM Customer_product
	WHERE product_name =  'Virtually Invisible 891 In-Wall Speakers (Pair)'
	) D
ON A.customer_id = D.customer_id
;


-- @allen

select isnull(nullif(isnull(null,'Yes'),'ff'),'No') AS column_name
select isnull(nullif(isnull('Polk','Yes'),'Polk'),'No') AS column_name

select CASE WHEN (null IS NULL) THEN 'Yes' ELSE 'No' END AS column_name
select CASE WHEN ('Polk' IS NULL) THEN 'Yes' ELSE 'No' END AS column_name

select IIF((null IS NULL), 'Yes', 'No') AS column_name
select IIF(('Polk' IS NULL), 'Yes', 'No') AS column_name

select REPLACE(ISNULL('Polk','No'),'Polk','Yes') AS column_name
select REPLACE(ISNULL(null,'No'),'Polk','Yes') AS column_name
