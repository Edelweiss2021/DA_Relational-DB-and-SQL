
/*
===== Project E-Commerce (24 Jun 22) ========
*/


/* ========== CLEAN-UP AND ORGANIZE TABLES ========== */

USE [project_e-commerce];


-- importing files and modifying table constraints

SELECT	* FROM	dbo.cust_dimen;

ALTER TABLE dbo.cust_dimen
DROP CONSTRAINT pk_1 ;

ALTER TABLE dbo.cust_dimen
ADD CONSTRAINT PK_cust_dimen PRIMARY KEY (Cust_id) ;

SELECT * FROM dbo.orders_dimen;

SELECT * FROM dbo.shipping_dimen;

SELECT * FROM	dbo.prod_dimen;

ALTER TABLE dbo.prod_dimen
ALTER COLUMN Prod_id NVARCHAR(50) NOT NULL;

ALTER TABLE dbo.prod_dimen
--DROP CONSTRAINT PK_prod_dimen;
ADD CONSTRAINT PK_prod_dimen PRIMARY KEY (Prod_id);

SELECT * FROM dbo.orders_dimen;
SELECT * FROM dbo.market_fact;

 -- ///////////////////////////////////////

SELECT * 
FROM dbo.orders_dimen
WHERE Ord_id = 'Ord_6';

SELECT * 
FROM dbo.shipping_dimen
WHERE Order_ID = 6;

-- Counclusion:  'Ord_id' column from 'orders_dimen' doesn't correspond to 'Order_ID' column from 'shipping_dimen'. They represent different values, we can't use them together. 

SELECT * 
FROM dbo.shipping_dimen
ORDER BY Order_ID
;

SELECT * 
FROM dbo.orders_dimen
ORDER BY Ord_id
;

-- aligning/synchronizing column constraints with that of main tables

ALTER TABLE dbo.market_fact
ALTER COLUMN Prod_id NVARCHAR(50) NOT NULL
;

ALTER TABLE dbo.market_fact
ALTER COLUMN Ord_id NVARCHAR(50) NOT NULL
;
ALTER TABLE dbo.market_fact
ALTER COLUMN Ship_id NVARCHAR(50) NOT NULL
;
ALTER TABLE dbo.market_fact
ALTER COLUMN Cust_id NVARCHAR(50) NOT NULL
;

-- setting foreign keys in the 'market_fact' table
ALTER TABLE dbo.market_fact
ADD CONSTRAINT	FK_ord_id
FOREIGN KEY (Ord_id) REFERENCES orders_dimen(Ord_id);

ALTER TABLE dbo.market_fact
ADD CONSTRAINT	FK_prod_id
FOREIGN KEY (Prod_id) REFERENCES prod_dimen(Prod_id);

ALTER TABLE dbo.market_fact
ADD CONSTRAINT	FK_ship_id
FOREIGN KEY (Ship_id) REFERENCES shipping_dimen(Ship_id);

ALTER TABLE dbo.market_fact
ADD CONSTRAINT	FK_cust_id
FOREIGN KEY (Cust_id) REFERENCES cust_dimen(Cust_id);

/* ========== ANALYSIS ========== */

-- 1. Using the columns of “market_fact”, “cust_dimen”, “orders_dimen”, “prod_dimen”, “shipping_dimen”, Create a new table, named as “combined_table”.

SELECT		*
FROM		dbo.market_fact AS M
LEFT JOIN	dbo.cust_dimen AS C
ON			M.Cust_id = C.Cust_id
LEFT JOIN	dbo.orders_dimen AS O
ON			M.Ord_id = O.Ord_id
LEFT JOIN	dbo.shipping_dimen AS S
ON			M.Ship_id = S.Ship_id
LEFT JOIN	dbo.prod_dimen AS P
ON			M.Prod_id = P.Prod_id
;

