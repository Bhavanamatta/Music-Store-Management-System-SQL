-- 1. Create Database
CREATE DATABASE Musicstore;
USE Musicstore;

-- 2. Genre and MediaType
CREATE TABLE Genre (
	genre_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(120)
);

CREATE TABLE MediaType (
	media_type_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(120)
);

-- 3. Employee
CREATE TABLE Employee (
	employee_id INT AUTO_INCREMENT PRIMARY KEY,
	last_name VARCHAR(120),
	first_name VARCHAR(120),
	title VARCHAR(120),
	reports_to INT,
    levels VARCHAR(255),
	birthdate DATE,
	hire_date DATE,
	address VARCHAR(255),
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	postal_code VARCHAR(20),
	phone VARCHAR(50),
	fax VARCHAR(50),
	email VARCHAR(100)
);
select * from employee;
-- 4. Customer
CREATE TABLE Customer (
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(120),
	last_name VARCHAR(120),
	company VARCHAR(120),
	address VARCHAR(255),
	city VARCHAR(100),
	state VARCHAR(100),
	country VARCHAR(100),
	postal_code VARCHAR(20),
	phone VARCHAR(50),
	fax VARCHAR(50),
	email VARCHAR(100),
	support_rep_id INT,
	FOREIGN KEY (support_rep_id) REFERENCES Employee(employee_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- 5. Artist
CREATE TABLE Artist (
	artist_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(120)
);
-- 6. Album
CREATE TABLE Album (
	album_id INT AUTO_INCREMENT PRIMARY KEY,
	title VARCHAR(160),
	artist_id INT,
	FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 7. Track
CREATE TABLE Track (
	track_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(200),
	album_id INT,
	media_type_id INT,
	genre_id INT,
	composer VARCHAR(220),
	milliseconds INT,
	bytes INT,
	unit_price DECIMAL(10,2),
	FOREIGN KEY (album_id) REFERENCES Album(album_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (media_type_id) REFERENCES MediaType(media_type_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE  "D:/ProgramData/MySQL/MySQL Server 8.0/Uploads/track.csv"
INTO TABLE  track
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(track_id, name, album_id, media_type_id, genre_id, composer, milliseconds, bytes, unit_price);
-- 8. Invoice
CREATE TABLE Invoice (
	invoice_id INT AUTO_INCREMENT PRIMARY KEY,
	customer_id INT,
	invoice_date DATE,
	billing_address VARCHAR(255),
	billing_city VARCHAR(100),
	billing_state VARCHAR(100),
	billing_country VARCHAR(100),
	billing_postal_code VARCHAR(20),
	total DECIMAL(10,2),
	FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 9. InvoiceLine
CREATE TABLE InvoiceLine (
	invoice_line_id INT AUTO_INCREMENT PRIMARY KEY,
	invoice_id INT,
	track_id INT,
	unit_price DECIMAL(10,2),
	quantity INT,
	FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id),
	FOREIGN KEY (track_id) REFERENCES Track(track_id)
);
-- 10. Playlist
CREATE TABLE Playlist (
 	playlist_id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255)
);

-- 11. PlaylistTrack (junction table)
CREATE TABLE PlaylistTrack (
	playlist_id INT,
	track_id INT,
	PRIMARY KEY (playlist_id, track_id),
	FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id),
	FOREIGN KEY (track_id) REFERENCES Track(track_id)
);


-- 1.Who is the senior most employee based on job title? 
SELECT 
    first_name,
    last_name,
    title
FROM Employee
ORDER BY title ASC, hire_date ASC
LIMIT 1;

-- 2. Which countries have the most Invoices?

WITH CountryInvoiceCount AS (
    SELECT 
        billing_country,
        COUNT(invoice_id) AS total_invoices
    FROM Invoice
    GROUP BY billing_country
)
SELECT billing_country, total_invoices
FROM CountryInvoiceCount
WHERE total_invoices = (SELECT MAX(total_invoices) FROM CountryInvoiceCount);

-- 3 What are the top 3 values of total invoice?

SELECT 
    invoice_id,
    total
FROM Invoice
ORDER BY total DESC
LIMIT 3;

-- 4 Which city has the best customers? - We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals

SELECT 
    billing_city,
    SUM(total) AS total_invoice_amount
FROM Invoice
GROUP BY billing_city
ORDER BY total_invoice_amount DESC
LIMIT 1;


-- 5  Who is the best customer? - The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    SUM(i.total) AS total_spent
FROM Customer c
JOIN Invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY total_spent DESC
LIMIT 1;

-- USING WINDOWS FUNCTION
SELECT 
    customer_id,
    first_name,
    last_name,
    email,
    total_spent
FROM (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        SUM(i.total) AS total_spent,
        RANK() OVER (ORDER BY SUM(i.total) DESC) AS rank_num
    FROM Customer c
    JOIN Invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email
) ranked
WHERE rank_num = 1;


-- 6 Write a query to return the email, first name, last name, & Genre of all Rock Music listeners.
--  Return your list ordered alphabetically by email starting with A
SELECT c.email, c.first_name,c.last_name,
g.name as genre 
from customer c
join invoice i on c.customer_id = i.customer_id
join invoiceline il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join genre g on t.track_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email ASC;



-- 7. Let's invite the artists who have written the most rock music in our dataset.
--  Write a query that returns the Artist name and total track count of the top 10 rock bands 
SELECT 
    ar.name AS artist_name,
    COUNT(t.track_id) AS total_rock_tracks
FROM artist ar
JOIN album al ON ar.artist_id = al.artist_id
JOIN track t ON al.album_id = t.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.name
ORDER BY total_rock_tracks DESC
LIMIT 10;



-- 8 Return all the track names that have a song length longer than the average song length.
-- Return the Name and Milliseconds for each track. Order by the song length, with the longest songs listed first

SELECT 
    name,
    milliseconds as song_length
FROM Track
WHERE milliseconds > (
    SELECT AVG(milliseconds) 
    FROM Track
)
ORDER BY milliseconds DESC;


-- 9. Find how much amount is spent by each customer on artists? Write a query to return customer name, artist name and total spent 

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ar.name AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM Customer c
JOIN Invoice i ON c.customer_id = i.customer_id
JOIN InvoiceLine il ON i.invoice_id = il.invoice_id
JOIN Track t ON il.track_id = t.track_id
JOIN Album al ON t.album_id = al.album_id
JOIN Artist ar ON al.artist_id = ar.artist_id
GROUP BY customer_name, artist_name
ORDER BY total_spent DESC; 


-- 10. We want to find out the most popular music Genre for each country.
--  We determine the most popular genre as the genre with the highest amount of purchases. 
-- Write a query that returns each country along with the top Genre. 
-- For countries where the maximum number of purchases is shared, return all Genres




SELECT 
    country,
    GROUP_CONCAT(genre_name) AS top_genres,
    max_purchases
FROM (
    SELECT 
        c.country,
        g.name AS genre_name,
        COUNT(il.quantity) AS total_purchases,
        MAX(COUNT(il.quantity)) OVER (PARTITION BY c.country) AS max_purchases
    FROM Customer c
    JOIN Invoice i ON c.customer_id = i.customer_id
    JOIN InvoiceLine il ON i.invoice_id = il.invoice_id
    JOIN Track t ON il.track_id = t.track_id
    JOIN Genre g ON t.genre_id = g.genre_id
    GROUP BY c.country, g.genre_id
) sub
WHERE total_purchases = max_purchases
GROUP BY country, max_purchases;




-- 11. Write a query that determines the customer that has spent the most on music for each country.
 -- Write a query that returns the country along with the top customer and how much they spent.
 -- For countries where the top amount spent is shared, provide all customers who spent this amount

WITH CustomerTotal AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.country,
        SUM(il.unit_price * il.quantity) AS total_spent
    FROM
        customer c
        JOIN invoice i ON c.customer_id = i.customer_id
        JOIN invoiceline il ON i.invoice_id = il.invoice_id
    GROUP BY
        c.customer_id, c.first_name, c.last_name, c.country
),
MaxSpent AS (
    SELECT
        country,
        MAX(total_spent) AS max_spent
    FROM
        CustomerTotal
    GROUP BY
        country
)
SELECT
    ct.country,
    ct.customer_name,
    ct.total_spent
FROM
    CustomerTotal ct
    JOIN MaxSpent ms ON ct.country = ms.country AND ct.total_spent = ms.max_spent
ORDER BY
    ct.country;

