POSTGRESQL = nil

# for Mac:
# brew update
# brew install postgres


# for Ubuntu:
# sudo apt update
# sudo apt install pstgresql postgresql-contrib

DBMS Database Management System
Container to store things in a structured what. What we interacct with when accessing a database.
Query > DBMS > OS > Database

example Transaction to update someone's email address ina DB: 
Check DB if person exists > finds that person's information > go and update that person's information

DBMS allow for 
- Reducing Data Redundancy
- Data Sharing
- Data Integrity (ensure data is accurate and consistent format etc)
- Data Security
- Backup and Recovery
- Privacy / Authorisation (Access)
- Backup and Recovery
- Data Consistency (check - make sure any change is one that's allowed)

Types:
- Relational
- Heirarchial
- Network
- Object Oriented
- NoSQL

SEQL:
Structured English Query Language (Lingua Franca of modern Database languages)
Developed by IBM Research in the 1970s.
Postgres, MySQL etc based on SEQL

Relational Databases:
All data is interrelated.

ORMs:
Treat data like an object : customers.all etc. 
Abstract the SQL queries away


ERD's (Entity Relationship Diagrams)
Visual way of describing objects and their interrelated relationships.

Built from 3 components:
1) Entities - the objects (students, employees etc, what the table is called)
2) Attributes - values that describe the entities (eg student id, name)
3) Relationships - how those are related

One to One (1:1)
One to Many (1:N)
Many to Many (N:M)

DB Designer
dbdesigner.net

primary key: unique identifier for that thing
Evertying should have at leas one primary key
unique: you can't have duplicates
By default does not allow nulls- specify that you do allow nulls if you want people to have option of filling in. 
Don't have to keep track of ids if you use primary keys (there won't be a field tot put in that information)

many to many requires a third relationship, something that has both of them
eg: for doctors and patients:
create (eg)
Appointments

=============================================================================================================

SQL: Structured Query Language
Lingua Franca of Databases

SQL SYNTAX (without abstraction)
------------------------------------

INSERT INTO table_name (Column1, Column2, Column3) # INSERT inserts one row at a time
VALUES (value1, value2, value3)

---------------------
Column1|Column2|Column3
---------------------
value1|value2|value3


DELETE FROM table_name # can delete multiple rows
WHERE value == 20

UPDATE table_nameSET value = 21
WHERE value = 'email@email.com'


SELECT column_1, column_2
FROM table_1, table_2
WHERE condition (variable = value)

SELECT Email, Age, Sex 
FROM students
# while selecct all Email, Age, Sex rows

SELECT * 
FROM studentsWhere Sex = 'F';

SELECT *
FROM students
WHERE CurrentCity = HomeTown OR
  HomeTown = 'Melbourne'


// Projects //
select a subset of columns based on condition

SELECT Email, Age
FROM students
WHERE HomeTown = 'Melbourne'

// Distinct // 
Tables may have duplicate rows!!

SELECT DISTINCT(Sex) instead of SELECT Sex


// Joining Tables //
Natural Inner Join - join two tables with a common key

SELECT Students.Email, Age, Major # Do SELECT this last - once joining ...
FROM Students, EmailMajor # From these two tables
WHERE Students.Email = EmailMajor.Email # Combine these two tables by this condition


Natural Inner Join with Aliases - join two tables with common key using aliases

SELET S.Email, S.Age. M.Major 
FROM Students AS S, EmailMajor as M #Students labelled S and EmailMajor labelled M
WHERE S.Email = M.Email


Outer Join - match everything that matches (the primary key), 
>> will compare columns with the same name only, else you have to specify two columns to compare
>> everything that doesnt match will be NULL 
>> will always finish with same number of rows as specified table 'left' / 'right' etc 

Natural Join - match in the same way, but will only return rows that match

SELECT Students.Email, Age, Major
FROM Students LEFT OUTER JOIN EmailMajor;

# Students is left (keep LEFT, - stays static), so add Email Major info for (in this case emails) students where keys match
# After joining, SELECT

// String Matching //

