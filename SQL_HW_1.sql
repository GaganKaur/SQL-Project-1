--1a. You need a list of all the actors’ first name and last name

SELECT first_name , last_name FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name

SELECT upper(first_name ||' '|| last_name) AS full_name FROM actor;

-- 2a. You need to find the id, first name, and last name of an actor, of whom you know only the first name of "Joe." 
--What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name FROM actor 
WHERE first_name = 'JOE';

-- 2b. Find all actors whose last name contain the letters GEN. Make this case insensitive

SELECT actor_id, first_name, last_name FROM actor 
WHERE upper(last_name) LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. 
--This time, order the rows by last name and first name, in that order. Make this case insensitive.

SELECT actor_id, first_name, last_name FROM actor 
WHERE upper(last_name) LIKE '%LI%' ORDER BY last_name, first_name; 

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT * FROM country 
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a middle_name column to the table actor. Specify the appropriate column type

ALTER TABLE actor
ADD middle_name VARCHAR(255);

-- 3b. You realize that some of these actors have tremendously long last names. 
--Change the data type of the middle_name column to something that can hold more than varchar.

ALTER TABLE actor
ALTER COLUMN middle_name TYPE TEXT;

-- 3c. Now write a query that would remove the middle_name column.

ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(last_name)
FROM actor GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
--but only for names that are shared by at least two actors

SELECT last_name, COUNT(last_name)
FROM actor GROUP BY last_name HAVING COUNT(last_name)>1;

-- 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS.
-- Write a query to fix the record.

UPDATE actor 
SET first_name = 'HARPO', last_name = 'WILLIAMS'
WHERE first_name  = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all!

UPDATE actor SET first_name =  
    (CASE 
	WHEN (first_name = 'HARPO') THEN 'GROUCHO'
	WHEN (first_name = 'GROUCHO') THEN 'MUCHO GROUCHO'
ELSE first_name
            END);

-- 6a. Use a JOIN to display the first and last names, as well as the address, of each staff member.
-- Use the tables staff and address:

SELECT s.first_name, s.last_name, d.address_id, d.address,
d.address2, d.district, d.city_id, d.postal_code 
FROM address d INNER JOIN staff s 
ON d.address_id = s.address_id; 


-- 6b. Use a JOIN to display the total amount rung up by each staff member in January of 2007. 
--Use tables staff and payment.

SELECT s.first_name, s.last_name, s.staff_id, SUM(pymt.amount)
FROM staff s JOIN payment pymt ON
s.staff_id = pymt.staff_id WHERE pymt.payment_date BETWEEN
'2007-01-01 00:00:00.00' AND '2007-01-31 23:59:59.999'
GROUP BY s.staff_id;


-- You’ll have to google for this one, we didn’t cover it explicitly in class. 
-- 6c. List each film and the number of actors who are listed for that film. 
--Use tables film_actor and film. Use inner join.

SELECT COUNT(fa.actor_id), f.film_id, f.title
FROM film_actor fa JOIN film f ON
fa.film_id = f.film_id
GROUP BY f.film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(i.inventory_id) AS Copies FROM inventory i WHERE
film_id = (SELECT film_id FROM film
	WHERE title = 'HUNCHBACK IMPOSSIBLE');

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer.
-- List the customers alphabetically by last name:

SELECT c.first_name, c.last_name, c.customer_id,
SUM(pymt.amount) AS total_paid FROM customer c JOIN payment pymt
ON c.customer_id = pymt.customer_id
GROUP BY c.customer_id ORDER BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
--As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
-- display the titles of movies starting with the letters K and Q whose language is English.

SELECT f.title FROM film f JOIN language l
ON f.language_id = l.language_id 
WHERE f.title LIKE 'K%' OR f.title LIKE 'Q%'
AND l.name = 'English';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT act.first_name, act.last_name FROM 
actor act JOIN film_actor fa 
ON act.actor_id = fa.actor_id JOIN film f
ON fa.film_id = f.film_id
WHERE f.title = 'ALONE TRIP';

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and 
-- email addresses of all Canadian customers. Use joins to retrieve this information.

SELECT cust.first_name, cust.last_name, cust.email FROM 
customer cust JOIN address adrs ON
cust.address_id = adrs.address_id JOIN city ON
city.city_id = adrs.city_id JOIN country ON 
city.country_id = country.country_id
WHERE country.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a 
-- promotion. Identify all movies categorized as a family film.
-- Now we mentioned family film, but there is no family film category. There’s a category that resembles that. In the real world nothing will be exact.

SELECT f.* FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(f.film_id) AS Frequency 
FROM film f JOIN inventory i 
ON f.film_id = i.film_id JOIN rental r 
ON r.inventory_id = i.inventory_id GROUP BY f.film_id
ORDER BY Frequency DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT CAST(SUM(pymt.amount) as money), s.store_id
FROM payment pymt JOIN store s ON 
pymt.staff_id = s.manager_staff_id
GROUP BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, city.city, cnty.country FROM store s 
JOIN address adrs ON 
s.address_id = adrs.address_id
JOIN city ON
adrs.city_id = city.city_id
JOIN country cnty ON
cnty.country_id = city.country_id;

-- 7h. List the top five genres in gross revenue in descending order.

SELECT SUM(pymt.amount) AS Total_Revenue , 
fc.category_id, ctgry.name FROM
payment pymt JOIN rental r ON
pymt.rental_id = r.rental_id JOIN
inventory i ON 
r.inventory_id = i.inventory_id JOIN
film_category fc ON
i.film_id = fc.film_id JOIN category ctgry ON
fc.category_id = ctgry.category_id
GROUP BY fc.category_id, ctgry.name
ORDER BY Total_Revenue DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five 
--genres by gross revenue. Use the solution from the problem above to create a view.

CREATE VIEW TOP_FIVE_GENRES_BY_REVENUE AS
SELECT SUM(pymt.amount) AS Total_Revenue , 
fc.category_id, ctgry.name FROM
payment pymt JOIN rental r ON
pymt.rental_id = r.rental_id JOIN
inventory i ON 
r.inventory_id = i.inventory_id JOIN
film_category fc ON
i.film_id = fc.film_id JOIN category ctgry ON
fc.category_id = ctgry.category_id
GROUP BY fc.category_id, ctgry.name
ORDER BY Total_Revenue DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM TOP_FIVE_GENRES_BY_REVENUE;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW TOP_FIVE_GENRES_BY_REVENUE;


