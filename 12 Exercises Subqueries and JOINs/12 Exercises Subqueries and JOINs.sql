/*Изпоплзва се базата данни soft_uni */
/* 1.	Employee Address */
SELECT `e`.`employee_id`, `e`.`job_title`, `e`.`address_id`, `a`.`address_text`
FROM `employees` AS `e`
INNER JOIN `addresses` AS `a` 
ON `e`.`address_id` = `a`.`address_id`
ORDER BY `e`.`address_id`
LIMIT 5;


/* 2. Addresses with Towns */
SELECT `e`.`first_name`, `e`.`last_name`, `t`.`name`, `a`.`address_text`
FROM `employees` AS `e`
INNER JOIN `addresses` AS `a` ON `e`.`address_id` = `a`.`address_id`
INNER JOIN `towns` AS `t` ON `a`.`town_id` = `t`.`town_id`
ORDER BY `e`.`first_name`, `e`.`last_name`
LIMIT 5;


/* 3. Sales Employee */
SELECT `e`.`employee_id`, `e`.`first_name`, `e`.`last_name`, `d`.`name` AS `department_name`
FROM `employees` AS `e`
INNER JOIN `departments` AS `d` ON `e`.`department_id` = `d`.`department_id`
WHERE `d`.`name` = 'Sales'
ORDER BY `e`.`employee_id` DESC;

/* Друго решение на задача 3 без WHERE */
SELECT `e`.`employee_id`, `e`.`first_name`, `e`.`last_name`, `d`.`name` AS `department_name`
FROM `employees` AS `e`
INNER JOIN `departments` AS `d` ON `e`.`department_id` = `d`.`department_id` AND `d`.`name` = 'Sales'
ORDER BY `e`.`employee_id` DESC;


/* 4. Employee Departments */
SELECT  `e`.`employee_id`, `e`.`first_name`, `e`.`salary`, `d`.`name` AS `department_name`
FROM `employees` AS `e`
INNER JOIN `departments` AS `d` ON `e`.`department_id` = `d`.`department_id`
WHERE `e`.`salary` > 15000
ORDER BY `d`.`department_id` DESC
LIMIT 5;

/* Друго решение на задача */
SELECT  `e`.`employee_id`, `e`.`first_name`, `e`.`salary`, `d`.`name` AS `department_name`
FROM `employees` AS `e`
INNER JOIN `departments` AS `d` ON `e`.`department_id` = `d`.`department_id` AND `e`.`salary` > 15000
ORDER BY `d`.`department_id` DESC
LIMIT 5;


/* 5.Employees Without Project */
SELECT  `e`.`employee_id`, `e`.`first_name`
FROM `employees` AS `e`
LEFT JOIN `employees_projects` AS `ep` ON `e`.`employee_id` = `ep`.`employee_id`
WHERE `ep`.`project_id` IS NULL
ORDER BY `e`.`employee_id` DESC
LIMIT 3;
/* Задача 5 не се получава с AND един от тестовете в judge гърми */


/* 6. Employees Hired After */
SELECT `e`.`first_name`, `e`.`last_name`, `e`.`hire_date`, `d`.`name` AS `dept_name`
FROM `employees` AS `e`
INNER JOIN `departments` AS `d` ON `e`.`department_id` = `d`.`department_id`
WHERE DATE(`e`.`hire_date`) > '1999-01-01' AND `d`.`name` IN('Sales', 'Finance')
ORDER BY `e`.`hire_date`;

/* Решение на задача 6 без WHERE*/
SELECT `e`.`first_name`, `e`.`last_name`, `e`.`hire_date`, `d`.`name` AS `dept_name`
FROM `employees` AS `e`
INNER JOIN `departments` AS `d` ON `e`.`department_id` = `d`.`department_id`
AND DATE(`e`.`hire_date`) > '1999-01-01' AND `d`.`name` IN('Sales', 'Finance')
ORDER BY `e`.`hire_date`;


/* 7. Employees with Project */
SELECT  `e`.`employee_id`, `e`.`first_name`, `p`.`name` AS `project_name`
FROM `employees` AS `e`
INNER JOIN `employees_projects` AS `ep` ON `e`.`employee_id` = `ep`.`employee_id`
INNER JOIN `projects` AS `p` ON `p`.`project_id` = `ep`.`project_id`
WHERE DATE(`p`.`start_date`) > '2002-08-13' AND `p`.`end_date` IS NULL
ORDER BY `e`.`first_name`, `p`.`name`
LIMIT 5;


/* 8. Employee 24 */
SELECT  `e`.`employee_id`, `e`.`first_name`, IF(YEAR(`p`.`start_date`) >= '2005', NULL, `p`.`name`) AS `project_name`
FROM `employees` AS `e`
LEFT JOIN `employees_projects` AS `ep` ON `e`.`employee_id` = `ep`.`employee_id`
LEFT JOIN `projects` AS `p` ON `p`.`project_id` = `ep`.`project_id`
WHERE `e`.`employee_id` = 24
ORDER BY `project_name`;


/* 9. Employee Manager */
SELECT `e`.`employee_id`, `e`.`first_name`, `e`.`manager_id`, `m`.`first_name` AS `manager_name`
FROM `employees` AS `e`
INNER JOIN `employees` AS `m` ON `e`.`manager_id` = `m`.`employee_id`
WHERE `e`.`manager_id` IN(3, 7)
ORDER BY `e`.`first_name`;
/* Тази задача е пример за SELF JOIN*/