-- getting rid of duplicate '_id' columns
SELECT		M.*, C.Customer_Name, C.Customer_Segment, C.Province, C.Region, O.Order_Date, O.Order_Priority, S.Ship_Mode, S.Ship_Date, P.Product_Category, P.Product_Sub_Category
FROM		dbo.market_fact AS M
LEFT JOIN	dbo.cust_dimen AS C
ON			M.Cust_id = C.Cust_id
LEFT JOIN	dbo.orders_dimen AS O
ON			M.Ord_id = O.Ord_id
LEFT JOIN	dbo.shipping_dimen AS S
ON			M.Ship_id = S.Ship_id
LEFT JOIN	dbo.prod_dimen AS P
ON			M.Prod_id = P.Prod_id
;

-- creating table 'combined_table'
SELECT	* 
INTO	dbo.combined_table
FROM
(
SELECT		M.*, C.Customer_Name, C.Customer_Segment, C.Province, C.Region, O.Order_Date, O.Order_Priority, S.Ship_Mode, S.Ship_Date, P.Product_Category, P.Product_Sub_Category
FROM		dbo.market_fact AS M
LEFT JOIN	dbo.cust_dimen AS C
ON			M.Cust_id = C.Cust_id
LEFT JOIN	dbo.orders_dimen AS O
ON			M.Ord_id = O.Ord_id
LEFT JOIN	dbo.shipping_dimen AS S
ON			M.Ship_id = S.Ship_id
LEFT JOIN	dbo.prod_dimen AS P
ON			M.Prod_id = P.Prod_id
) AS T
;

SELECT * FROM dbo.combined_table;


-- geting rid of prefixes from 'id' columns
UPDATE dbo.combined_table
SET Ord_id = CAST(REPLACE(Ord_id, 'Ord_', '') AS INT)
;

UPDATE dbo.combined_table
SET Prod_id = CAST(REPLACE(Prod_id, 'Prod_', '') AS INT),
	Ship_id = CAST(REPLACE(Ship_id, 'SHP_', '') AS INT),
	Cust_id = CAST(REPLACE(Cust_id, 'Cust_', '') AS INT)
;

ALTER TABLE dbo.combined_table
ALTER COLUMN Cust_id INT NOT NULL
;

ALTER TABLE dbo.combined_table
ALTER COLUMN Ship_id INT NOT NULL
;

ALTER TABLE dbo.combined_table
ALTER COLUMN Prod_id INT NOT NULL
;

ALTER TABLE dbo.combined_table
ALTER COLUMN Ord_id INT NOT NULL
;

SELECT * FROM dbo.combined_table;

-- 2. Find the top 3 customers who have the maximum count of orders.

SELECT	TOP 3 Customer_Name, COUNT(Ord_id) AS order_count
FROM	dbo.combined_table
GROUP BY Customer_Name
ORDER BY 2 DESC
;

-- 3. Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.

-- calculate date difference of Order_Date and Ship_Date
SELECT	*, DATEDIFF(day, Order_Date, Ship_Date) AS DaysTakenForDelivery
FROM	dbo.combined_table
ORDER BY 1 DESC;

--orders with completion time (descending) 
SELECT	Ord_id, DATEDIFF(day, Order_Date, Ship_Date) AS DaysTakenForDelivery
FROM	dbo.combined_table
ORDER BY 2 DESC;

-- adding a new computed column (DaysTakenForDelivery) to the table
ALTER TABLE dbo.combined_table
ADD DaysTakenForDelivery AS (DATEDIFF(day, Order_Date, Ship_Date))
;

-- check table
SELECT * FROM dbo.combined_table;

-- 4. Find the customer whose order took the maximum time to get delivered

SELECT	TOP 1 Customer_Name, MAX(DaysTakenForDelivery) AS MaxDeliveryDays
FROM	dbo.combined_table
GROUP BY Customer_Name
ORDER BY 2 DESC
;

-- 5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011

-- Jan 2011
SELECT	Cust_id
FROM	dbo.combined_table
WHERE	YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = '01'
; -- 154 rows

