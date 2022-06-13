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

--
