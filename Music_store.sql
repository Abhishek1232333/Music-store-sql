create database Music_store;
use Music_store;

-- 1. Genre and MediaType
CREATE TABLE Genre (
	genre_id INT PRIMARY KEY,
	name VARCHAR(120)
);
select * from Genre;

CREATE TABLE MediaType (
	media_type_id INT PRIMARY KEY,
	name VARCHAR(120)
);
select * from mediatype;

-- 2. Employee
CREATE TABLE Employee (
	employee_id INT PRIMARY KEY,
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

-- 3. Customer
CREATE TABLE Customer (
	customer_id INT PRIMARY KEY,
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
);
select * from customer;



-- 4. Artist
CREATE TABLE Artist (
	artist_id INT PRIMARY KEY,
	name VARCHAR(120)
);
select * from artist;

-- 5. Album
CREATE TABLE Album (
	album_id INT PRIMARY KEY,
	title VARCHAR(160),
	artist_id INT,
	FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
);
select * from album;

-- 6. Track
CREATE TABLE Track (
	track_id INT PRIMARY KEY,
	name VARCHAR(200),
	album_id INT,
	media_type_id INT,
	genre_id INT,
	composer VARCHAR(220),
	milliseconds INT,
	bytes INT,
	unit_price DECIMAL(10,2),
	FOREIGN KEY (album_id) REFERENCES Album(album_id),
	FOREIGN KEY (media_type_id) REFERENCES MediaType(media_type_id),
	FOREIGN KEY (genre_id) REFERENCES Genre(genre_id)
);
select * from track;

-- 7. Invoice
CREATE TABLE Invoice (
	invoice_id INT PRIMARY KEY,
	customer_id INT,
	invoice_date DATE,
	billing_address VARCHAR(255),
	billing_city VARCHAR(100),
	billing_state VARCHAR(100),
	billing_country VARCHAR(100),
	billing_postal_code VARCHAR(20),
	total DECIMAL(10,2),
	FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
select * from invoice;

-- 8. InvoiceLine
CREATE TABLE InvoiceLine (
	invoice_line_id INT PRIMARY KEY,
	invoice_id INT,
	track_id INT,
	unit_price DECIMAL(10,2),
	quantity INT,
	FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id),
	FOREIGN KEY (track_id) REFERENCES Track(track_id)
);
select * from invoiceline;

-- 9. Playlist
CREATE TABLE Playlist (
 	playlist_id INT PRIMARY KEY,
	name VARCHAR(255)
);
select * from playlist;

-- 10. PlaylistTrack
CREATE TABLE PlaylistTrack (
	playlist_id INT,
	track_id INT,
	PRIMARY KEY (playlist_id, track_id),
	FOREIGN KEY (playlist_id) REFERENCES Playlist(playlist_id),
	FOREIGN KEY (track_id) REFERENCES Track(track_id)
);
select * from PlaylistTrack;

--  Who is the senior most employee based on job title? 
select concat(first_name," ",last_name) as name,title,levels from employee
order by levels desc limit 1;

-- Which countries have the most Invoices?
select billing_country,count(invoice_id) as no_of_invoice from invoice
group by billing_country
order by no_of_invoice desc limit 5;

--  What are the top 3 values of total invoice?
with cte_1 as (select *,dense_rank() over(order by total desc) as rank1 from invoice)
select * from cte_1
where rank1<4;

-- Which city has the best customers? -
-- We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

select city,sum(total) as total from customer c inner join invoice i on c.customer_id=i.customer_id
group by city
order by total desc limit 5;

--  Who is the best customer? - 
-- The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money

select concat(first_name," ",last_name) as name,sum(total) as total from customer c inner join invoice i on c.customer_id=i.customer_id
group by name
order by total desc;

-- Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A
select * from genre;
select * from customer;

select distinct email, concat(first_name," ",last_name) as name,g.name as genre_type from customer c inner join invoice i on c.customer_id=i.customer_id
inner join invoiceline il on i.invoice_id=il.invoice_id
inner join track t on il.track_id=t.track_id
inner join genre g on t.genre_id=g.genre_id
where g.name="Rock"
order by email asc;

--  Let's invite the artists who have written the most rock music in our dataset.
-- Write a query that returns the Artist name and total track count of the top 10 rock bands 
select * from artist;
select * from genre;

select a.name, COUNT(t.track_id) as total_tracks from artist a inner join album al on a.artist_id=al.artist_id
inner join track t on al.album_id=t.album_id
inner join genre g on t.genre_id=g.genre_id
where g.name="Rock"
group by a.name
order by  COUNT(t.track_id) desc limit 10;


--  Return all the track names that have a song length longer than the average song length.
-- Return the Name and Milliseconds for each track. Order by the song length, with the longest songs listed first

select name,milliseconds from track
where milliseconds>(select avg(milliseconds) from track)
order by milliseconds desc;

-- Find how much amount is spent by each customer on artists?
--  Write a query to return customer name, artist name and total spent

select concat(c.first_name," ",c.last_name) as name,ar.name,sum(total) from customer c inner join invoice i on c.customer_id=i.customer_id
inner join invoiceline il on i.invoice_id=il.invoice_id
inner join track t on il.track_id=t.track_id
inner join album a on t.album_id=a.album_id
inner join artist ar on a.artist_id=ar.artist_id
group by name,ar.name;


-- We want to find out the most popular music Genre for each country. 
-- We determine the most popular genre as the genre with the highest amount of purchases.
-- Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared, return all Genres

WITH genre_counts AS (
    SELECT 
        i.billing_country AS country,
        g.name AS genre,
        COUNT(*) AS purchase_count
    FROM invoice i
    JOIN invoiceline il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    GROUP BY i.billing_country, g.name
),
ranked_genres AS (
    SELECT 
        country,
        genre,
        purchase_count,
        DENSE_RANK() OVER (PARTITION BY country ORDER BY purchase_count DESC) AS rank1
    FROM genre_counts
)
SELECT 
    country,
    genre,
    purchase_count
FROM ranked_genres
WHERE rank1 = 1
ORDER BY country, genre;


-- Write a query that determines the customer that has spent the most on music for each country.
 -- Write a query that returns the country along with the top customer and how much they spent.
 -- For countries where the top amount spent is shared, provide all customers who spent this amount
 
 with cte_2 as (select billing_country,concat(first_name," ",last_name) as name,sum(total) as amount from customer c inner join invoice i on c.customer_id=i.customer_id
 group by billing_country,concat(first_name," ",last_name)),
 ranked_based as (select billing_country,name,amount,dense_rank() over(partition by billing_country order by amount desc) as rank1 from cte_2)
 
 SELECT 
    billing_country,
    name,
    amount
FROM ranked_based
WHERE rank1 = 1
ORDER BY billing_country,name;