SELECT	DISTINCT Cust_id
FROM	dbo.combined_table
WHERE	YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = '01'
ORDER BY 1; -- 99 distinct customers

SELECT	COUNT(DISTINCT Cust_id) AS count_unique_cust_Jan11
FROM	dbo.combined_table
WHERE	YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = '01'
;

-- Feb 2011
SELECT	DISTINCT Cust_id
FROM	dbo.combined_table
WHERE	YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = '02'
ORDER BY 1; -- 113 distinct customers

-- intersection of Jan 2011 and Feb 2011

SELECT COUNT(*) AS count_unique_cust_Jan11_Feb11
FROM
	(
	SELECT	DISTINCT Cust_id
	FROM	dbo.combined_table
	WHERE	YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = '01'
	) AS A,
	(
	SELECT	DISTINCT Cust_id
	FROM	dbo.combined_table
	WHERE	YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = '02'
	) AS B
WHERE A.Cust_id = B.Cust_id
; -- 10 customers

-- intersection of Jan 2011 and Mar 2011

SELECT COUNT(*) AS count_unique_cust_Jan11_Mar11
FROM
	(
	SELECT	DISTINCT Cust_id
	FROM	dbo.combined_table
	WHERE	YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = '01'
	) AS A,
	(
	SELECT	DISTINCT Cust_id
	FROM	dbo.combined_table
	WHERE	YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = '03'
	) AS B
WHERE A.Cust_id = B.Cust_id
; -- 8 customers

-- intersection of Jan 2011 and rest of 2011 (placing order every month)

SELECT COUNT(*) AS count_unique_cust_Jan11_Feb11_Mar11_Apr11
FROM
	(
	SELECT	DISTINCT Cust_id
	FROM	dbo.combined_table
	WHERE	YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = '01'
	) AS A,
	(
	SELECT	DISTINCT Cust_id
	FROM	dbo.combined_table
	WHERE	YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = '02'
	) AS B,
	(
	SELECT	DISTINCT Cust_id
	FROM	dbo.combined_table
	WHERE	YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = '03'
	) AS C,
	(
	SELECT	DISTINCT Cust_id
	FROM	dbo.combined_table
	WHERE	YEAR(Order_Date) = 2011 AND MONTH(Order_Date) = '04'
	) AS D
WHERE A.Cust_id = B.Cust_id AND A.Cust_id = C.Cust_id AND A.Cust_id = D.Cust_id
; -- zero customers to place orders in each month from Jan to Apr in 2011

-- 6. Write a query to return for each user the time elapsed between the first purchasing and the third purchasing, in ascending order by Customer ID.

-- First purchase
SELECT	Cust_id,
		FIRST_VALUE(Order_Date) OVER (PARTITION BY Cust_id ORDER BY Order_Date) AS FirstPurchase
FROM	dbo.combined_table
ORDER BY 1
;

SELECT	A.Order_Date AS FirstPurchase
FROM	(
		SELECT	ROW_NUMBER() OVER (PARTITION BY Cust_id ORDER BY Order_Date) AS Row#,
		Cust_id,
		Order_Date
		FROM	dbo.combined_table
		) AS A
WHERE	A.Row# = 1
;
-- Third purchase

SELECT	Cust_id, Order_Date,
		ROW_NUMBER() OVER (PARTITION BY Cust_id ORDER BY Order_Date) AS Row#
FROM	dbo.combined_table
GROUP BY Cust_id, Order_Date
;

SELECT	ROW_NUMBER() OVER (PARTITION BY Cust_id ORDER BY Order_Date) AS Row#,
		Cust_id,
		Order_Date
FROM	dbo.combined_table
;

SELECT	A.Order_Date AS ThirdPurchase
FROM	(
		SELECT	ROW_NUMBER() OVER (PARTITION BY Cust_id ORDER BY Order_Date) AS Row#,
		Cust_id,
		Order_Date
		FROM	dbo.combined_table
		) AS A
