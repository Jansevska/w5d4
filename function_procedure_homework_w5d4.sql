-- HOMEWORK W5D4

--1. Create a Stored Procedure that will insert a new film into the film table with the
--following arguments: title, description, release_year, language_id, rental_duration,
--rental_rate, length, replace_cost, rating

CREATE OR REPLACE PROCEDURE add_film(title varchar, description TEXT, release_year YEAR, language_id int2, rental_duration int2, rental_rate NUMERIC(4,2), lengh int2, replacement_cost NUMERIC (5,2), rating mpaa_rating DEFAULT 'G'::mpaa_rating);
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO film(title, description, release_year, language_id, rental_duration, rental_rate, lengh, replacement_cost, rating)
	VALUES (title, description, release_year, language_id, rental_duration, rental_rate, lengh, replacement_cost, rating);
END;
$$;

CALL add_film ('The Confused Cactus Caper', 'In this hilarious desert adventure, a forgetful cactus named Carl embarks on a quest to find his missing thorns. Join him on a prickly journey filled with mishaps, unlikely friendships, and a whole lot of water-related humor.', 2023, 1, 6, 3.99, 86, 40.00);

DROP PROCEDURE IF EXISTS add_film;

SELECT *
FROM film f ;





--2. Create a Stored Function that will take in a category_id and return the number of
--films in that category
SELECT c.category_id, count(fc.category_id) AS num_movies_in_cat
FROM category c
JOIN film_category fc 
ON c.category_id = fc.category_id 
GROUP BY c.category_id
ORDER BY num_movies_in_cat;

SELECT count(category_id) 
FROM film_category fc 
GROUP BY category_id;


SELECT count(category_id) AS num_film_in_cat
FROM film_category fc 
GROUP BY category_id ;


SELECT *
FROM film_category fc;



CREATE OR REPLACE FUNCTION get_category_count(category_id int2)
RETURNS int2
LANGUAGE plpgsql
AS $$
	DECLARE cat_total int2;
BEGIN 
	SELECT count(*) INTO cat_total
	FROM film_category 
	GROUP BY category_id;
	RETURN cat_total;
END;
$$;

SELECT get_category_count(category_id 15);

DROP FUNCTION IF EXISTS get_category_count()



