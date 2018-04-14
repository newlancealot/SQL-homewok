-- 1a. You need a list of all the actors who have Display the first and last names of all actors from 
		-- the table actor. 
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name 
		-- the column Actor Name.
        
USE sakila;

SELECT * FROM sakila.actor; -- print actor name

SELECT First_Name AS FirstName
     , Last_Name AS LastName
     , CONCAT_WS(' ', first_name, last_name) AS NAME 
  FROM actor

-- * 2a. You need to find the ID number, first name, and last name of an actor, of whom you 
-- know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE first_name IN ('Joe');
  	
-- * 2b. Find all actors whose last name contain the letters `GEN`:
SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE last_name LIKE '%GEN%';
  	
-- * 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows 
-- by last name and first name, in that order:
SELECT actor_id, last_name, first_name 
FROM sakila.actor
WHERE last_name LIKE '%LI%';
-- ORDER BY LAST_NAME, [FIRST_NAME] [ASC [DESC]]
ORDER BY LAST_NAME, [ASC]
-- * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries:
-- Afghanistan, Bangladesh, and China:

SELECT country_id, country
FROM sakila.country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. 
-- Hint: you will need to specify the data type.


ALTER TABLE sakila.actor
ADD COLUMN middle_name varchar(15) AFTER first_name;
SELECT * FROM actor

-- 3b. You realize that some of these actors have tremendously long last names. 
-- Change the data type of the middle_name column to blobs.

ALTER TABLE actor MODIFY middle_name BLOB;

-- 3c. Now delete the middle_name column.

ALTER TABLE table
DROP column;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT count(*) as 'Last Name Count', last_name FROM sakila.actor
GROUP BY last_name
having count(last_name) > 1;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

SELECT count(*) as 'Last Name Count', last_name FROM sakila.actor
GROUP BY last_name
having count(last_name) = 2;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
select first_name, Last_name,actor_id
FROM sakila.actor
WHERE first_name IN ('groucho');

update sakila.actor
SET first_name = "Harpo", last_name= "Williams"
WHERE actor_id = 172
     

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was 
-- the correct name after all! In a single query, if the first name of the actor is currently 
-- HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is 
-- exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST 
-- NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)

select first_name, Last_name,actor_id
FROM sakila.actor
WHERE first_name IN ('harpo');

UPDATE sakila.actor
 SET first_name = 
 CASE 
 WHEN first_name = 'HARPO' 
 THEN 'GROUCHO'
 ELSE 'MUCHO GROUCHO'
 END
 WHERE actor_id = 172;


-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE sakila.address;


-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
USE sakila

SELECT address.address_id, address.address, staff.first_name, staff.first_name, staff.address_id
FROM staff
INNER JOIN address ON
staff.address_id = address.address_id;


-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables 
-- staff and payment. 
SELECT first_name, last_name, SUM(amount)
FROM staff s
INNER JOIN payment p
ON s.staff_id = p.staff_id
GROUP BY p.staff_id


-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. 
-- Use inner join.
use sakila

SELECT title, COUNT(actor_id)
FROM film s
INNER JOIN film_actor p
ON s.film_id = p.film_id
GROUP BY title;


-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT title, COUNT(inventory_id)
FROM film s
INNER JOIN inventory p 
ON s.film_id = p.film_id
WHERE title = "Hunchback Impossible";

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:

   -- ![Total amount paid](Images/total_payment.png)
SELECT last_name, first_name, SUM(amount)
FROM payment s
INNER JOIN customer p
ON s.customer_id = p.customer_id
GROUP BY s.customer_id
ORDER BY last_name;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

SELECT title FROM film
WHERE language_id in
	(SELECT language_id 
	FROM language
	WHERE name = "English" )
AND (title LIKE "K%") OR (title LIKE "Q%");

 
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT last_name, first_name
FROM actor
WHERE actor_id in
	(SELECT actor_id FROM film_actor
	WHERE film_id in 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));
        
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email 
-- addresses of all Canadian customers. Use joins to retrieve this information.


SELECT country, last_name, first_name, email
FROM country s
LEFT JOIN customer p
ON s.country_id = p.customer_id
WHERE country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.

SELECT title, category
FROM film_list
WHERE category = 'Family';
		

-- 7e. Display the most frequently rented movies in descending order.

SELECT s.film_id, p.title, COUNT(r.inventory_id)
FROM inventory s
INNER JOIN rental r
ON s.inventory_id = r.inventory_id
INNER JOIN film_text p 
ON s.film_id = p.film_id
GROUP BY r.inventory_id
ORDER BY COUNT(r.inventory_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT store.store_id, SUM(amount)
FROM store
INNER JOIN staff
ON store.store_id = staff.store_id
INNER JOIN payment p 
ON p.staff_id = staff.staff_id
GROUP BY store.store_id
ORDER BY SUM(amount);

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, city, country
FROM store s
INNER JOIN customer cu
ON s.store_id = cu.store_id
INNER JOIN staff st
ON s.store_id = st.store_id
INNER JOIN address a
ON cu.address_id = a.address_id
INNER JOIN city ci
ON a.city_id = ci.city_id
INNER JOIN country coun
ON ci.country_id = coun.country_id;
WHERE country = 'CANADA' AND country = 'AUSTRAILA';


-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following 
-- tables: category, film_category, inventory, payment, and rental.)

SELECT name, SUM(p.amount)
FROM category c
INNER JOIN film_category fc
INNER JOIN inventory i
ON i.film_id = fc.film_id
INNER JOIN rental r
ON r.inventory_id = i.inventory_id
INNER JOIN payment p
GROUP BY name
LIMIT 5;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by 
-- gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can 
-- substitute another query to create a view.

use sakila

CREATE VIEW Top_five_genres AS
SELECT name, SUM(p.amount)
FROM category c
INNER JOIN film_category fc
INNER JOIN inventory i
ON i.film_id = fc.film_id
INNER JOIN rental r
ON r.inventory_id = i.inventory_id
INNER JOIN payment p
GROUP BY name
LIMIT 5;

-- use sakila

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM Top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. 
-- Write a query to delete it.

drop Top_five_genres;