SELECT Email, Age, CurrentCity
FROM students
WHERE CurrentCity LIKE 'San%'

Like denotes Ctrl-F type of search. 
where the current city starts with 'San%' - % denotes anything after that (could be empty, could be aything)
% denotes start or end. %San would mean 'San' preceded by anything
Case sensitive

> WHERE LOWER(title) LIKE 'toy%' ...

... WHERE CurrentCity LIKI 'H_ _ _ _' > denotes word startin with H that is 5 letters long
=============================================================================================================
PART 3
=============================================================================================================

// Sorting //
Sort after selecting

SELECT Email, Sex, CurrentCity
FROM Student
WHERE Sex = 'M'
ORDER BY CurrentCity ASC; #ASC default, don't have to specify default / DESC


// Set Operations - UNION //
# A set is a combination of data that conatins no duplicates: [M, F, M, F] => [M, F]


SELECT HomeTown
FROM Student
UNION
SELECT CurrentCity
FROM Student;

# adds HomeTown and CurrentCity from STUDENT and removes duplicates, returning the remaining data (SET)
# UNION ALL - returns all including duplicates

// Set Operations - INTERSECTION //
# only show me the ones that are common

SELECT a
FROM b
INTERSECT
SELECT c
FROM b;

# selects all the ones that are common, so if a from b matches c from b, then will return the values store therein.
# will take the value from the first column, then try to find it against ALL rows in the second column to find a match

// Set Operations - EXCEPT //
Find all that are not x
# Looks at value from column a, and checks to see if a is in column b. Will only return values that are only in a
# Be careful with duplicates - one match removes the match item from column b, so a second match will not register

// Functions - count, min, max, avg, sum //

SELECT count(*)
From Student;
-- will count the rows in Student

SELECT Email, max(Age)
From Student;
# -- will return the maximum Age in Student (only return one value, or more than one if two equal max values)


// Group By //

Group by parameters, then Sort 
#useful when a single (student etc) is mentioned multiple times in a column and want to group together
#Whatever you're grouping by, have to make sure it's contained within your SELECT statement (what the final result will look like)

SELECT Email, count(*) AS NumClasses, avg(Grade) AS AvgGrade 
#count is combining Classes (math, science etc) into a single new column NumClasses
FROM Student
GROUP BY Email
ORDER BY NumClasses ASC;

// Select from an Array //
SELECT * FROM movies WHERE genres @> ARRAY['Action']; 
# select all from table movies where 'Action' is contained in genres Array
SELECT * FROM movies WHERE genres[1] LIKE 'Action';
SELECT * FROM movies WHERE 'Action' = ANY(genres);


// Select and compare from two tables using linked / matched IDs?? //
# Create a join table connection where we display the movie id (movies table), the movie title (movies table) and the movie rating (ratings table), make this join based on the movie_id (in the ratings table)

SELECT movies.id, movies.title, ratings.movie_rating
FROM movies
WHERE ratings.id = movies.id

=============================================================================================================
PART 4
=============================================================================================================
// Having - Conditions on GROUP BY //
# Add an extra condition after grouping

SELECT Email, Count(*) AS NumClasses, avg(Grade) AS AvgGrade
FROM Student
GROUP BY Email
HAVING count(*) > 2
ORDER BY NumClasses;

// Nested Queries - IN/NOT IN //

# Find Email and Class for Student(s) whose CurrentCity is Melbourne
SELECT Email, Class
FROM Student_Class
WHERE Email IN # Checks for email in all of the below ??
  (SELECT Email
  FROM Student 
  WHERE CurrentCity = 'Melbourne'
  );

# Alternatively, can write as:
SELECT S.Email, C.Class
FROM Student AS S, Student_Class AS C
WHERE S.Email = C.Email 
AND S.CurrentCity = 'Melbourne';


// Nested Queries - SOME/ALL //
# Find CurrentCity with at least one Student with a Grade that's higher than all the Grades of Student(s) with HomeTown Melbourne.

