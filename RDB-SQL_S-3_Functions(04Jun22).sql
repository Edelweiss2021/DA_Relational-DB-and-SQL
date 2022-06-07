/*  ========= Session-3 (04 Jun 22) ========= */

-- Recap SQL Basics

/* 
SELECT
FROM
WHERE
ORDER BY
TOP
*/

SELECT TOP 10 *
FROM product.brand
ORDER BY brand_name DESC;

SELECT *
FROM product.brand
WHERE brand_name LIKE 'S%';

SELECT TOP 1 *
FROM product.product
WHERE model_year BETWEEN 2019 AND 2021
ORDER BY model_year ASC;

SELECT *
FROM product.product
WHERE category_id IN (3,4,5);

SELECT *
FROM	product.product
WHERE	category_id = 3 OR category_id = 4 OR category_id = 5 -- same with above

SELECT *
FROM product.product
WHERE category_id NOT IN (3,4,5);

SELECT *
FROM product.product
WHERE category_id <> 3 AND category_id != 4 AND category_id <> 5; -- same with above

--

SELECT store_id, product_id, quantity
FROM product.stock
ORDER BY 2,1; -- 2 means 2nd column, 1 means 1st column


/* ======== BUILT-IN FUNCTIONS ========== */

-- //////////////// Date Functions /////////////////////////


CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	);

SELECT * FROM t_date_time;

SELECT GETDATE() as get_date;


INSERT t_date_time
VALUES (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE());

INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES ('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' );

-- Convert DATE to VARCHAR

SELECT GETDATE();

SELECT CONVERT(VARCHAR(10), GETDATE(), 6);

-- Convert VARCHAR to DATE

SELECT CONVERT(DATE, '04 Jun 22', 6);

SELECT CONVERT(DATETIME, '04 Jun 22', 6);

-- DATE FUNCTIONS

-- Functions for returning date or time parts

SELECT	A_DATE,
		DAY(A_DATE) [DAY],
		MONTH(A_DATE) [MONTH],
		YEAR(A_DATE) [YEAR],
		DATENAME(DAYOFYEAR, A_DATE) [Day of Year],
		DATENAME(DW, A_DATE) [Day of Week],
		DATEPART(WEEKDAY, A_DATE) [Weekday],
		DATENAME(MONTH, A_DATE) [Month]
FROM t_date_time;

-- DATEDIFF ( datepart , startdate , enddate ) returns the count (as a signed integer value) of the specified datepart boundaries crossed between the specified startdate and enddate.

SELECT DATEDIFF(DAY, '2022-05-10', GETDATE());

SELECT DATEDIFF(SECOND, '2022-05-10', GETDATE());

-- Find the time delta as day between order date and shipping day.

SELECT *
FROM sale.orders;

SELECT *, DATEDIFF(DAY, order_date,shipped_date) [Time_Delta]
FROM sale.orders
ORDER BY Time_Delta DESC;

SELECT *, DATEDIFF(DAY, order_date,shipped_date) [Time_Delta]
FROM sale.orders
WHERE DATEDIFF(DAY, order_date,shipped_date) > 2;

-- DATEADD (datepart, number, date) adds a number (a signed integer) to a datepart of an input date, and returns a modified date/time value. 

SELECT DATEADD(MINUTE, 5000, GETDATE());

SELECT DATEADD(DAY, 5, GETDATE());

-- EOMONTH (start_date [, month_to_add ]) returns the last day of the month containing a specified date, with an optional offset.

SELECT EOMONTH(GETDATE());

SELECT EOMONTH(GETDATE(), 2);

-- ISDATE (expression) Returns 1 if the expression is a valid datetime value; otherwise, 0.
-- returns 0 if the expression is a datetime2 value.

SELECT ISDATE('2022-05-10');

SELECT ISDATE('10 May 2022');

-- //////////////// String Functions /////////////////////////

-- LEN (string_expression) Returns the number of characters of the specified string expression, excluding trailing spaces.

SELECT LEN('Amazon');

SELECT LEN ('Character')

SELECT LEN ('Character     ')

SELECT LEN ('      Character')

SELECT LEN ('   Character   ')

-- CHARINDEX ( expressionToFind , expressionToSearch [ , start_location ] ) searches for one character expression inside a second character expression, returning the starting position of the first expression if found.

SELECT CHARINDEX('z', 'Amazon');

SELECT CHARINDEX ('r', 'Character', 5);

SELECT CHARINDEX ('act', 'Character');

-- PATINDEX ( '%pattern%' , expression ) Returns the starting position of the first occurrence of a pattern in a specified expression, or zeros if the pattern is not found, on all valid text and character data types.

SELECT PATINDEX('%r', 'Character');

SELECT PATINDEX('t%', 'Character');

SELECT PATINDEX('%h%', 'Character');

SELECT PATINDEX('%a%', 'Character');

SELECT PATINDEX('__a%', 'Character');

SELECT PATINDEX('%r_c%', 'Character');

SELECT PATINDEX('%a____', 'Character');


-- LEFT ( character_expression , integer_expression ) Returns the left part of a character string with the specified number of characters.

SELECT LEFT('character', 3);

-- RIGHT ( character_expression , integer_expression ) Returns the right part of a character string with the specified number of characters.

SELECT RIGHT('character', 3);

-- SUBSTRING ( expression ,start , length ) Returns part of a character, binary, text, or image expression in SQL Server.

SELECT SUBSTRING('Character', 3, 5);

SELECT SUBSTRING('Amazon', 2, 6);

-- LOWER ( character_expression ) Returns a character expression after converting uppercase character data to lowercase.

SELECT LOWER('CHARACTER');

-- UPPER ( character_expression ) Returns a character expression with lowercase character data converted to uppercase.

SELECT UPPER ('amazon');

-- STRING_SPLIT ( string , separator [ , enable_ordinal ] ) A table-valued function that splits a string into rows of substrings, based on a specified separator character.

SELECT *
FROM STRING_SPLIT ('jack,martin,alain,owen', ',');

SELECT value
FROM STRING_SPLIT ('jack,martin,alain,owen', ',');

SELECT value as name
FROM STRING_SPLIT ('jack,martin,alain,owen', ',');

-- write a script that returns first letter as uppercase ('character')

SELECT UPPER(LEFT('character',1));

SELECT SUBSTRING('character', 2, LEN('character'));

SELECT CONCAT(UPPER(LEFT('character',1)), LOWER (SUBSTRING('character', 2, LEN('character')))); --result

SELECT UPPER (LEFT('character', 1)) + LOWER (SUBSTRING('character', 2, LEN('character'))); --result alternate

select concat (UPPER(LEFT('character', 1)),right('character',LEN('character')-1)); -- Matrix

SELECT UPPER(LEFT('character',1))+LOWER(SUBSTRING('character',2,LEN('character'))); -- Vildan

SELECT UPPER(LEFT('character', 1)) + SUBSTRING('character', 2, 9); -- Heagle