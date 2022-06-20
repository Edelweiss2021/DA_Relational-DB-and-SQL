/*
===== Session-12 (20 Jun 22) Indexing & Python DB API ========
*/

/* =================== Pre-Class ====================== */



/* =================== In-Class ====================== */

-- ///////////////// Indexing //////////////////////

--SEE INDEXs in TABLE
--EXECUTE sp_helpindex departments;
--GO

--first we create the framework of table.

USE SampleRetail;

create table website_visitor 
(
visitor_id int,
ad varchar(50),
soyad varchar(50),
phone_number bigint,
city varchar(50)
);

--first we populate the table.

DECLARE @i int = 1
DECLARE @RAND AS INT
WHILE @i<200000
BEGIN
	SET @RAND = RAND()*81
	INSERT website_visitor
		SELECT @i , 'visitor_name' + cast (@i as varchar(20)), 'visitor_surname' + cast (@i as varchar(20)),
		5326559632 + @i, 'city' + cast(@RAND as varchar(2))
	SET @i +=1
END;

-- check the table
SELECT TOP 10 *
FROM website_visitor
;

--we turn on stats (Process ve time) to see transaction details.
SET STATISTICS IO on
SET STATISTICS TIME on

-- a simple query

SELECT *
FROM
website_visitor
where
visitor_id = 100
;

-- index name must be unique throughout database
Create CLUSTERED INDEX CLS_INX_1 ON website_visitor (visitor_id);

SELECT *
FROM
website_visitor
where
visitor_id = 100
;

SELECT ad
FROM
website_visitor
where
ad = 'visitor_name17'
;

CREATE NONCLUSTERED INDEX inx_NoN_CLS_1 ON website_visitor (ad);

SELECT ad
FROM
website_visitor
where
ad = 'visitor_name17'
;

SELECT ad, soyad
FROM
website_visitor
where
ad = 'visitor_name17'
;

Create unique NONCLUSTERED INDEX inx_NoN_CLS_2 ON website_visitor (ad) include (soyad);

SELECT ad, soyad
FROM
website_visitor
where
ad = 'visitor_name17'
;

-- clustered index (visitor_id)
-- non-clustered index (ad)
-- non-clustered index (ad) include (soyad)

SELECT soyad
FROM
website_visitor
where
soyad = 'visitor_name17'
;






-- ///////////////// Python DB API //////////////////////

USE TestA;

SELECT	*
FROM	TestTable;

SELECT @@ROWCOUNT; 


-- QUERY: 
