/* 1. Managers */
SELECT 
	`employee_id`,
    CONCAT(first_name, ' ', last_name) AS 'full_name',
    d.department_id,
    `name` AS `department_name`
FROM `departments` AS d
JOIN `employees` AS e ON d.manager_id = e.employee_id
ORDER BY `employee_id` 
LIMIT 5;

/* Друго решение на задача 1*/
SELECT e.employee_id, CONCAT(first_name, ' ',
last_name) AS 'full_name', d.department_id,
d.name
FROM employees AS e
RIGHT JOIN departments AS d
ON d.manager_id = e.employee_id
ORDER BY e.employee_id LIMIT 5;



/* 2. Towns Addresses */
SELECT 
	a.town_id,
    t.name,
    a.address_text
FROM `addresses` AS a
	JOIN `towns` AS t ON a.town_id = t.town_id
WHERE t.name IN('San Francisco', 'Sofia', 'Carnation')
ORDER BY a.town_id, a.address_id;

/* Друго решение на задача 2 */
SELECT 
	a.town_id,
    t.name,
    a.address_text
FROM `addresses` AS a
	JOIN `towns` AS t ON a.town_id = t.town_id
		AND t.name IN('San Francisco', 'Sofia', 'Carnation')
ORDER BY a.town_id, a.address_id;



/* 3. Employees Without Managers */
SELECT 
	`employee_id`,
    `first_name`,
    `last_name`,
    `department_id`,
    `salary`
FROM `employees`
WHERE `manager_id` IS NULL;
    


/* 4. Higher Salary */
SELECT COUNT(*)
FROM `employees`
WHERE `salary` > (
	SELECT AVG(`salary`) FROM `employees`
);



/* Допълнително join на повече от две таблици */
SELECT 
	e.employee_id,
	e.first_name,
    e.last_name,
    p.name
FROM employees AS e
	JOIN employees_projects AS ep ON e.employee_id = ep.employee_id
	JOIN projects AS p ON ep.project_id = p.project_id
ORDER BY e.employee_id;



/* Допълнително join в една и съща таблица*/
SELECT 
	e.employee_id,
    e.first_name,
    e.last_name,
	m.employee_id,
    m.first_name,
    m.last_name
FROM employees AS e  
	JOIN employees AS m ON e.manager_id = m.employee_id;


