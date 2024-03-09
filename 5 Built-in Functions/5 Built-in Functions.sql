/* 1. Find Book Titles */
SELECT `title` 
FROM `books`
WHERE SUBSTRING(`title`, 1, 4) = 'The '
ORDER BY `id`;

/* Друго и по-добро решение на задача 1*/
SELECT `title` 
FROM `books`
WHERE `title` LIKE 'The%';


/* 2. Replace Titles */
SELECT REPLACE(`title`, 'The', '***') 
FROM `books`
WHERE SUBSTRING(`title`, 1, 3) = 'The'
ORDER BY `id`;


/* 3. Sum Cost of All Books */
SELECT ROUND(SUM(`cost`), 2)
FROM `books`;


/* 4. Days Lived */
SELECT CONCAT(`first_name`, " ", `last_name`) AS "Full Name", TIMESTAMPDIFF(DAY, `born`, `died`) AS "Days Lived"
FROM `authors`;



/* 5. Harry Potter Books */
SELECT `title` FROM `books`
WHERE `title` REGEXP "Harry Potter"
ORDER BY `id`;

/* Друго решение на задача 5 */
SELECT `title` FROM `books`
WHERE `title` LIKE "Harry Potter%"
ORDER BY `id`;

/*
Write a SQL query to find books which titles start with "The" and replace the substring with 3 asterisks. 
Retrieve data about the updated titles. Order the result by id. Submit your query statements as Prepare DB & run queries. 

*/