WHERE	A.Row# = 3
;

-- combine

SELECT *, DATEDIFF(day, F.FirstPurchase, T.ThirdPurchase) AS ElapsedTimeFirstThird
FROM
(
SELECT	A.Cust_id, A.Order_Date AS FirstPurchase
FROM	(
		SELECT	ROW_NUMBER() OVER (PARTITION BY Cust_id ORDER BY Order_Date) AS Row#,
		Cust_id,
		Order_Date
		FROM	dbo.combined_table
		) AS A
WHERE	A.Row# = 1
) AS F,
(
SELECT	A.Cust_id, A.Order_Date AS ThirdPurchase
FROM	(
		SELECT	ROW_NUMBER() OVER (PARTITION BY Cust_id ORDER BY Order_Date) AS Row#,
		Cust_id,
		Order_Date
		FROM	dbo.combined_table
		) AS A
WHERE	A.Row# = 3
) AS T
WHERE	F.Cust_id = T.Cust_id
;

-- 7. Write a query that returns customers who purchased both product 11 and product 14, as well as the ratio of these products to the total number of products purchased by the customer.

SELECT	DISTINCT Customer_Name
FROM	dbo.combined_table
WHERE	Prod_id IN (11, 14)
; -- 322 unique customers purchased prod_11 OR prod_14

SELECT	DISTINCT Customer_Name
FROM	dbo.combined_table
WHERE	Prod_id = 11
; -- 272 unique customers purchased prod_11 

SELECT	DISTINCT Customer_Name
FROM	dbo.combined_table
WHERE	Prod_id = 14
; -- 77 unique customers purchased prod_14 

-- intersection
SELECT	DISTINCT Cust_id
FROM	dbo.combined_table
WHERE	Prod_id = 11

INTERSECT

SELECT	DISTINCT Cust_id
FROM	dbo.combined_table
WHERE	Prod_id = 14
; -- 19 unique customers purchased prod_11 AND prod_14

-- all info of 19 unique customers
SELECT *
FROM	dbo.combined_table
WHERE Cust_id IN
(
SELECT	DISTINCT Cust_id
FROM	dbo.combined_table
WHERE	Prod_id = 11

INTERSECT

SELECT	DISTINCT Cust_id
FROM	dbo.combined_table
WHERE	Prod_id = 14
)
ORDER BY Cust_id
;

--result
SELECT	DISTINCT Cust_id, 
		COUNT(Prod_id) OVER (PARTITION BY Cust_id ORDER BY Cust_id) AS TotalNumberOfProductPurchased,
		ROUND((2.0/(COUNT(Prod_id) OVER (PARTITION BY Cust_id ORDER BY Cust_id))), 3) AS RatioSaidProdToTotal
FROM	dbo.combined_table
WHERE Cust_id IN
(
SELECT	DISTINCT Cust_id
FROM	dbo.combined_table
WHERE	Prod_id = 11

INTERSECT

SELECT	DISTINCT Cust_id
FROM	dbo.combined_table
WHERE	Prod_id = 14
)
;


/* ========== Customer Segmentation ========== 

Categorize customers based on their frequency of visits.



3. For each visit of customers, create the next month of the visit as a separate column.
4. Calculate the monthly time gap between two consecutive visits by each customer.
5. Categorise customers using average time gaps. Choose the most fitted labeling model for you. 
	For example:
		- Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.
		- Labeled as regular if the customer has made a purchase every month. Etc.

*/

-- 1. Create a “view” that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
CREATE VIEW cust_visit_monthly AS
	SELECT	Cust_id, YEAR(Order_Date) AS [Year], MONTH(Order_Date) AS [Month]
	FROM	dbo.combined_table
	;

SELECT *
FROM cust_visit_monthly
ORDER BY Cust_id
;

/* ========== Month-Wise Retention Rate ========== */

