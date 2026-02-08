🎬 IMDB SQL Data Analysis Project

📌 Project Overview

This project performs an in-depth exploratory and analytical study of the IMDB movies dataset using SQL (MySQL 8+).

The objective is to derive business-driven insights related to movies, genres, ratings, directors, actors, and production houses through structured queries and advanced 
SQL techniques.

The analysis mimics real-world analytics tasks typically handled by Data Analysts / Business Analysts in media and entertainment domains.

🗂️ Dataset Description

The project uses multiple relational tables from the IMDB dataset:

movie – movie metadata (title, year, duration, country, languages, revenue)

genre – movie-to-genre mapping

ratings – average rating, median rating, and total votes

names – actors, actresses, and directors

director_mapping – movie–director relationships

role_mapping – movie–actor/actress relationships

🛠️ Tools & Technologies

Database: MySQL 8+

Language: SQL

Concepts Used:

Joins (INNER, LEFT)

Subqueries & CTEs

Window Functions (RANK, ROW_NUMBER, LEAD)

Aggregations & Grouping

CASE statements

Weighted averages

Date functions

Data quality checks

🔍 Key Analyses Performed

1. Data Exploration & Quality Checks

Table row counts and schema understanding

Identification of missing values

Validation of rating ranges and vote distributions

2. Movie & Genre Insights

Year-wise and month-wise movie release trends

Genre-wise movie counts and rankings

Average movie duration by genre

Movies belonging to single vs multiple genres

3. Ratings Analysis

Min/max values for ratings and votes

Top 10 movies based on average ratings

Distribution of movies by median rating

Identification of hit and superhit movies

4. Production House Analysis

Production houses with the highest number of hit movies

Top production houses based on total votes

Performance of multilingual movies

5. People Analytics (Actors & Directors)

Top directors in top genres based on ratings

Top actors and actresses using weighted average ratings

Ranking of Indian actors with minimum movie constraints

Top actresses in Hindi movies released in India

Advanced director metrics:

Number of movies

Average inter-movie duration

Min/max ratings

Total votes and total movie duration

6. Advanced SQL Analytics

Running totals and moving averages by genre

Year-wise highest-grossing movies by top genres

Classification of thriller movies into:

Superhit

Hit

One-time-watch

Flop

📈 Sample Business Questions Answered

Which genres dominate movie production?

Which production houses consistently produce hit movies?

Do German movies receive more votes than Italian movies?

Who are the most reliable directors and actors based on ratings and votes?

What is the ideal movie duration by genre?

🧠 Key Learnings

Practical use of window functions for ranking and trend analysis

Importance of weighted averages in rating-based decisions

Handling many-to-many relationships using mapping tables

Translating business questions into optimized SQL queries

✅ Conclusion

This project demonstrates how SQL can be used as a powerful analytical tool to extract meaningful insights from a complex, multi-table relational dataset like IMDB. By systematically exploring movies, genres, ratings, people, and production houses, the analysis answers real-world business questions relevant to the media and entertainment industry.

Through this project, advanced SQL techniques such as window functions, CTEs, weighted averages, ranking logic, and time-based analysis were applied to evaluate movie performance, identify high-performing genres, rank actors and directors, and assess production house success. The results highlight how data-driven decision-making can guide strategic choices such as genre selection, talent hiring, and production partnerships.

Overall, this project reflects industry-aligned analytical thinking, strong command over SQL, and the ability to translate raw data into actionable insights—skills essential for a Data Analyst or Business Analyst role.
