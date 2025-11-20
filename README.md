##  Music Store Management System (MySQL)

###  **Overview**

This project is a **Music Store Management System** designed using **SQL and MySQL**, built to manage and analyze data for a digital music platform.
It includes information about **customers, employees, artists, albums, tracks, invoices, and playlists** — with a goal to organize, connect, and draw insights from real-world business data.
The project was inspired by platforms like **Spotify**, and was presented in a **storytelling format** to make it understandable even for non-technical audiences.

---

###  **Tools & Skills Used**

* **MySQL / SQL** – for database design and query execution
* **ER Diagram** – to visualize entity relationships
* **Joins, Subqueries, CTEs, Window Functions** – for advanced data analysis
* **Data Modeling & Normalization** – to structure data efficiently
* **Data Storytelling** – to communicate insights in a simple, relatable way

---

###  **Key Insights & Analyses**

* Identified the **best customer** based on total spending.
* Found **top cities and countries** generating the highest revenue.
* Analyzed **popular genres and top artists** based on sales.
* Determined **senior-most employee**, **top invoices**, and **music trends** by country.
* Used **window functions (RANK)** to find top customers in each country, handling ties effectively.

---

###  **Database Design Highlights**

* Created **11 interconnected tables** covering all aspects of the music store — from artists and tracks to customers and invoices.
* Designed an **ER Diagram** showing relationships such as:

  * Artist → Album → Track
  * Customer → Invoice → InvoiceLine
  * Playlist ↔ PlaylistTrack ↔ Track
* All tables linked through **Primary and Foreign Keys**, ensuring referential integrity.

---

###  **Project Features**

| **Feature**                   | **Description**                                                              |
| ----------------------------- | ---------------------------------------------------------------------------- |
| **Relational Design**         | Built 11 normalized tables with proper keys and constraints                  |
| **Advanced Queries**          | Used Joins, CTEs, and Window Functions for insights                          |
| **Insights Extraction**       | Identified best customers, popular genres, and top-revenue regions           |
| **Data Consistency**          | Ensured data accuracy through foreign key relationships                      |
| **Storytelling Presentation** | Explained project using real-world example of Spotify for easy understanding |

---

###  **What I Learned**

* Structuring and normalizing complex relational databases.
* Writing analytical queries using SQL functions and joins.
* Visualizing and interpreting entity relationships using ER diagrams.
* Presenting technical data in a storytelling format for all audiences.
* Understanding the real-world role of SQL in business decision-making.



