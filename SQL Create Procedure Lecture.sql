-- Stored Procedures

-- Syntax:
CREATE OR REPLACE PROCEDURE add_actor(first_name varchar, last_name varchar)
LANGUAGE plpgsql
AS $add_actor$
BEGIN 
	INSERT INTO actor (first_name, last_name)
	VALUES (first_name, last_name); 
END;
$add_actor$;


-- Lecture starts here:

SELECT *
FROM customer c ;

-- if you don't have loyalty member column excute the following:

ALTER TABLE customer 
ADD COLUMN loyalty_member boolean;

-- reset all customers to be false on the LM column
UPDATE customer 
SET loyalty_member = FALSE;

-- loyalty member column is now empty

SELECT *
FROM customer c 
WHERE loyalty_member = FALSE;

-- create a procedure to update our customers to be LMs if they have spent over $100

-- step 1: get all IDs of customers who've spent over $100

SELECT customer_id 
FROM payment p 
GROUP BY customer_id 
HAVING sum(amount) >= 100;

--ustomer_id|
------------+
--        87|
--       477|
--       273|
--       550|
--        51|

-- Stored Procedure
SELECT *
FROM customer c 
WHERE customer_id = 87;

-- use 87 for testing purposes

-- step 2:
UPDATE customer 
SET loyalty_member = TRUE 
WHERE customer_id IN (
	SELECT customer_id 
	FROM payment p 
	GROUP BY customer_id 
	HAVING sum(amount) >= 100
);

SELECT *
FROM customer c 
WHERE customer_id = 87;

SELECT *
FROM customer c 
WHERE loyalty_member = TRUE ;


-- We are going to take the above steps and convert to pro
-- Create or replace is because you can't create 2 things with same name. That's why 'or replace'.

CREATE OR REPLACE PROCEDURE update_loyalty(loyalty_min NUMERIC(5,2) DEFAULT 100.00)
LANGUAGE plpgsql
AS $$
BEGIN 
	UPDATE customer 
	SET loyalty_member = TRUE 
	WHERE customer_id IN (
		SELECT customer_id 
		FROM payment p 
		GROUP BY customer_id 
		HAVING sum(amount) >= loyalty_min
);
END;
$$;

-- Use a procedure, - use CALL

CALL update_loyalty ();

-- Updated Rows 0
-- Query CALL update_loyalty 0 ...

SELECT *
FROM customer c 
WHERE loyalty_member = TRUE ;


-- mimic a customer making a purchase that will put them over the new threshold
-- find a test customer: close to $100
SELECT customer_id, sum(amount)
FROM payment p 
GROUP BY customer_id 
HAVING sum(amount) BETWEEN 95 AND 100;

-- 554 it's your lucky day, you are our tester!

SELECT *
FROM customer c 
WHERE customer_id = 554;

--  |active|loyalty_member|
----+------+--------------+
--77|     1|false         |


-- check Dwayne out and give total:

INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (554, 1, 508, 5.99, '2023-10-19 13:07:45'); 

-- call the procedure again!

CALL update_loyalty();

SELECT *
FROM customer c 
WHERE customer_id = 554;

SELECT count(*) 
FROM customer c 
WHERE loyalty_member = TRUE ;
-- 297


-- lets say boss man said 75 is the new cap, so lets get more loyalty members in!

CALL update_loyalty (75);
-- it didn't work because the create or replace procedure had a min of 100

SELECT count(*) 
FROM customer c 
WHERE loyalty_member = TRUE;
-- 521


-- Procedure to add an actor into our actor table

SELECT *
FROM actor a ;

--SELECT now(); - gives you the time now

INSERT INTO actor (first_name, last_name, last_update)
VALUES ('Brian', 'Stanton', now());

INSERT INTO actor (first_name, last_name, last_update)
VALUES ('Sarah', 'Stodder', now());

-- Procedure to add an actor into our actor table
SELECT *
FROM actor a 
WHERE last_name LIKE 'S%';

--actor_id|first_name|last_name  |last_update            |
----------+----------+-----------+-----------------------+
--       9|Joe       |Swank      |2013-05-26 14:47:57.620|
--      24|Cameron   |Streep     |2013-05-26 14:47:57.620|
--      31|Sissy     |Sobieski   |2013-05-26 14:47:57.620|
--      44|Nick      |Stallone   |2013-05-26 14:47:57.620|
--      78|Groucho   |Sinatra    |2013-05-26 14:47:57.620|
--     116|Dan       |Streep     |2013-05-26 14:47:57.620|
--     180|Jeff      |Silverstone|2013-05-26 14:47:57.620|
--     192|John      |Suvari     |2013-05-26 14:47:57.620|
--     195|Jayne     |Silverstone|2013-05-26 14:47:57.620|
--     201|Brian     |Stanton    |2023-10-19 09:19:56.392|
--     202|Sarah     |Stodder    |2023-10-19 09:20:31.212|

INSERT INTO actor (first_name, last_name)
VALUES ('Kevin','Beier'); 
-- IF you don't know the third value, use DEFAULT


SELECT *
FROM actor a 
ORDER BY actor_id DESC ;

--actor_id|first_name |last_name   |last_update            |
----------+-----------+------------+-----------------------+
--     203|Kevin      |Beier       |2023-10-19 09:23:48.122|
--     202|Sarah      |Stodder     |2023-10-19 09:20:31.212|
--     201|Brian      |Stanton     |2023-10-19 09:19:56.392|
--     200|Thora      |Temple      |2013-05-26 14:47:57.620|
--     199|Julia      |Fawcett     |2013-05-26 14:47:57.620|
--     198|Mary       |Keitel      |2013-05-26 14:47:57.620|
--     197|Reese      |West        |2013-05-26 14:47:57.620|



-- procedure time! 

CREATE OR REPLACE PROCEDURE add_actor(first_name varchar, last_name varchar)
LANGUAGE plpgsql
AS $add_actor$
BEGIN 
	INSERT INTO actor (first_name, last_name)
	VALUES (first_name, last_name); 
END;
$add_actor$;


CALL add_actor ('Adam', 'Driver');
CALL add_actor ('Mark', 'Hammil');

SELECT *
FROM actor a 
ORDER BY actor_id DESC ;

--actor_id|first_name |last_name  |last_update            |
----------+-----------+-----------+-----------------------+
--     205|Mark       |Hammil     |2023-10-19 09:29:58.002|
--     204|Adam       |Driver     |2023-10-19 09:29:54.947|
--     203|Kevin      |Beier      |2023-10-19 09:23:48.122|
--     202|Sarah      |Stodder    |2023-10-19 09:20:31.212|
--     201|Brian      |Stanton    |2023-10-19 09:19:56.392|
--     200|Thora      |Temple     |2013-05-26 14:47:57.620|
--     199|Julia      |Fawcett    |2013-05-26 14:47:57.620|



-- to DELETE:

DROP PROCEDURE IF EXISTS add_actor;

-- you get a confirmation