SELECT CurrentCity # will return the current city
FROM Student AS S, Student_Grade AS G 
WHERE S.Email = G.Email AND Grade > ALL # Finding a student by comparing Grade against ALL of ...
  (SELECT Grade 
  FROM Student AS S, Student_Grade AS G
  WHERE S.Email = G.Email AND S.HomeTown = 'Melbourne' # Students that have HomeTown Melbourne
  );
# above looks tricky because at each step needs to confirm S.Email = G.Email to make sure Grade / Hometown / CurrentCity are for the same student

// Nested Queries - Correlated //
# Find Email and Age of Student(s) that have no grades

SELECT Email, Age
FROM Student AS S
WHERE NOT EXIST #Select Students, display email and age where below doesn't exist in table (Student email ie has grades)
  (SELECT *
  FROM Student_Grade AS G # checking in Grades table
  WHERE G.Email = S.Email # same student (same student email DOES NOT EXIST)

  =============================================================================================================

# run psql
psql
# sql command to create database: 
CREATE DATABASE db_name;
# command to connect to database
\c movies;
# => you are now connected to database "moves" as user "USERNAME"
run \i ~/Desktop/setup_tables.sql;
# this creates tables with their attributes
run \i ~/Desktop/import_movies.sql;
# this inserts movie data into the movie table
run \i ~/Desktop/import_ratings.sql;
# this inserts rating data into the movie table
run \l 
# to see all databases on your localhost
run \d
# to see tables in the database you're connected to



// Postico //
create tables > copy and past .sql files into query field & execute selection
import CSV files and select battles > battles, and deaths > deaths, ORDER


GAME OF THRONES
ANSWERS:

1) 


2) 

3) 
300

SELECT max(death_year)
FROM deaths;

4) From the deaths table, group by allegiances. Find out the count of each allegiance. 
SELECT allegiances, count(allegiances) AS count 
FROM deaths 
GROUP BY allegiances;

5) Order your result from question 4 by allegiance alphabetically.
SELECT allegiances, count(allegiances) AS count 
FROM deaths 
GROUP BY allegiances
ORDER BY allegiances;

6) From the battles table, find the count of battles per region. (Hint, another group by is needed.)
count / region(location)
SELECT count(region) AS count, region
FROM battles
GROUP BY region;

SELECTregion, count(*) AS num
FROM battles
GROUP BY region
ORDER BY count DESC;

7) From your result in 6, order by count in descending order.
SELECT count(region) AS count, region
FROM battles
GROUP BY region
ORDER by count DESC;

8) Find the attacker_commander that appears most in the battles data.
Gregor Clegane

SELECT attacker_commander, count(attacker_commander) AS count #count(*)
FROM battles
GROUP BY attacker_commander
ORDER BY count DESC;


Nested Query Example:
--SELECT max(sub.num)
--FROM
--    (SELECT count(*) AS num, attacker_commander
--    FROM battles
--    GROUP BY attacker_commander
--    ORDER BY count(*) DESC) AS sub;

9) Find the attacker_commander that appears least in the battles data.
NULL

SELECT attacker_commander, count(attacker_commander) AS count
FROM battles
GROUP BY attacker_commander
ORDER BY count;


10) Find the average defender size in the battles data.
6428.1578947368421053

SELECT avg(defender_size) AS avg_defender_size
FROM battles;


11) Find the average attacker size in the battles data.
9942.5416666666666667

SELECT ROUND(avg(attacker_size), 2) AS avg_attacker_size
FROM battles;


12) From the battles table, group by attacker_1. Show the count of attacker_1 sub-groups.
SELECT attacker_1 AS attacker, count(*) AS count
FROM battles
GROUP BY attacker; 

13) Order the result from Question 12 by ascending order of count.
SELECT attacker_1, count(*) AS count
FROM battles
GROUP BY attacker_1
ORDER BY count; 

14) Using aliases, and your query from Question 13, rename count and attacker_1 in the SELECT line to num_attackers, and attacker. Additionally, only show counts greater than 3.
SELECT attacker_1 AS attacker, count(*) AS num_attackers
FROM battles
GROUP BY attacker_1
HAVING count(*) > 3
ORDER BY num_attackers;






