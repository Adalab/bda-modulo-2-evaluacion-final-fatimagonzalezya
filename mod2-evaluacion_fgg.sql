# Evaluación MOD 2 - Fátima González

USE
sakila;

# Ejercicio 1

SELECT
DISTINCT title
FROM
film;

# Ejercicio 2

SELECT
title,
rating
FROM
film
WHERE rating = "PG-13";

# Ejercicio 3

SELECT
title,
description
FROM
film
WHERE description REGEXP "amazing";

# Ejercicio 4

SELECT
title
FROM
film
WHERE length > 120;

# Ejercicio 5

SELECT
first_name
FROM actor;

# Ejercicio 6

SELECT
first_name,
last_name
FROM actor
WHERE last_name = "Gibson";

# Ejercicio 7

SELECT
first_name,
actor_id
FROM actor
WHERE actor_id BETWEEN "10" and "20";

# Ejercicio 8

SELECT
title,
rating
FROM film
WHERE rating NOT IN ("R", "PG");

# Ejercicio 9

SELECT
rating,
COUNT(DISTINCT film_id) AS TotalFilms
FROM film
GROUP BY rating;

# Ejercicio 10

SELECT
rental_id,
customer_id
FROM rental;

SELECT
customer_id,
first_name,
last_name
FROM customer;

SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
    COUNT(r.rental_id) AS Total_Rents
FROM 
	customer AS c
LEFT JOIN 
	rental AS r
ON 
    c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name
ORDER BY 
    Total_Rents DESC;
    
# Hacemos LEFT JOIN para que nos muestre todo, aunque algún cliente no tenga registro.
# Aunque hemos comprobado con INNER que el resultado es igual, por lo que no hay registros vacíos.


# Ejercicio 11
# Operación similar a la anterior pero ahora relacionamos 4 tablas a partir de 2 columnas que comparten valores (inventory_id y category_id).

SELECT
*
FROM rental;

SELECT
*
FROM inventory;

SELECT
*
FROM film_category;

SELECT
*
FROM category;

SELECT
    c.name AS category_name,
    COUNT(r.rental_id) AS Total_Rents
FROM
    rental r
INNER JOIN
    inventory i 
    ON r.inventory_id = i.inventory_id
INNER JOIN
    film_category fc 
    ON i.film_id = fc.film_id
INNER JOIN
    category c 
    ON fc.category_id = c.category_id
GROUP BY
    c.name
ORDER BY
    Total_Rents DESC;

# Usamos INNER en lugar de LEFT porque hemos comprobado que todos los alquileres tienen un inventario asignado 
# y todas las peliculas una categoria.

# Ejercicio 12

SELECT
	AVG(length) AS AvLength,
	rating
FROM
	film
GROUP BY
	rating
ORDER BY
	AvLength;

# Ejercicio 13

SELECT
    a.first_name,
    a.last_name
FROM
    actor a
LEFT JOIN
    film_actor fa
    ON a.actor_id = fa.actor_id
LEFT JOIN
    film f
    ON fa.film_id = f.film_id
WHERE
    f.title = 'Indian Love';
    
# Usamos LEFT porque sabemos que los datos están relacionados (a traves de actor_id y film_id). 
# Si algún actor no tuviera película no cumpliría la condición del WHERE, por tanto no hace falta usar INNER.


# Ejercicio 14

SELECT
title,
description
FROM
film
WHERE 
description LIKE '%dog%' OR '%cat%';

# Ejercicio 15

SELECT
title,
release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

# Ejercicio 16

SELECT	
title,
film_id
FROM 
film;

SELECT
film_id,
category_id
FROM film_category;

SELECT
category_id,
name
FROM category;

SELECT
	f.title,
	c.name
FROM film f
LEFT JOIN 
	film_category fc
	ON fc.film_id = f.film_id
LEFT JOIN category c
	ON c.category_id = fc.category_id
WHERE 
	c.name = "Family";

# Ejercicio 17

SELECT
	title,
	rating,
	length
FROM
	film
WHERE rating = "R" and length > 120;


# BONUS

# Ejercicio 18

# Hago INNER porque doy por hecho que todas las películas tienen actores, y no va haber registro vacío (que no saldría en caso de LEFT)

SELECT 
    a.first_name, 
    a.last_name,
    COUNT(fa.film_id) AS Total_Films
FROM 
    actor a
INNER JOIN 
    film_actor fa 
	ON a.actor_id = fa.actor_id
GROUP BY 
    a.actor_id, 
    a.first_name, 
    a.last_name
HAVING 
    COUNT(fa.film_id) > 10
ORDER BY 
    Total_Films ASC;

# Ejercicio 19
# Aquí se nos pide específicamente ver si hay algún actor que no salga en alguna pelicula, entonces usamos LEFT. Y no hay. 

SELECT 
    a.first_name, 
    a.last_name
FROM 
    actor a
LEFT JOIN 
    film_actor fa ON a.actor_id = fa.actor_id
WHERE 
    fa.film_id IS NULL;

# Ejercicio 20
# Si queremos que salgan categorías sin peliculas asociadas podríamos usar LEFT (pero hemos comporbado que no hay).

SELECT 
    c.name AS Cat_Name,
    AVG(f.length) AS Av_Length
FROM 
    category c
INNER JOIN 
    film_category fc ON c.category_id = fc.category_id
INNER JOIN 
    film f ON fc.film_id = f.film_id
GROUP BY 
    c.name
HAVING 
    AVG(f.length) > 120;
    

# Ejercicio 21
# Usamos INNER porque queremos incluir actores con peliculas (al menos 5).

SELECT 
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS Total_Films
FROM 
    actor a
INNER JOIN 
    film_actor fa ON a.actor_id = fa.actor_id
GROUP BY 
    a.actor_id, a.first_name, a.last_name
HAVING 
    COUNT(fa.film_id) >= 5
ORDER BY 
    Total_Films ASC;


# Ejercicio 22

SELECT 
	i.inventory_id,
	f.title,
    DATEDIFF(r.return_date, r.rental_date) AS Total_Rental
FROM 
    film f
LEFT JOIN 
    inventory i ON f.film_id = i.film_id
LEFT JOIN 
    rental r ON i.inventory_id = r.inventory_id
WHERE 
    r.rental_id IN (
        SELECT 
            rental_id
        FROM 
            rental
        WHERE 
            DATEDIFF(return_date, rental_date) > 5
    )
ORDER BY 
	Total_Rental ASC,
	f.title,
    i.inventory_id;


# Ejercicio 23

SELECT 
    a.first_name, 
    a.last_name
FROM 
    actor a
WHERE 
    a.actor_id NOT IN (
        SELECT 
            fa.actor_id
        FROM 
            film_actor fa
        INNER JOIN 
            film_category fc ON fa.film_id = fc.film_id
        INNER JOIN 
            category c ON fc.category_id = c.category_id
        WHERE 
            c.name = 'Horror'
    )
ORDER BY 
    a.last_name, 
    a.first_name;


# Ejercicio 24	

SELECT 
    f.title,
	c.name,
    f.length
FROM 
    film f
INNER JOIN 
    film_category fc ON f.film_id = fc.film_id
INNER JOIN 
    category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Comedy' AND f.length > 180;

# Ejercicio 25

# No se bien cómo tengo que hacerlo...

SELECT 
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS Films_Together
FROM 
    film_actor fa
JOIN 
    film_actor fa ON fa.film_id = f.film_id
HAVING 
    COUNT(fa.film_id) > 0
ORDER BY 
    Films_Together DESC;




