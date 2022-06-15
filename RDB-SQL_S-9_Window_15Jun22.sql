/*
===== Session-9 (15 Jun 22) Window Functions ========
*/

/* =================== Pre-Class ====================== */

/* ------- Aggregate Window Functions -------- */
SELECT *
FROM departments
;

SELECT graduation, COUNT(id) OVER() AS count_employee
FROM departments
;

SELECT graduation, COUNT(id) OVER(PARTITION BY graduation) AS count_employee
FROM departments
;

-- If you use DISTINCT keyword like the query below, you would be get rid of duplicate rows.

SELECT DISTINCT graduation, COUNT(id) OVER() AS count_employee
FROM departments
;

-- If we use PARTITION BY with DISTINCT keyword, it returns the count of employees according to graduation. 
-- And the result got rid of the duplicate rows with using DISTINCT keyword. 

SELECT DISTINCT graduation, COUNT(id) OVER(PARTITION BY graduation) AS count_employee
FROM departments
;

-- if we use only ORDER BY in the parentheses
SELECT hire_date, COUNT (id) OVER (ORDER BY hire_date) AS count_employee
FROM departments
; -- when we include ORDER BY we get running total/cumulative total. 

SELECT hire_date, COUNT (id) OVER () AS count_employee
FROM departments
; -- when we don't include the ORDER BY we get total.

/* ------- Ranking Window Functions -------- */

--	Let's rank the employees based on their hire date.
SELECT [name], RANK() OVER(ORDER BY hire_date DESC) AS rank_duration 
FROM departments
; --RANK() function assigns the same rank number if the hire_date value is same. 


-- let's apply the same scenario by using the DENSE_RANK function. 
SELECT [name], DENSE_RANK() OVER(ORDER BY hire_date DESC) AS rank_duration 
FROM departments
;

-- Let's give a sequence number to the employees in each seniority category according to their hire dates. 
SELECT [name], seniority, hire_date, ROW_NUMBER() OVER (PARTITION BY seniority ORDER BY hire_date DESC) AS row#
FROM departments;

/* ------- Value Window Functions -------- */

-- LAG() and LEAD() functions. These functions are useful to compare rows to preceding or following rows. 
-- LAG returns data from previous rows and LEAD returns data from the following rows. 

SELECT	id, [name],
		LAG([name]) OVER (ORDER BY id) AS previous_name,
		LEAD([name]) OVER (ORDER BY id) AS next_name
FROM	departments;

SELECT	id, [name],
		LAG([name], 2) OVER (ORDER BY id) AS previous_name,
		LEAD([name], 2) OVER (ORDER BY id) AS next_name
FROM	departments;

-- Let's do the examples with FIRST_VALUE() AND LAST_VALUE()

SELECT id, name,
		FIRST_VALUE(name) OVER(ORDER BY id) AS the_first_name
FROM departments;