/* 10. Employee Summary */
SELECT `e`.`employee_id`, CONCAT(`e`.`first_name`, ' ', `e`.`last_name`) AS `employee_name`, CONCAT(`m`.`first_name`, ' ', `m`.`last_name`) AS `manager_name`, `d`.`name` AS `department_name`
FROM `employees` AS `e`
INNER JOIN `employees` AS `m` ON `e`.`manager_id` = `m`.`employee_id`
INNER JOIN `departments` AS `d` ON `e`.`department_id` = `d`.`department_id`
ORDER BY `e`.`employee_id`
LIMIT 5;


/* 11. Min Average Salary */
SELECT AVG(`salary`) AS `min_average_salary`
FROM `employees`
GROUP BY `department_id`
ORDER BY `min_average_salary`
LIMIT 1;


/* Използва се базата данни geography */
/* 12. Highest Peaks in Bulgaria */
SELECT `mc`.`country_code`, `m`.`mountain_range`, `p`.`peak_name`, `p`.`elevation`
FROM `mountains_countries` AS `mc`
INNER JOIN `mountains` AS `m` ON `mc`.`mountain_id` = `m`.`id`
INNER JOIN `peaks` AS `p` ON `p`.`mountain_id` = `m`.`id`
WHERE `mc`.`country_code` = 'BG' AND `p`.`elevation` > 2835
ORDER BY `p`.`elevation` DESC;


/* 13. Count Mountain Ranges */
SELECT `mc`.`country_code`, COUNT(`m`.`mountain_range`) AS `mountain_range`
FROM `mountains_countries` AS `mc`
INNER JOIN `mountains` AS `m` ON `mc`.`mountain_id` = `m`.`id`
WHERE `mc`.`country_code` IN('BG', 'US', 'RU')
GROUP BY `country_code`
ORDER BY `mountain_range` DESC;


/* 14. Countries with Rivers */
SELECT `c`.`country_name`, `r`.`river_name`
FROM `countries` AS `c`
LEFT JOIN `countries_rivers` AS `cr` ON `c`.`country_code` = `cr`.`country_code`
LEFT JOIN `rivers` AS `r` ON `cr`.`river_id` = `r`.`id`
WHERE `c`.`continent_code` = 'AF' 
ORDER BY `c`.`country_name`
LIMIT 5;


/* 15. *Continents and Currencies */
SELECT `c`.`continent_code`, `currency_code`, COUNT(*) AS 'currency_usage'
FROM `countries` AS `c`
GROUP BY `c`.`continent_code`, `c`.`currency_code`
HAVING `currency_usage` > 1
AND `currency_usage` = 
		(SELECT COUNT(*) AS 'count_of_currancies'
		FROM `countries` AS `c2`
		WHERE `c2`.`continent_code` = `c`.`continent_code`
		GROUP BY `c2`.`currency_code`
		ORDER BY `count_of_currancies` DESC
		LIMIT 1)
ORDER BY `c`.`continent_code`, `c`.`currency_code`;


/* 16. Countries Without Any Mountains */
SELECT COUNT(`c`.`country_code`) AS 'count_countries'
FROM `countries` AS `c`
LEFT JOIN `mountains_countries` AS `mc` ON `c`.`country_code` = `mc`.`country_code`
LEFT JOIN `mountains` AS `m` ON `mc`.`mountain_id` = `m`.`id`
WHERE `m`.`mountain_range` IS NULL
GROUP BY `m`.`mountain_range`;

/* Друго решение на задача 16 */
SELECT COUNT(`c`.`country_code`) AS 'count_countries'
FROM `countries` AS `c`
LEFT JOIN `mountains_countries` AS `mc` ON `c`.`country_code` = `mc`.`country_code`
LEFT JOIN `mountains` AS `m` ON `mc`.`mountain_id` = `m`.`id`
WHERE `m`.`id` IS NULL;

/* Още едно решение на задача 16 */
SELECT COUNT(*) AS 'count_countries'
FROM `countries` AS `c`
LEFT JOIN `mountains_countries` AS `mc` ON `c`.`country_code` = `mc`.`country_code`
LEFT JOIN `mountains` AS `m` ON `mc`.`mountain_id` = `m`.`id`
WHERE `m`.`id` IS NULL;


/* 17. Highest Peak and Longest River by Country */
 SELECT `c`.`country_name`, MAX(`p`.`elevation`) AS 'highest_peak_elevation', MAX(`r`.`length`) 'longest_river_length'
 FROM `countries` AS `c`
LEFT JOIN `mountains_countries` AS `mc` ON `c`.`country_code` = `mc`.`country_code`
LEFT JOIN `peaks` AS `p` ON `mc`.`mountain_id` = `p`.`mountain_id`
LEFT JOIN `countries_rivers` AS `cr` ON `c`.`country_code` = `cr`.`country_code`
LEFT JOIN `rivers` AS `r` ON `cr`.`river_id` = `r`.`id`
GROUP BY `c`.`country_name`
ORDER BY `highest_peak_elevation` DESC , `longest_river_length` DESC , c.`country_name`
LIMIT 5;


