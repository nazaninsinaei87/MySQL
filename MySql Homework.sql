# 1a. Display the first and last names of all actors from the table `actor`. 
USE sakila;
SELECT first_name, last_name
FROM actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. 
USE Sakila;
SELECT concat(first_name, ' ' , last_name) AS 'Actor Name'
FROM actor
ORDER BY concat(first_name, ' ' , last_name);

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
# What is one query would you use to obtain this information?
Use Sakila;
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name='Joe';

#2b. Find all actors whose last name contain the letters `GEN`.
USE Sakila;
SELECT first_name, last_name
FROM actor
WHERE last_name like "%GEN%";

#2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order.
USE Sakila;
SELECT first_name, last_name
FROM actor
WHERE last_name like "%LI%"
ORDER BY last_name, first_name;

#2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China.
USE Sakila;
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan','Bangladesh','China');

#3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.
USE Sakila;
ALTER TABLE actor
ADD COLUMN middle_name varchar(45) not null After first_name;

#3b. You realize that some of these actors have tremendously long last names. Change the data type of the `middle_name` column to `blobs`.
USE Sakila;
ALTER TABLE actor
MODIFY COLUMN middle_name blob;

#3c. Now delete the `middle_name` column.
USE Sakila;
ALTER TABLE actor
DROP COlUMN middle_name;

# 4a. List the last names of actors, as well as how many actors have that last name.
USE Sakila;
SELECT last_name, COUNT(*) AS 'count'
FROM actor
GROUP BY last_name;
  	
# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
USE Sakila;
SELECT last_name, COUNT(last_name) AS 'count'
FROM actor
GROUP BY last_name
HAVING COUNT(last_name)>=2;

  
# 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
USE Sakila;
UPDATE actor
SET first_name='HARPO'
WHERE first_name='GROUCHO' AND last_name='WILLIAMS';  
  
# 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
#It turns out that `GROUCHO` was the correct name after all! 
#In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. 
#Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. 
#BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)

USE Sakila;
UPDATE actor
SET first_name='MUCHO GROUCHO'
WHERE first_name='HARPO'; 


#  5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it? 
USE Sakila;
SHOW CREATE TABLE address;

# 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
USE Sakila;
SELECT first_name, last_name, Address
FROM staff s
INNER JOIN address a
ON s.address_id=a.address_id;

# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 
USE Sakila;
SELECT s.staff_id, first_name, last_name, sum(amount) AS 'Total Amount'
FROM staff s
INNER JOIN payment p
ON s.staff_id=p.staff_id
WHERE payment_date like '2005-08%'
GROUP BY staff_id;

# 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
USE Sakila;
SELECT title, count(actor_id)
FROM film f
INNER JOIN film_actor a
ON f.film_id=a.film_id
GROUP BY title;

# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
USE Sakila;
SELECT title, (SELECT COUNT(*) FROM inventory where film.film_id=inventory.film_id) AS 'Number of Copies'
FROM film 
WHERE title='Hunchback Impossible';

# 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
USE Sakila;
SELECT first_name, last_name, sum(amount) AS 'Total Amount Paid'
FROM customer c
INNER JOIN payment p
on c.customer_id=p.customer_id
GROUP BY c.customer_id
ORDER BY last_name;

# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
# As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
# Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 

USE Sakila;
SELECT title
FROM film
WHERE title like "K%" or title like "Q%"
AND language_id IN (SELECT language_id 
FROM language
WHERE name='English');

# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
USE Sakila;
SELECT first_name, last_name 
FROM actor
WHERE actor_id IN (SELECT actor_id
FROM film_actor a
INNER JOIN film f
ON a.film_id=f.film_id
WHERE title='Alone Trip');
   
# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
USE Sakila;
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (SELECT address_id
FROM address a 
INNER JOIN city c
ON a.city_id=c.city_id
WHERE c.city_id IN (SELECT city_id
FROM city c
INNER JOIN country t
ON c.country_id=t.country_id
WHERE country='Canada'));

# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
USE Sakila;
SELECT title
FROM film
WHERE film_id IN (SELECT film_id
FROM film_category f
INNER JOIN category c
ON f.category_id=c.category_id
WHERE name='Family');

# 7e. Display the most frequently rented movies in descending order.
USE Sakila;
SELECT title, count(i.inventory_id)
FROM film_text f
LEFT JOIN inventory i
ON f.film_id=i.film_id
LEFT JOIN rental r
ON i.inventory_id=r.inventory_id
GROUP BY f.film_id
ORDER BY count(*) DESC;


# 7f. Write a query to display how much business, in dollars, each store brought in.
USE Sakila;
SELECT store_id, sum(amount) AS 'Total Sales'
FROM store s
INNER JOIN payment p
ON s.manager_staff_id=p.staff_id
GROUP BY store_id;


# 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country
FROM store s
INNER JOIN address a
ON s.address_id=a.address_id
INNER JOIN city c
ON a.city_id=c.city_id
INNER JOIN country t
ON c.country_id=t.country_id;

# 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
USE Sakila;
SELECT name, sum(amount) AS 'Gross Revenue'
FROM payment p
INNER JOIN rental r
ON p.rental_id=r.rental_id
inner join inventory i
ON i.inventory_id=r.inventory_id
inner join film_category f
on f.film_id=i.film_id
inner join category c
on f.category_id=c.category_id
GROUP by c.category_id
ORDER BY sum(amount) DESC
LIMIT 5;
  	
# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres_gross_revenue As SELECT name, sum(amount) AS 'Gross Revenue'
FROM payment p
INNER JOIN rental r
ON p.rental_id=r.rental_id
inner join inventory i
ON i.inventory_id=r.inventory_id
inner join film_category f
on f.film_id=i.film_id
inner join category c
on f.category_id=c.category_id
GROUP by c.category_id
ORDER BY sum(amount) DESC
LIMIT 5;


# 8b. How would you display the view that you created in 8a?
SHOW CREATE VIEW top_five_genres_gross_revenue;
SELECT * FROM top_five_genres_gross_revenue;

# 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_genres_gross_revenue;