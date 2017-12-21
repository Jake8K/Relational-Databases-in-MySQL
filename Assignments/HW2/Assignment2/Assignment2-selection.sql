----------------------------------------------------------------------------------------------------------------X
                                            -- 1 --

-- #1 Find all films with maximum length and minimum rental duration (compared to all other films).
--  In other words let L be the maximum film length, and let R be the minimum rental duration
--  in the table film. You need to find all films with length L and rental duration R.
--  You just need to return attribute film id for this query.

-- this is the one that should be graded
SELECT DISTINCT film_id FROM film
WHERE rental_duration = (SELECT MIN(rental_duration) FROM film) OR length = (SELECT MAX(length) FROM film);

-- this one has 2 extra columns to verify the success of the query
SELECT DISTINCT film_id, rental_duration, length FROM film
WHERE rental_duration = (SELECT MIN(rental_duration) FROM film) OR length = (SELECT MAX(length) FROM film);

    -- where length is greatest  AND rental duration is least
    -- returns f.id 872  (GOOD!!!)
        -- Update: needs to be either or and if both (ie 872) it can only show up once
        -- GOOD! returns 212 movies with either rental_duration == 3 or length 185 or both (once)
----------------------------------------------------------------------------------------------------------------X
                                            -- 2 --

-- #2 We want to find out how many of each category of film ED CHASE has started in so return a
--  table with category.name and the count of the number of films that ED was in which were in
--  that category order by the category name ascending (Your query should return every category
--  even if ED has been in no films in that category).

SELECT c.name, COUNT(a.actor_id) AS count FROM category c
LEFT JOIN film_category fc ON fc.category_id = c.category_id
LEFT JOIN film f ON f.film_id = fc.film_id
LEFT JOIN film_actor fa ON fa.film_id = f.film_id
LEFT JOIN actor a ON a.actor_id = fa.actor_id
AND a.first_name = "ED" AND a.last_name = "CHASE"
GROUP BY c.name;
-------- (GOOD!!!) FINALLY

  -- SELECT c.name, count(a.actor_id) AS count
    -- FROM film f, film_category fc, category c, film_actor fa, actor a
  -- get what i want and then outter join to get every film category
----------------------------------------------------------------------------------------------------------------X
                                              -- 3 --

-- #3 Find the first name, last name and total combined film length of Sci-Fi films for every actor
--   That is the result should list the names of all of the actors(even if an actor has not
--   been in any Sci-Fi films)and the total length of Sci-Fi films they have been in.

SELECT a.first_name, a.last_name, SUM(IFNULL(SciFis.length, 0)) AS "Total Sci Fi Movie Time" FROM actor a
LEFT JOIN
(SELECT fa.actor_id, f.length FROM film_actor fa
INNER JOIN film f ON f.film_id = fa.film_id
INNER JOIN film_category fc ON fc.film_id = f.film_id
INNER JOIN category c ON fc.category_id = c.category_id
AND c.name = "Sci-Fi") AS SciFis ON SciFis.actor_id = a.actor_id
GROUP BY a.actor_id  -- <--< for the sum
ORDER BY a.first_name;

----------------------------------------------------------------------------------------------------------------X
                                              -- 4 --

-- #4 Find the first name and last name of all actors who have never been in a Sci-Fi film

SELECT a.first_name, a.last_name FROM actor a
WHERE a.actor_id NOT IN (SELECT fa.actor_id FROM film_actor fa
INNER JOIN film_category fc ON fc.film_id = fa.film_id
INNER JOIN category c ON fc.category_id = c.category_id
AND c.name = "Sci-Fi")
ORDER BY a.first_name;

    -- returns 33 rows of actors (GOOD!!!)

----------------------------------------------------------------------------------------------------------------X
                                            -- 5 --

-- #5 Find the film title of all films which feature both KIRSTEN PALTROW and WARREN NOLTE
--  Order the results by title, descending (use ORDER BY title DESC at the end of the query)
--  Warning, this is a tricky one and while the syntax is all things you know, you have to think oustide
--  the box a bit to figure out how to get a table that shows pairs of actors in movies

SELECT f.title FROM film f INNER JOIN
 (SELECT f.film_id FROM film f
 INNER JOIN film_actor fa ON fa.film_id = f.film_id
 INNER JOIN actor a ON a.actor_id = fa.actor_id
 WHERE a.first_name = "KIRSTEN" AND a.last_name = "PALTROW") AS KP ON f.film_id = KP.film_id
INNER JOIN
 (SELECT f.film_id FROM film f
 INNER JOIN film_actor fa ON fa.film_id = f.film_id
 INNER JOIN actor a ON a.actor_id = fa.actor_id
 WHERE a.first_name = "WARREN" AND a.last_name = "NOLTE") AS WN ON KP.film_id = WN.film_id
 ORDER BY f.title DESC;

      -- returns 6 rows of movies descending (GOOD!!!)

----------------------------------------------------------------------------------------------------------------X
