USE `soft_uni`;

/* Part I – Queries for SoftUni Database */
/* 1. Find Names of All Employees by First Name */

SELECT `first_name`, `last_name` 
FROM `employees`
WHERE `first_name` LIKE 'Sa%'
ORDER BY `employee_id`;

/* Друго решение на задача 1*/
SELECT `first_name`, `last_name` 
FROM `employees`
WHERE LEFT(`first_name`, 2) = 'Sa'
ORDER BY `employee_id`;


/* 2. Find Names of All Employees by Last Name */
SELECT `first_name`, `last_name` 
FROM `employees`
WHERE `last_name` LIKE '%ei%'
ORDER BY `employee_id`;


/* 3. Find First Names of All Employees */
SELECT `first_name` from `employees`
WHERE `department_id` IN (3,10)
AND 
year(`hire_date`) BETWEEN 1995 and 2005
ORDER BY `employee_id`;

/* Друго решение на задача 3*/
SELECT `first_name`
FROM `employees`
WHERE `department_id` IN (3, 10) AND EXTRACT(YEAR FROM `hire_date`) BETWEEN 1995 AND 2005
ORDER BY `employee_id`;


/* 4. Find All Employees Except Engineers */
SELECT `first_name`, `last_name` 
FROM `employees`
WHERE `job_title` NOT LIKE '%engineer%'
ORDER BY `employee_id`;


/* 5. Find Towns with Name Length */
SELECT `name`
FROM `towns`
WHERE CHAR_LENGTH(`name`) IN (5, 6)
ORDER BY `name`;


/* 6. Find Towns Starting With */
SELECT `town_id`, `name`
FROM `towns`
WHERE `name` LIKE 'M%'
OR `name` LIKE 'K%'
OR `name` LIKE 'B%'
OR `name` LIKE 'E%'
ORDER BY `name`;

/* Друго решение на задача 6 */
SELECT `town_id`, `name`
FROM `towns`
WHERE `name` REGEXP '^[MKBE]'
ORDER BY `name`;


/* 7.Find Towns Not Starting With */
SELECT `town_id`, `name`
FROM `towns`
WHERE `name` NOT LIKE 'R%'
AND `name` NOT LIKE 'B%'
AND `name` NOT LIKE 'D%'
ORDER BY `name`;


/* 8. Create View Employees Hired After 2000 Year */
CREATE VIEW `v_employees_hired_after_2000` AS
SELECT `first_name`, `last_name` 
FROM `employees`
WHERE year(`hire_date`) > 2000;
SELECT * FROM `v_employees_hired_after_2000`;


/* 9. Length of Last Name */
SELECT `first_name`, `last_name` 
FROM `employees`
WHERE CHAR_LENGTH(`last_name`) = 5;


/* Part II – Queries for Geography Database */
/* 10.	Countries Holding 'A' 3 or More Times */
USE `geography`;
SELECT `country_name`, `iso_code`
FROM `countries`
WHERE `country_name` LIKE '%a%a%a%'
ORDER BY `iso_code`;


/* 11. Mix of Peak and River Names */
SELECT 
    `peak_name`,
    `river_name`,
    CONCAT(LOWER(`peak_name`),
            SUBSTRING(LOWER(`river_name`), 2)) AS 'mix'
FROM
    `peaks`,
    `rivers`
WHERE
    RIGHT(`peak_name`, 1) = LEFT(LOWER(`river_name`), 1)
ORDER BY `mix`;


/* Part III – Queries for Diablo Database */
/* 12.	Games from 2011 and 2012 Year */
USE `diablo`;
SELECT `name`, DATE_FORMAT(`start`, '%Y-%m-%d') AS 'start' FROM `games`
WHERE YEAR(`start`) IN (2011, 2012)
ORDER BY `start`, `name`
LIMIT 50;


/* 13. User Email Providers */
SELECT `user_name`, SUBSTRING(`email`, LOCATE("@", `email`) + 1) AS 'email provider'
FROM `users`
ORDER BY `email provider`, `user_name`;


/* 14. Get Users with IP Address Like Pattern */
SELECT `user_name`, `ip_address`
FROM `users`
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`;


/* 15. Show All Games with Duration and Part of the Day */
SELECT `name` AS 'game', 
CASE
WHEN HOUR(`start`) >= 0 AND HOUR(`start`) < 12 THEN 'Morning'
WHEN HOUR(`start`) >= 12 AND HOUR(`start`) < 18 THEN 'Afternoon'
ELSE 'Evening'
END
AS 'Part of the Day',
CASE
WHEN `duration` <= 3 THEN 'Extra Short'
WHEN `duration` <= 6 THEN 'Short'
WHEN `duration` <= 10 THEN 'Long'
ELSE 'Extra Long'
END
AS 'Duration'
FROM `games`;

/* Друго решение на задача 15*/
SELECT `name` as 'game',
CASE
WHEN hour(`start`) < 12 THEN 'Morning'
WHEN hour(`start`) < 18 THEN 'Afternoon'
ELSE 'Evening'
END 
AS 'Part of the Day',
CASE
WHEN `duration` <= 3 THEN 'Extra Short'
WHEN `duration` <= 6 THEN 'Short'
WHEN `duration` <= 10 THEN 'Long'
ELSE 'Extra Long'
END 
AS 'Duration'
FROM `games`;


/* Part IV – Date Functions Queries */
/* 16.	 Orders Table */ 
USE `orders`;
SELECT `product_name`, `order_date`,
ADDDATE(`order_date`, INTERVAL 3 DAY) AS 'pay_due', 
ADDDATE(`order_date`, INTERVAL 1 MONTH) AS 'deliver_due'
FROM `orders`;






