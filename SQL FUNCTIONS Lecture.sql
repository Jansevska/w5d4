-- Stored functions

SELECT count(*)
FROM actor a 
WHERE last_name LIKE 'S%';

SELECT count(*)
FROM actor a 
WHERE last_name LIKE 'T%';

-- create a function Syntax:
-- create a function that counts the actors by their last name that starts with a certain "letter"

CREATE FUNCTION get_actor_count(letter varchar)
RETURNS integer
LANGUAGE plpgsql
AS $$
	DECLARE actor_count integer;
BEGIN 
	SELECT count(*) INTO actor_count
	FROM actor
	WHERE last_name LIKE concat(letter, '%');
	RETURN actor_count;
END;
$$;

SELECT get_actor_count('S');

CREATE OR REPLACE FUNCTION get_actor_count(letter varchar)
RETURNS integer
LANGUAGE plpgsql
AS $$
	DECLARE actor_count integer;
BEGIN 
	SELECT count(*) INTO actor_count
	FROM actor
	WHERE last_name LIKE concat(letter, '%');
	RETURN actor_count;
END;
$$;

-- DELETING from database:
DROP FUNCTION IF EXISTS get_actor_count(varchar)

-- create a function that will return the employee with the most transactions
SELECT staff_id, count(*) AS transaction_count
FROM payment p 
GROUP BY staff_id 
ORDER BY count(*) DESC 
LIMIT 1;

SELECT concat(first_name,' ',last_name) AS employee
FROM staff s 
WHERE staff_id = (
	SELECT staff_id
	FROM payment p 
	GROUP BY staff_id 
	ORDER BY count(*) DESC 
	LIMIT 1
);
-- Jon Stephens


-- Same as above function
-- copy and paste the code above but change AS to INTO employee

CREATE OR REPLACE FUNCTION top_sales_employee()
RETURNS varchar
LANGUAGE plpgsql
AS $$
	DECLARE employee varchar;
BEGIN
	SELECT concat(first_name,' ',last_name) INTO employee
	FROM staff s 
	WHERE staff_id = (
		SELECT staff_id
		FROM payment p 
		GROUP BY staff_id 
		ORDER BY count(*) DESC 
		LIMIT 1);
	RETURN employee;
END;
$$;

SELECT top_sales_employee();


-- create a function that returns a table

SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country
FROM customer c 
JOIN address a 
ON c.address_id = a.address_id 
JOIN city ci
ON a.city_id = ci.city_id 
JOIN country co
ON ci.country_id = co.country_id 
WHERE co.country = 'India';

-- when we return a table, you need to specify the what the table will look like

CREATE OR REPLACE FUNCTION customers_in_country(country_name varchar)
RETURNS TABLE (
	first_name varchar(50),
	last_name varchar(50),
	address varchar(50),
	city varchar(50),
	district varchar(50),
	country varchar(50)
	)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country
	FROM customer c 
	JOIN address a 
	ON c.address_id = a.address_id 
	JOIN city ci
	ON a.city_id = ci.city_id 
	JOIN country co
	ON ci.country_id = co.country_id 
	WHERE co.country = country_name;
END;
$$;

-- executing a function that returns a table
SELECT *
FROM customers_in_country('United States') ;

SELECT *
FROM customers_in_country('Nepal') ;

SELECT district, count(*)
FROM customers_in_country('United States')
GROUP BY district;

















