/*
===== RDB&SQL Assignment-5 (23 Jun 22) =============

Create a scalar-valued function that returns the factorial of a number you gave it.

*/

CREATE FUNCTION dbo.fnc_factorial
(
@inputnumber INT
)
RETURNS BIGINT
AS
	BEGIN
		DECLARE
			@counter INT,
			@result INT
		
		SET @counter = 1
		
		WHILE @counter < @inputnumber
			BEGIN
				SET @result = @counter * (@counter + 1)
				SET @counter += 1
			END
		RETURN @result
	END
;

SELECT dbo.fnc_factorial(5);
