/*
===== Session-6 (09 Jun 22) Set Operators & CASE expression ========
*/

/* =================== Pre-Class ====================== */

-- Set Operators

-- create database
CREATE DATABASE Departments;

USE Departments
Go

CREATE TABLE employees_A
(
emp_id BIGINT,
first_name VARCHAR(20),
last_name VARCHAR(20),
salary BIGINT,
job_title VARCHAR (30),
gender VARCHAR(10),
);



INSERT employees_A VALUES
 (17679,  'Robert'    , 'Gilmore'       ,   110000 ,  'Operations Director', 'Male')
,(26650,  'Elvis'    , 'Ritter'        ,   86000 ,  'Sales Manager', 'Male')
,(30840,  'David'   , 'Barrow'        ,   85000 ,  'Data Scientist', 'Male')
,(49714,  'Hugo'    , 'Forester'    ,   55000 ,  'IT Support Specialist', 'Male')
,(51821,  'Linda'    , 'Foster'     ,   95000 ,  'Data Scientist', 'Female')
,(67323,  'Lisa'    , 'Wiener'      ,   75000 ,  'Business Analyst', 'Female')
;





CREATE TABLE employees_B
(
emp_id BIGINT,
first_name VARCHAR(20),
last_name VARCHAR(20),
salary BIGINT,
job_title VARCHAR (30),
gender VARCHAR(10),
);


INSERT employees_B VALUES
 (49714,  'Hugo'    , 'Forester'       ,   55000 ,  'IT Support Specialist', 'Male')
,(67323,  'Lisa'    , 'Wiener'        ,   75000 ,  'Business Analyst', 'Female')
,(70950,  'Rodney'   , 'Weaver'        ,   87000 ,  'Project Manager', 'Male')
,(71329,  'Gayle'    , 'Meyer'    ,   77000 ,  'HR Manager', 'Female')
,(76589,  'Jason'    , 'Christian'     ,   99000 ,  'Project Manager', 'Male')
,(97927,  'Billie'    , 'Lanning'      ,   67000 ,  'Web Developer', 'Female')
;

SELECT *
FROM employees_A;

SELECT *
FROM employees_B;












/* =================== In-Class ====================== */

-- ///////////////// Set Operators //////////////////////

-- UNION

-- QUERY: List customer last name from Charlotte and Aurora

USE SampleRetail
Go

SELECT last_name AS FamilyName
FROM sale.customer
WHERE city = 'Charlotte'
UNION
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora';

SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'
UNION ALL
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora';
-- number of variables and sequence is important

-- QUERY: list staff and customer e-mail addresses unique values

SELECT S.email
FROM sale.staff S
UNION
SELECT C.email
FROM sale.customer C;

-- UNION ALL

-- QUERY: List customers whose first name or last name is Thomas (don't use 'OR')
SELECT first_name, last_name
FROM sale.customer
WHERE first_name = 'Thomas' OR last_name = 'Thomas';

SELECT first_name
FROM sale.customer
WHERE first_name = 'Thomas'
UNION ALL
SELECT last_name
FROM sale.customer
WHERE last_name = 'Thomas';


-- @allen
SELECT * INTO #Thomas FROM (
	select first_name, last_name
	from sale.customer
	where first_name='Thomas'
	union all
	select first_name, last_name
	from sale.customer
	where last_name='Thomas') AS tmp;

select * from #Thomas;

-- INTERSECT

-- QUERY: Write a query that returns brands that have products for both 2018 and 2019.

SELECT	A.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id AND
		A.model_year = 2018
INTERSECT
SELECT	A.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id AND
		A.model_year = 2019;

-- QUERY: Write a query that returns customers who have orders for all of 2018, 2019 and 2020.


SELECT	C.first_name, C.last_name
FROM	sale.customer C, sale.orders O
WHERE	C.customer_id = O.customer_id AND 
		YEAR(O.order_date) = 2018
INTERSECT
SELECT	C.first_name, C.last_name
FROM	sale.customer C, sale.orders O
WHERE	C.customer_id = O.customer_id AND 
		YEAR(O.order_date) = 2019
INTERSECT
SELECT	C.first_name, C.last_name
FROM	sale.customer C, sale.orders O
WHERE	C.customer_id = O.customer_id AND 
		YEAR(O.order_date) = 2020; -- returns 14 rows

SELECT	C.first_name, C.last_name, C.customer_id
FROM	sale.customer C, sale.orders O
WHERE	C.customer_id = O.customer_id AND 
		YEAR(O.order_date) = 2018
INTERSECT
SELECT	C.first_name, C.last_name, C.customer_id
FROM	sale.customer C, sale.orders O
WHERE	C.customer_id = O.customer_id AND 
		YEAR(O.order_date) = 2019
INTERSECT
SELECT	C.first_name, C.last_name, C.customer_id
FROM	sale.customer C, sale.orders O
WHERE	C.customer_id = O.customer_id AND 
		YEAR(O.order_date) = 2020; -- returns 12 rows

select	*
from
	(
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2018
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A, sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2019
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2020
	) A, sale.orders B
where	a.customer_id = b.customer_id and Year(b.order_date) in (2018, 2019, 2020)
order by a.customer_id, b.order_date
;

-- QUERY: list any customer with the same last name from Charlotte and Aurora

SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'
INTERSECT
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora'

