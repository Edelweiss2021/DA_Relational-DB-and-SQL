/*
===== RDB&SQL Lab-5 [Assignment-4 Solution] (21 Jun 22) =============

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


-- Instructor solution

USE SampleRetail

SELECT	DISTINCT product_id, quantity, discount
FROM	sale.order_item
ORDER BY	product_id, discount;


SELECT	product_id, discount, sum(quantity)
FROM	sale.order_item
GROUP BY	product_id, discount
ORDER BY	product_id, discount;


-- Find total quantity at the lowest discount rate (A) and at highest rate (B). Get the difference and divide to A. Result is the difference in percentage compared to lowest discount rate. 

WITH T1 AS 
(
	SELECT	product_id, discount, sum(quantity) total_quantity
	FROM	SALE.order_item
	GROUP BY product_id, discount
) , T2 AS
(
	SELECT	*,
			FIRST_VALUE(total_quantity) OVER (PARTITION BY product_id ORDER BY discount) lower_dis_quan,
			LAST_VALUE(total_quantity) OVER (PARTITION BY product_id ORDER BY discount ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) higher_dis_quan	
	FROM	T1
), T3 AS (
SELECT	DISTINCT product_id,  1.0*(higher_dis_quan - lower_dis_quan) / lower_dis_quan increase_rate
FROM	T2
)
SELECT	product_id,
		CASE WHEN increase_rate >= 0.05 THEN 'positive'
			WHEN increase_rate <= - 0.05 THEN 'negative'
			ELSE 'neutral'
		END	discount_effect
FROM	T3
;

--@cansin (correlation)

CREATE VIEW table1 AS
(
select distinct B.product_id, B.discount, order_status, count(A.order_status) count_order_Status from sale.orders A, sale.order_item B
where A.order_id = B.order_id and order_status=4
group by B.product_id, B.discount, order_status
)
select * from table1 order by 1;
----------------------------------------
CREATE VIEW table2 AS (
Select product_id, discount, count_order_Status,
Avg(discount*count_order_Status) over(partition by product_id) Exy,
Avg(discount) over(partition by product_id) Ex,
Avg(1.0*count_order_Status) over(partition by product_id) Ey,
Stdev(discount) over(partition by product_id) std_disc,
Stdev(count_order_Status) over(partition by product_id) std_count_ord_st
from table1
)
select * from table2 order by 1
----------------------------------------
CREATE VIEW table3 AS(
select distinct product_id, Exy-Ex*Ey [Cov(x,y)], std_disc*std_count_ord_st denominator
from table2
where std_disc*std_count_ord_st != 0
)
select * from table3
---------------------------------------
CREATE VIEW table4 AS(
select distinct product_id, Exy-Ex*Ey [Cov(x,y)], std_disc*std_count_ord_st denominator
from table2
where std_disc*std_count_ord_st = 0
)
select * from table4
---------------------------------------
select product_id, [Cov(x,y)]/denominator CORR from table3
CREATE VIEW table5 AS(
select	product_id, [Cov(x,y)]/denominator CORR
from	table3
)
select * from table5
---------------------------------------
CREATE VIEW table6 as(
select A.product_id from table5 A
UNION
select product_id from table4
)
select A.product_id,
		CASE
			when CORR> 0 then 'Positive'
			when CORR< 0 then 'Negative'
			else 'Neutral'
		end [Discount Effect_]
		from table6 A
left join table5 B on A.product_id = B.product_id
order by 1