SELECT	DISTINCT COUNT(Cust_id) OVER (PARTITION BY MONTH(Order_Date) ORDER BY YEAR(Order_Date)) AS RetentionCurrentMonth
FROM	dbo.combined_table
--WHERE	YEAR(Order_Date) = 2009
;

SELECT MIN(Order_Date) AS StartOfBusiness, MAX(Order_Date) AS EndOfBusiness
FROM dbo.combined_table
; -- Start of business: 2009-01-01,	End of business: 2012-12-30, span is 4 years

-- Jan 2009, this is baseline. Start of business
SELECT	COUNT(DISTINCT Cust_id) AS UniqueCustCount_0109
FROM	dbo.combined_table
WHERE	YEAR(Order_Date) = 2009 AND MONTH(Order_Date) = '01'
; -- 138 unique customers in Jan 2009

SELECT	DISTINCT(Cust_id) AS RetentionCustID_0109
FROM	dbo.combined_table
WHERE	YEAR(Order_Date) = 2009 AND MONTH(Order_Date) = '01'
; -- unique customers in Jan 2009

SELECT	COUNT(DISTINCT Cust_id) AS RetentionCount_0209
FROM	dbo.combined_table
WHERE	YEAR(Order_Date) = 2009 AND MONTH(Order_Date) = '02'
; -- 101 unique customers in Feb 2009

CREATE VIEW RetentionCount_0209 AS
	SELECT	COUNT(DISTINCT Cust_id) AS RetentionCount_0209
	FROM	dbo.combined_table
	WHERE	YEAR(Order_Date) = 2009 AND MONTH(Order_Date) = '02'
; -- 101 unique customers in Feb 2009

SELECT * FROM RetentionCount_0209; -- 101 unique customers in Feb 2009

SELECT	DISTINCT(Cust_id) AS Retention_0209
FROM	dbo.combined_table
WHERE	YEAR(Order_Date) = 2009 AND MONTH(Order_Date) = '02'
; -- unique customers in Feb 2009

-- intersection

SELECT	COUNT(DISTINCT Cust_id)	AS RetainedCustCount_0209, 
		ROUND(1.0 * COUNT(DISTINCT Cust_id)	/ (SELECT * FROM RetentionCount_0209), 3) AS MonthWiseRetentionRate_Feb09
FROM	dbo.combined_table
WHERE Cust_id IN
(
SELECT	DISTINCT(Cust_id)
FROM	dbo.combined_table
WHERE	YEAR(Order_Date) = 2009 AND MONTH(Order_Date) = '01'
INTERSECT
SELECT	DISTINCT(Cust_id)
FROM	dbo.combined_table
WHERE	YEAR(Order_Date) = 2009 AND MONTH(Order_Date) = '02'
)
; -- 10,9 %

-- Mar 2009

CREATE VIEW RetentionCount_0309 AS
	SELECT	COUNT(DISTINCT Cust_id) AS RetentionCount_0309
	FROM	dbo.combined_table
	WHERE	YEAR(Order_Date) = 2009 AND MONTH(Order_Date) = '03'
;

SELECT * FROM RetentionCount_0309; -- 128 unique customers in Feb 2009

SELECT	COUNT(DISTINCT Cust_id)	AS RetainedCustCount_0309, 
		ROUND(1.0 * COUNT(DISTINCT Cust_id)	/ (SELECT * FROM RetentionCount_0309), 3) AS MonthWiseRetentionRate_Mar09
FROM	dbo.combined_table
WHERE Cust_id IN
(
SELECT	DISTINCT(Cust_id)
FROM	dbo.combined_table
WHERE	YEAR(Order_Date) = 2009 AND MONTH(Order_Date) = '02'
INTERSECT
SELECT	DISTINCT(Cust_id)
FROM	dbo.combined_table
WHERE	YEAR(Order_Date) = 2009 AND MONTH(Order_Date) = '03'
)
; -- 10,2%