SELECT id, name,
		LAST_VALUE(name) OVER(ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_name
FROM departments;











/* =================== In-Class ====================== */

-- ///////////////// Window Functions //////////////////////

-- QUERY: Return stock amounts of products (only stock table) (use both GROUP BY and Window func)

SELECT	product_id, SUM(quantity) AS total_quantity
FROM	product.stock
GROUP BY product_id
ORDER BY product_id
;

SELECT *, SUM(quantity) OVER (PARTITION BY product_id) AS sum_WF
FROM product.stock
ORDER BY product_id
;

SELECT DISTINCT product_id, SUM(quantity) OVER (PARTITION BY product_id) AS sum_WF
FROM product.stock
ORDER BY product_id
;

-- QUERY: Write a query that returns average list price of products by brands

SELECT	brand_id, AVG(list_price) AS avg_price
FROM	product.product
GROUP BY brand_id
;

SELECT	DISTINCT brand_id, AVG(list_price) OVER (PARTITION BY brand_id) AS avg_price
FROM	product.product
;

SELECT	*,
		COUNT(*) OVER (PARTITION BY brand_id) Total_Prod_Brand,
		MAX(list_price) OVER (PARTITION BY brand_id) Expensixe_Prod_Brand
FROM	product.product
ORDER BY brand_id, product_id
;

SELECT	product_id, brand_id, category_id, model_year,
		COUNT(*) OVER (PARTITION BY brand_id) CountOfProductinBrand,
		COUNT(*) OVER (PARTITION BY category_id) CountOfProductinCategory
FROM	product.product
ORDER BY brand_id, category_id, model_year
;

SELECT	DISTINCT brand_id, category_id, model_year,
		COUNT(*) OVER (PARTITION BY brand_id) CountOfProductinBrand,
		COUNT(*) OVER (PARTITION BY category_id) CountOfProductinCategory
FROM	product.product
ORDER BY brand_id, category_id, model_year
;

SELECT	DISTINCT brand_id, category_id,
		COUNT(*) OVER (PARTITION BY brand_id) CountOfProductinBrand,
		COUNT(*) OVER (PARTITION BY category_id) CountOfProductinCategory
FROM	product.product
ORDER BY brand_id, category_id
;

-- Window Frames

-- Couple of examples for Window frames:
-- Let's find out how window frames are established at each row in query and number of rows.


SELECT	category_id, product_id,
		COUNT(*) OVER() AS NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) AS countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) AS countofprod_by_cat_2, -- default --> ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS prev_with_current, -- like ASC
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS current_with_following, -- like DESC
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS whole_rows, -- window frame = partition
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) AS specified_columns_2
FROM	product.product
ORDER BY category_id, product_id
;


-- Cheapest product price in each category

SELECT	DISTINCT category_id, MIN(list_price) OVER (PARTITION BY category_id) AS cheapest_by_cat
FROM	product.product
;

-- How many different product in the product table?

SELECT	DISTINCT COUNT(*) OVER () AS num_of_product
FROM	product.product
;

-- How many different product in the order item table?

SELECT	COUNT(DISTINCT product_id) unique_product
FROM	sale.order_item
;

-- @ilknur
SELECT DISTINCT product_id, count(*) OVER (PARTITION BY product_id) number_of_product
FROM sale.order_item
;


-- @meryem
SELECT COUNT(*) AS number_of_product
FROM (SELECT DISTINCT product_id,COUNT(*) OVER(PARTITION BY product_id) num_of_product
FROM sale.order_item S) S
;

-- @matrix
select distinct count(*) over()
from (select distinct product_id,  count(*) over(partition by product_id) as number_of_product
from sale.order_item) as a


-- QUERY: How many products are in each order?

SELECT	order_id, COUNT(DISTINCT product_id) unique_product, SUM(quantity) AS total_product
FROM	sale.order_item
GROUP BY order_id
;

select distinct [order_id],
	count(product_id) over(partition by [order_id]) count_of_Uniqueproduct,
	sum(quantity) over(partition by [order_id]) count_of_product
from [sale].[order_item]
;

-- QUERY: How many different products are in each brand in each category?

SELECT	category_id, brand_id, COUNT(DISTINCT product_id) AS num_of_prod
FROM	product.product
GROUP BY	category_id, brand_id
ORDER BY category_id;

SELECT	DISTINCT category_id, brand_id, COUNT(*) OVER (PARTITION BY brand_id, category_id) AS num_of_prod
FROM	product.product
;

select	A.*, B.brand_name
from	(
		select	distinct category_id, brand_id,
				count(*) over(partition by brand_id, category_id) CountOfProduct
		from	product.product
		) A, product.brand B
where	A.brand_id = B.brand_id
;

select	distinct category_id, A.brand_id,
		count(*) over(partition by A.brand_id, A.category_id) CountOfProduct,
		B.brand_name
from	product.product A, product.brand B
where	A.brand_id = B.brand_id
;