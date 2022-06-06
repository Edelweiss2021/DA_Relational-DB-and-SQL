/*
===== Built-in Functions ========
*/

--TRIM() Removes leading and trailing spaces (or other specified characters) from a string

SELECT TRIM(' Character');

SELECT ('     Character');

SELECT GETDATE();
SELECT TRIM('X' FROM 'ABCXXDE')

SELECT TRIM('X' FROM 'XxxXABCXXDExxxXx')

SELECT TRIM('r' FROM ' Character');

SELECT TRIM(  '  Char acter     ')

--To trim a list of characters
SELECT TRIM('ABC' FROM 'CCCCBBBAAAFRHGKDFKSLDFJKSDFACBBCACABACABCA')
--FRHGKDFKSLDFJKSDF

--LTRIM()
SELECT LTRIM('     Character')

--RTRIM()
SELECT RTRIM('     Character                  ')

--REPLACE() Replaces all occurrences of a substring within a string, with a new substring

SELECT REPLACE('CHAR ACT ER STR ING', ' ', '//')

SELECT REPLACE('CHARACTER STRING', 'CHARACTER STRING', 'INPUT')

-- STR() Returns a number as string

SELECT STR(454);
--       454
SELECT LEN(STR(454));

SELECT STR (2132343445);

SELECT STR (133215.654645, 11, 4)

SELECT STR(123456789123456)

-- CAST()
SELECT CAST (12345 AS CHAR)

SELECT CAST (123.65 AS INT)

SELECT 'customer' + '_' + CAST(1 AS VARCHAR(1)) AS col;

--CONVERT()

SELECT CONVERT(int, 30.60)

SELECT CONVERT (VARCHAR(10), '2020-10-10')

SELECT CONVERT (DATETIME, '2020-10-10')

SELECT CONVERT (NVARCHAR, GETDATE(),112 )

SELECT CAST ('20201010' AS DATE)

SELECT CONVERT (NVARCHAR, CAST ('20201010' AS DATE),103 )

-- COALESCE() Evaluates the arguments in order and returns the current value of the first expression that initially doesn't evaluate to NULL. 
--For example, SELECT COALESCE(NULL, NULL, 'third_value', 'fourth_value'); returns the third value because the third value is the first value that isn't null.

SELECT COALESCE (NULL, 'Hi', 'Hello', NULL);

-- NULLIF() 
/* Returns a null value if the two specified expressions are equal. For example, SELECT NULLIF(4,4) AS Same, NULLIF(5,7) AS Different; returns NULL for the first column (4 and 4) because the two input values are the same. The second column returns the first value (5) because the two input values are different.
*/
SELECT NULLIF(10, 10);

SELECT NULLIF(10, 11);

-- ROUND() Returns a numeric value, rounded to the specified length or precision.

SELECT ROUND (432.368, 2, 0);

SELECT ROUND (432.368, 2, 1);

SELECT ROUND (432.368, 2);

-- ISNULL() Replaces NULL with the specified replacement value.

SELECT ISNULL(NULL, 'ABC');

SELECT ISNULL('', 'ABC');

SELECT ISNULL(None, 'ABC'); -- returns error message

-- ISNUMERIC() Determines whether an expression is a valid numeric type.

SELECT ISNUMERIC(123);

SELECT ISNUMERIC('ABC');

SELECT ISNUMERIC(STR(123));


/*
===== JOIN ========
*/

-- INNER JOIN

SELECT A.product_id, A.product_name, B.category_id, B.category_name
FROM product.product AS A
INNER JOIN product.category AS B
ON A.category_id = B.category_id;


SELECT A.first_name, A.last_name, B.store_name
FROM sale.staff AS A
INNER JOIN sale.store AS B
ON A.store_id = B.store_id;

-- LEFT JOIN

SELECT A.product_id, A.product_name, B.order_id
FROM product.product A
LEFT JOIN sale.order_item B
ON A.product_id = B.product_id
WHERE B.order_id IS NULL;

SELECT A.product_id, A.product_name, B.*
FROM product.product A
LEFT JOIN product.stock B
ON A.product_id = B.product_id
WHERE A.product_id > 310; -- returns 237 rows, beware the condition (A.product_id)

SELECT A.product_id, A.product_name, B.*
FROM product.product A
LEFT JOIN product.stock B
ON A.product_id = B.product_id
WHERE B.product_id > 310; --returns 159 rows,  beware the condition (B.product_id)

-- RIGHT JOIN

SELECT B.product_id, B.product_name, A.*
FROM product.stock A
RIGHT JOIN product.product B
ON A.product_id = B.product_id
WHERE B.product_id > 310; 

-- FULL OUTER JOIN

SELECT TOP 100 A.product_id, B.store_id, B.quantity, C.order_id, C.list_price
FROM product.product A
FULL OUTER JOIN product.stock B
ON A.product_id = B.product_id
FULL OUTER JOIN sale.order_item C
ON A.product_id = C.product_id
ORDER BY B.store_id DESC;

-- CROSS JOIN

SELECT	B.store_id, A.product_id, 0 quantity
FROM	product.product A
CROSS JOIN sale.store B
WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id;