--QUERY: any customer and staff with same email?

select	email
from	sale.staff
intersect
select	email
from	sale.customer
;

-- EXCEPT

-- QUERY:  Write a query that returns brands that have a 2018 model product but not a 2019 model product.

SELECT	A.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id AND
		A.model_year = 2018
EXCEPT
SELECT	A.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id AND
		A.model_year = 2019;

--QUERY: Return products only ordered in 2019 and not in other years.

SELECT	B.product_id
FROM	sale.orders A, sale.order_item B
WHERE	YEAR(A.order_date) = 2019 AND 
		A.order_id = B.order_id
EXCEPT
SELECT	B.product_id
FROM	sale.orders A, sale.order_item B
WHERE	YEAR(A.order_date) <> 2019 AND 
		A.order_id = B.order_id; -- returns 5 prod id


SELECT C.product_id, D.product_name
FROM
		(
		SELECT	B.product_id
		FROM	sale.orders A, sale.order_item B
		WHERE	YEAR(A.order_date) = 2019 AND 
				A.order_id = B.order_id
		EXCEPT
		SELECT	B.product_id
		FROM	sale.orders A, sale.order_item B
		WHERE	YEAR(A.order_date) <> 2019 AND 
				A.order_id = B.order_id
		) C, product.product D
WHERE C.product_id = D.product_id; -- -- returns 5 prod id and names

-- alternative solution
select	B.product_id, C.product_name
from	sale.orders A, sale.order_item B, product.product C
where	Year(A.order_date) = 2019 AND
		A.order_id = B.order_id AND
		B.product_id = C.product_id
except
select	B.product_id, C.product_name
from	sale.orders A, sale.order_item B, product.product C
where	Year(A.order_date) <> 2019 AND
		A.order_id = B.order_id AND
		B.product_id = C.product_id

---
SELECT *
FROM
			(
			SELECT P.product_name, P.product_id, YEAR(O.order_date) as order_year
			FROM product.product P, sale.orders O, sale.order_item OI 
			WHERE P.product_id = OI.product_id AND O.order_id = OI.order_id
			) A
PIVOT
(
	count(product_id)
	FOR order_year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;

--- aggregate function
SELECT *
FROM
			(
			SELECT	b.product_id, year(a.order_date) OrderYear, B.item_id
			FROM	SALE.orders A, sale.order_item B
			where	A.order_id = B.order_id
			) A
PIVOT
(
	count(item_id)
	FOR OrderYear IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
order by 1



-- QUERY: 5 brands

SELECT brand_id, brand_name
FROM product.brand
EXCEPT
SELECT *
FROM (
SELECT	A.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id AND
		A.model_year = 2018
INTERSECT
SELECT	A.brand_id, B.brand_name
FROM	product.product A, product.brand B
WHERE	A.brand_id = B.brand_id AND
		A.model_year = 2019) A;


-- ///////////////// CASE Expressions //////////////////////

-- SIMPLE CASE

-- QUERY: group order status by 4 status 
-- 1-Pending, 2-Processing, 3-Rejected, 4-Completed

SELECT	order_id, order_status,
		CASE order_status
			WHEN 1 THEN 'Pending'
			WHEN 2 THEN 'Processing'
			WHEN 3 THEN 'Rejected'
			WHEN 4 THEN 'Completed'
		END order_status_desc
FROM	sale.orders;

-- QUERY: populate staff table with store names
-- 1-Davi 2-BFLO 3- Burkes

SELECT first_name, last_name, store_id,
	CASE store_id
		WHEN 1 THEN 'Davi Techno Retail'
		WHEN 2 THEN 'The BFLO Store'
		WHEN 3 THEN 'Burkes Outlet'
	END AS store_name
FROM sale.staff;

-- SEARCHED CASE

-- QUERY: group order status by 4 status 
-- 1-Pending, 2-Processing, 3-Rejected, 4-Completed

SELECT	order_id, order_status,
		CASE 
			WHEN order_status = 1 THEN 'Pending'
			WHEN order_status = 2 THEN 'Processing'
			WHEN order_status = 3 THEN 'Rejected'
			WHEN order_status = 4 THEN 'Completed'
			ELSE 'other'
		END order_status_desc
FROM	sale.orders;

-- QUERY:Create a new column per customer email providers (Gmail, Hotmail, Yahoo or Other)

SELECT email,
	CASE
		WHEN email LIKE '%@gmail.%' THEN 'Gmail'
		WHEN email LIKE '%@hotmail.%'  THEN 'Hotmail'
		WHEN email LIKE '%@yahoo.%' THEN 'Yahoo'
		ELSE 'Other'
	END AS email_provider	
FROM sale.customer

-- QUERY: List customers who ordered products in the computer accessories, speakers and mp4 player categories in the same order

SELECT C.first_name, C.last_name
FROM	(

		SELECT	C.order_id, count(distinct A.category_id) UniqueCategory
		FROM	product.category A, product.product B, sale.order_item C
		WHERE	A.category_name IN ('Computer Accessories', 'Speakers', 'mp4 player') AND
				A.category_id = B.category_id AND
				B.product_id = C.product_id
		GROUP BY C.order_id
		HAVING count(distinct A.category_id) = 3
		) A, sale.orders B, sale.customer C
WHERE	A.order_id = B.order_id AND
		B.customer_id = C.customer_id
;

-- alternative solution

