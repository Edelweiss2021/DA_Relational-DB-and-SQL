/*
===== Session-11 (18 Jun 22) Window Functions ========
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


-- Analytical Numbering

-- ROW_NUMBER()

-- QUERY: Assign an ordinal number to the product prices for each category in ascending order.

SELECT	*
FROM	product.product
;

SELECT	product_id, category_id, list_price, 
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) AS Row#
FROM	product.product
--ORDER BY	2,3
;

-- RANK()

-- QUERY: Assign an ordinal number to the product prices for each category in ascending order.
-- Lets try previous query again using RANK() and DENSE_RANK() function.

SELECT	product_id, category_id, list_price, 
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) AS Row#,
		RANK() OVER(PARTITION BY category_id ORDER BY list_price) AS Rank#,
		DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) AS DenseRank#
FROM	product.product
;

-- CUME_DIST()

-- PERCENT_RANK()

-- NTILE()


/* Assign an ordinal number to the product prices for each category in ascending order */ 
SELECT	product_id, model_year, list_price, 
		ROW_NUMBER() OVER(PARTITION BY model_year ORDER BY list_price) AS Row#,
		RANK() OVER(PARTITION BY model_year ORDER BY list_price) AS Rank#,
		DENSE_RANK() OVER(PARTITION BY model_year ORDER BY list_price) AS DenseRank#		
FROM	product.product
;


-- Write a query that returns the cumulative distribution of the list price in product table by brand.

SELECT	product_id, brand_id, list_price, 
		ROUND(CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price), 3) AS CumeDist#,
		ROUND(PERCENT_RANK() OVER (PARTITION BY brand_id ORDER BY list_price), 3) AS PercRank#
FROM	product.product
;

-- Calculate CumeDist# column without using CUME_DIST() function

WITH tbl AS
(
SELECT	brand_id, list_price,
		COUNT(*) OVER(PARTITION BY brand_id) AS TotalProductinBrand,
		ROW_NUMBER() OVER(PARTITION BY brand_id ORDER BY list_price) AS Row#,
		RANK() OVER(PARTITION BY brand_id ORDER BY list_price) AS Rank#
FROM	product.product
)

SELECT	*,
		ROUND(CAST(Row# as float)/TotalProductinBrand, 3) AS CumeDistRow#,
		ROUND((1.0*Rank#)/TotalProductinBrand, 3) AS CumeDistRank#
FROM	tbl
;

-- dense rank?

WITH tbl AS
(
SELECT	brand_id, list_price,
		COUNT(*) OVER(PARTITION BY brand_id) AS TotalProductinBrand,
		ROW_NUMBER() OVER(PARTITION BY brand_id ORDER BY list_price) AS Row#,
		RANK() OVER(PARTITION BY brand_id ORDER BY list_price) AS Rank#,
		DENSE_RANK() OVER(PARTITION BY brand_id ORDER BY list_price) AS DenseRank#
FROM	product.product
)

SELECT	*,
		ROUND(CAST(Row# as float)/TotalProductinBrand, 3) AS CumeDistRow#,
		ROUND((1.0*Rank#)/TotalProductinBrand, 3) AS CumeDistRank#,
		ROUND((1.0*DenseRank#)/TotalProductinBrand, 3) AS CumeDistDenseRank#
FROM	tbl
;

--@allen
WITH tbl as (
        select	brand_id, list_price,
                count(*) over(partition by brand_id) TotalProductInBrand,
                row_number() over(partition by brand_id order by list_price) RowNum,
                rank() over(partition by brand_id order by list_price) RankNum
        from	product.product
)
SELECT  *
        ,ROUND(CAST(RowNum as float) / TotalProductInBrand, 3)  CumDistRowNum
        ,STR(CONVERT(float, RankNum) / TotalProductInBrand, 10, 3) CumDistRankNum
FROM    tbl
;

--QUERY
--Write a query that returns both of the followings:
--The average product price of orders.
--Average net amount.


SELECT	DISTINCT order_id,
		AVG(list_price) OVER(PARTITION BY order_id) AS Avg_price,
		AVG((quantity*list_price*(1-discount))) OVER () AS Avg_net_amount
FROM	sale.order_item
;

--QUERY: List orders for which the average product price is higher than the average net amount.

WITH tbl AS
(
SELECT	DISTINCT order_id,
		AVG(list_price) OVER(PARTITION BY order_id) AS Avg_price,
		AVG((quantity*list_price*(1-discount))) OVER () AS Avg_net_amount
FROM	sale.order_item
)
SELECT	*
FROM	tbl
WHERE	Avg_price > Avg_net_amount
ORDER BY Avg_price 
;

-- instructor
select distinct order_id, a.Avg_price,a.Avg_net_amount
from (
	select *,
	avg(list_price*quantity*(1-discount))  over() Avg_net_amount,
	avg(list_price)  over(partition by order_id) Avg_price
	from [sale].[order_item]
) A
where  a.Avg_price > a.Avg_net_amount
order by 2
;

-- QUERY: Calculate the stores' weekly cumulative number of orders for 2018

SELECT	DISTINCT A.store_id, A.store_name, --B.order_date,
		DATEPART(WEEK, B.order_date) AS week_of_year,
		COUNT(*) OVER(PARTITION BY A.store_id, DATEPART(WEEK, B.order_date)) weekly_order,
		COUNT(*) OVER(PARTITION BY A.store_id ORDER BY DATEPART(WEEK, B.order_date)) cume_total_order
FROM	sale.store A, sale.orders B
WHERE	A.store_id = B.store_id AND YEAR(B.order_date) = '2018'
ORDER BY 1, 3
;

-- instructor
select distinct a.store_id, a.store_name, -- b.order_date,
	datepart(ISO_WEEK, b.order_date) WeekOfYear,
	COUNT(*) OVER(PARTITION BY a.store_id, datepart(ISO_WEEK, b.order_date)) weeks_order,
	COUNT(*) OVER(PARTITION BY a.store_id ORDER BY datepart(ISO_WEEK, b.order_date)) cume_total_order
from sale.store A, sale.orders B
where a.store_id=b.store_id and year(order_date)='2018'
ORDER BY 1, 3
;

-- QUERY: Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.

with tbl as (
	select	B.order_date, sum(A.quantity) SumQuantity --A.order_id, A.product_id, A.quantity
	from	sale.order_item A, sale.orders B
	where	A.order_id = B.order_id
	group by B.order_date
)
select	*,
	avg(SumQuantity*1.0) over(order by order_date rows between 6 preceding and current row) sales_moving_average_7
from	tbl
where	order_date between '2018-03-12' and '2018-04-12'
order by 1
;

with tbl as (
	select	B.order_date, sum(A.quantity) SumQuantity --A.order_id, A.product_id, A.quantity
	from	sale.order_item A, sale.orders B
	where	A.order_id = B.order_id
	group by B.order_date
)
select	*
from	(
	select	*,
		avg(SumQuantity*1.0) over(order by order_date rows between 6 preceding and current row) sales_moving_average_7
	from	tbl
) A
where	A.order_date between '2018-03-12' and '2018-04-12'
order by 1
;