# 🎵 Music Store SQL Project

This project builds a relational database for a digital music store and performs analytical queries to gain business insights using SQL.

## 📂 Database Overview

- **Tables Created:** Genre, MediaType, Employee, Customer, Artist, Album, Track, Invoice, InvoiceLine, Playlist, PlaylistTrack
- **Relationships:** Foreign keys ensure data integrity across albums, artists, customers, invoices, and tracks.

## 📊 Key SQL Queries

- **Top Invoice Totals**  
  Get top 3 invoice totals by value.

- **Best Customer by Spending**  
  Find the customer who spent the most overall.

- **Top City by Revenue**  
  Identify the city generating the highest revenue.

- **Rock Music Listeners**  
  List customers who purchased Rock genre music.

- **Top Rock Artists**  
  Return artists with the most Rock tracks.

- **Longest Tracks**  
  List songs longer than the average duration.

- **Customer Spending by Artist**  
  See how much each customer spent per artist.

- **Most Popular Genre by Country**  
  Find the top-purchased genre in each country.

- **Top Customer per Country**  
  Identify the highest spender(s) in each country.

## 🛠️ Tech Used

- MySQL
- SQL Window Functions (`DENSE_RANK`, `JOIN`, `GROUP BY`, subqueries)
- ER Modeling

---

Feel free to clone the repo and explore the queries inside `queries.sql`.
