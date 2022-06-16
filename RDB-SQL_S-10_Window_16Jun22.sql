/*
===== Session-10 (16 Jun 22) Window Functions ========
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


-- first hour review



-- ************* second hour *********
-- QUERY: 

SELECT	*
FROM	product.stock
ORDER BY 3 DESC
;

SELECT	*
FROM	product.stock
;

-- QUERY: Write a query that returns customers and their most valuable order with total amount of it.

SELECT	customer_id, B.order_id, SUM(quantity * list_price* (1-discount)) net_price
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
GROUP BY customer_id, B.order_id
ORDER BY 1,3 DESC;

-- using CTE
WITH T1 AS
(
SELECT	O.customer_id, I.order_id, SUM(I.list_price * I.quantity * (1 - I.discount)) AS order_total
FROM	sale.order_item I, sale.orders O
WHERE	I.order_id = O.order_id
GROUP BY	O.customer_id, I.order_id
)
SELECT	DISTINCT customer_id, 
		FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY order_total DESC) most_expensive_order_id,
		FIRST_VALUE(order_total) OVER (PARTITION BY customer_id ORDER BY order_total DESC) most_expensive_order_total
FROM	T1
;

-- @serdar
select distinct customer_id,first_value(order_id) over(partition by customer_id order by sum_ desc) order_id
				,first_value(sum_) over(partition by customer_id order by sum_ desc) net_price
from 
(
select distinct so.[customer_id],so.order_id
		,sum([quantity]*[list_price]*(1-[discount])) over(partition by [customer_id],so.order_id order by so.order_id ) sum_
from [sale].[order_item]soi ,[sale].[orders] so
where so.[order_id]=soi.[order_id]
) A
;
-- QUERY: Write a query that returns first order date by month

SELECT	*
FROM	sale.orders
;

SELECT	DISTINCT YEAR(order_date) AS [Year], MONTH (order_date) AS [Month],
		FIRST_VALUE(order_date) OVER (PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date) AS first_order_date
FROM	sale.orders
;

-- @instructor
SELECT	DISTINCT YEAR(order_date) ord_year,
		MONTH(order_date) ord_month,
		FIRST_VALUE(order_date) OVER (PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date) first_ord_date
FROM	sale.orders

--@allen
select	DISTINCT YEAR(order_date) year_
		,MONTH(order_date) month_
		,FIRST_VALUE(order_date) OVER (PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date) first_order_date
from	sale.orders


-- LAST VALUE

-- QUERY: Write a query that returns most stocked product in each store (use last_value())

SELECT	*
FROM	product.stock
ORDER BY 1,3 ASC
;


SELECT	DISTINCT store_id,
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS most_stocked_product
FROM	product.stock
; -- ROWS allows "2 preceding, 3 following"


SELECT	DISTINCT store_id,
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS most_stocked_product
FROM	product.stock
; -- RANGE doesn't allow "2 preceding, 3 following"
-- ???? RANGE BETWEEN 0.5 PRECEDING AND 0.2 FOLLOWING

-- LAG and LEAD

-- QUERY: Write a query that returns the order date of the one previous sale of each staff (use the LAG function)

SELECT	DISTINCT O.order_id, O.staff_id, S.first_name, S.last_name, O.order_date,
		LAG(O.order_date) OVER (PARTITION BY O.staff_id ORDER BY O.order_id) AS previous_order_date
FROM	sale.orders O, sale.staff S
WHERE	O.staff_id = S.staff_id
ORDER BY O.staff_id
;

SELECT	DISTINCT O.order_id, O.staff_id, S.first_name, S.last_name, O.order_date,
		LAG(O.order_date) OVER (ORDER BY O.order_id) AS previous_order_date
FROM	sale.orders O, sale.staff S
WHERE	O.staff_id = S.staff_id
; -- if we don't use PARTITION BY result will be ungrouped and unordered according to staff 

SELECT	DISTINCT O.order_id, O.staff_id, S.first_name, S.last_name, O.order_date,
		LAG(O.order_date) OVER (PARTITION BY O.staff_id ORDER BY O.order_id) AS previous_order_date,
		LAG(O.order_date, 2) OVER (PARTITION BY O.staff_id ORDER BY O.order_id) AS previous_order_date_2,
		LAG(O.order_date, 3) OVER (PARTITION BY O.staff_id ORDER BY O.order_id) AS previous_order_date_3,
		LAG(O.order_date, 4) OVER (PARTITION BY O.staff_id ORDER BY O.order_id) AS previous_order_date_4,
		LAG(O.order_date, 5) OVER (PARTITION BY O.staff_id ORDER BY O.order_id) AS previous_order_date_5
FROM	sale.orders O, sale.staff S
WHERE	O.staff_id = S.staff_id
ORDER BY O.staff_id
;

--@allen
select	so.order_id, ss.staff_id
		,ss.first_name, ss.last_name
		,so.order_date
		,LAG(so.order_date) OVER(PARTITION BY so.staff_id ORDER BY so.order_date) previus_order_date
from	(
		select	staff_id, order_id ,order_date
		from	sale.orders
)so,	sale.staff ss
where	so.staff_id=ss.staff_id
;

-- QUERY: Write a query that returns the order date of the one next sale of each staff (use the LEAD function)
SELECT	DISTINCT A.order_id, B.staff_id, B.first_name, B.last_name, order_date,
		LEAD(order_date, 1) OVER(PARTITION BY B.staff_id ORDER BY order_id) next_order_date
FROM	sale.orders A, sale.staff B
WHERE	A.staff_id = B.staff_id
;


-- how many days on average till staff's next order?

--@serdar
select distinct A.staff_id,first_name,last_name, avg(A.order_diff) over(partition by A.staff_id) avg_order_diff
from
(
select distinct order_id, ss.staff_id,first_name,last_name,order_date,
		lag(order_date) over(partition by ss.staff_id order by order_id) prev_order
		, datediff(d,lag(order_date,1,order_date) over(partition by ss.staff_id order by order_id),order_date) order_diff
from [sale].[orders] so,[sale].[staff] ss
where so.[staff_id] = ss.[staff_id]
) A