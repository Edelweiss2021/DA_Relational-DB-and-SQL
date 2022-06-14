/*
===== RDB&SQL Assignment-2 (09 Jun 22) =============

1. Conversion Rate

Below you see a table of the actions of customers visiting the website by clicking on two different types of advertisements given by an E-Commerce company. 
Write a query to return the conversion rate for each Advertisement type.

a.    Create above table (Actions) and insert values,
b.    Retrieve count of total Actions and Orders for each Advertisement Type,
c.    Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0. 

*/


-- Create table (Actions) and insert values

CREATE TABLE Actions
			(
			Visitor_ID INT IDENTITY (1, 1) PRIMARY KEY,
			Adv_Type VARCHAR(1),
			[Action] VARCHAR(10)
			);

INSERT Actions VALUES
	('A', 'Left'),
	('A', 'Order'),
	('B', 'Left'),
	('A', 'Order'),
	('A', 'Review'),
	('A', 'Left'),
	('B', 'Left'),
	('B', 'Order'),
	('B', 'Review'),
	('A', 'Review');

SELECT * FROM Actions;


-- Retrieve count of total Actions and Orders for each Advertisement Type

SELECT Adv_Type, COUNT([Action])*1.0 AS Count_of_total_action
FROM Actions
GROUP BY Adv_Type;

SELECT Adv_Type, COUNT([Action])*1.0 AS Count_of_total_order
FROM Actions
WHERE [Action] = 'Order'
GROUP BY Adv_Type;


SELECT A.Count_of_total_order/B.Count_of_total_action AS Conversion_Rate
FROM
	(
	SELECT Adv_Type, COUNT([Action])*1.0 AS Count_of_total_order
	FROM Actions
	WHERE [Action] = 'Order'
	GROUP BY Adv_Type
	) A,
	(
	SELECT Adv_Type, COUNT([Action])*1.0 AS Count_of_total_action
	FROM Actions
	GROUP BY Adv_Type
	) B
;

SELECT COUNT([Action])
FROM Actions
WHERE Adv_Type = 'A' AND [Action] = 'Order';

SELECT COUNT([Action])
FROM Actions
WHERE Adv_Type = 'A';

/* ===== In-Class (Lab - 14 Jun 22) ===== */


-- Instructor solution
WITH CTE1 AS
(
SELECT	Adv_Type, 
		COUNT(*) AS total_action
FROM	Actions
GROUP BY Adv_Type
), CTE2 AS
(
SELECT	Adv_Type, 
		COUNT(*) AS total_order
FROM	Actions
WHERE [Action] = 'Order'
GROUP BY Adv_Type
)
SELECT	CTE1.Adv_Type, CTE1.total_action, CTE2.total_order, CAST((1.0*CTE2.total_order/CTE1.total_action) AS DECIMAL (3,2)) AS Conversion_Rate
FROM	CTE1, CTE2
WHERE	CTE1.Adv_Type = CTE2.Adv_Type
;

-- @serdar
select n.[Adv_Type]
		,cast(sum(n.new_action)*1.0/count(n.new_action)  as numeric (10,2)) as Conversion_Rate
		from	(select *, 
					case [Action]
						when 'Order' then 1
						else 0
					end new_action
				from [Actions]
				) n
group by n.[Adv_Type]

-- @eyup

create or alter view AAA as 
SELECT a.Adv_Type,a.Actionnn
from Actions as a
where a.Adv_Type= 'A'

create or alter view BBB as 
SELECT a.Adv_Type,a.Actionnn
from Actions as a
where a.Adv_Type= 'B'

select * from BBB

select * from AAA

select AAA.Adv_Type,(sum(case when Actionnn = 'Order' then 1.0 else 0 end) /
				    (sum(case when Actionnn = 'Left' then 1.0 end) 
					+sum(case when Actionnn = 'Order' then 1.0 end)
					+sum(case when Actionnn = 'Review' then 1.0 end))
				    ) as conversion_rate
from AAA
group by AAA.Adv_Type
union

select BBB.Adv_Type,(sum(case when Actionnn = 'Order' then 1.0 else 0 end) /
					(sum(case when Actionnn = 'Left' then 1.0 end)
					+sum(case when Actionnn = 'Order' then 1.0 end)
					+sum(case when Actionnn = 'Review' then 1.0 end))
				    ) as conversion_rate
from BBB
group by BBB.Adv_Type;

-- @allen

SELECT * FROM Actions;

--B: Retrieve count of total Actions and Orders for each Advertisement Type
CREATE OR ALTER VIEW actions_and_orders as
SELECT Adv_Type
	,COUNT(Action) as total_Action
	,SUM (CASE Action WHEN 'Order' THEN 1 ELSE 0 END) as total_Order
	--,COUNT(CASE WHEN Action = 'Order' then 1 ELSE NULL END) as count_Order
--INTO #count_table
FROM Actions
GROUP BY Adv_Type
GO

--C: Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.
SELECT	Adv_Type, 
		CAST((total_Order*1.0/total_Order) AS NUMERIC(10,2)) as Conversion_Rate
FROM	actions_and_orders