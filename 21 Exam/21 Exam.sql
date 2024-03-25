CREATE DATABASE `exam_db`;
USE `exam_db`;


/* 1 */
CREATE TABLE `positions`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `description` TEXT,
    `is_dangerous` BOOLEAN NOT NULL

);

CREATE TABLE `continents` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE `countries`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `country_code` VARCHAR(10) NOT NULL UNIQUE,
    `continent_id` INT NOT NULL,
    CONSTRAINT `fk__continent_id__countries__id__continents`
    FOREIGN KEY (`continent_id`)
    REFERENCES `continents`(`id`)
);

CREATE TABLE `preserves`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL UNIQUE,
    `latitude` DECIMAL(9,6),
    `longitude` DECIMAL(9,6),
    `area` INT,
    `type` VARCHAR(20),
    `established_on` DATE
    
);

CREATE TABLE `workers` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
    `age` INT,
	`personal_number` VARCHAR(20) NOT NULL UNIQUE,
    `salary` DECIMAL(19,2),
    `is_armed` BOOLEAN NOT NULL,
    `start_date` DATE,
    `preserve_id` INT,
    `position_id` INT NOT NULL,
    CONSTRAINT `fk__preserve_id__workers__id__preserves`
    FOREIGN KEY (`preserve_id`)
    REFERENCES `preserves`(`id`),
    CONSTRAINT `fk__position_id__workers__id__positions`
    FOREIGN KEY (`position_id`)
    REFERENCES `positions`(`id`)
    
);

CREATE TABLE `countries_preserves` (
    `country_id` INT NOT NULL,
    `preserve_id` INT NOT NULL,
    CONSTRAINT `fk__country_id__countries_preserves__id__countries`
    FOREIGN KEY (`country_id`)
    REFERENCES `countries`(`id`),
    CONSTRAINT `fk__preserve_id__countries_preserves__id__preserves`
	FOREIGN KEY (`preserve_id`)
    REFERENCES `preserves`(`id`)
);



/* 2 */
INSERT INTO `preserves`(`name`, `latitude`, `longitude`, 
						`area`, `type`, `established_on`)

SELECT CONCAT(`name`, ' is in South Hemisphere'),
		`latitude`,
		`longitude`,
        `area` * `id`,
		LOWER(`type`),
        `established_on`
FROM  `preserves`
WHERE `latitude` <= 0;



/* 3 */
UPDATE `workers`
SET `salary` = `salary` + 500
WHERE `position_id` IN(5, 8, 11, 13);



/* 4 */
DELETE FROM `preserves`
WHERE `established_on` IS NULL;



/* 5 */
SELECT CONCAT(`first_name`, ' ', `last_name`) AS 'Full Name',
TIMESTAMPDIFF(DAY, `start_date`, '2024-01-01') AS 'days_of_experience'
FROM `workers`
WHERE 2024 - YEAR(`start_date`) > 5
ORDER BY `days_of_experience` DESC
LIMIT 10;



/* 6 */
SELECT `w`.`id`, `w`.`first_name`, `w`.`last_name`, `p`.`name`, `c`.`country_code`
FROM `workers` AS `w`
JOIN `preserves` AS `p` ON `w`.`preserve_id` = `p`.`id`
JOIN `countries_preserves` AS `cp` ON `cp`.`preserve_id` = `p`.`id`
JOIN `countries` AS `c` ON  `cp`.`country_id` = `c`.`id`
WHERE `w`.`salary` > 5000 AND `w`.`age` < 50
ORDER BY `c`.`country_code`;



/* 7 */
SELECT `p`.`name`, COUNT(*) AS `armed_workers`
FROM `workers` AS `w`
JOIN `preserves` AS `p` ON `w`.`preserve_id` = `p`.`id`
WHERE `w`.`is_armed` = TRUE
GROUP BY `p`.`name`
ORDER BY `armed_workers` DESC, `p`.`name`;



/* 8 */
SELECT `p`.`name`, `c`.`country_code`, YEAR(`p`.`established_on`) AS `founded_in`
FROM `preserves` AS `p`
JOIN `countries_preserves` AS `cp` ON `cp`.`preserve_id` = `p`.`id`
JOIN `countries` AS `c` ON  `cp`.`country_id` = `c`.`id`
WHERE MONTH(`established_on`) = 5
ORDER BY `established_on`
LIMIT 5;



/* 9 */
SELECT `id`, 
		`name`,
              CASE
        WHEN `area` <= 100 THEN 'very small'
        WHEN `area` <= 1000 THEN 'small'
        WHEN `area` <= 10000 THEN 'medium'
        WHEN `area` <= 50000 THEN 'large'
        WHEN `area` > 50000 THEN 'very large'
        END AS 	`price_rank`
FROM `preserves` AS `category`
ORDER BY `area` DESC;



/* 10 */
DELIMITER $$
CREATE FUNCTION `udf_average_salary_by_position_name`(`name` VARCHAR(60))
RETURNS DECIMAL(19, 2)
DETERMINISTIC
BEGIN
	DECLARE `result` DECIMAL(19, 2);
    
	SET `result` := (SELECT AVG(`w`.`salary`) FROM `workers` AS `w`
						JOIN `positions` AS `p` ON `p`.`id` = `w`.`position_id`
						WHERE `p`.`name` = `name`
                        GROUP BY `p`.`id`);
    	RETURN `result`;
    
END $$
DELIMITER ;
;



/* 11 */
DELIMITER $$
CREATE PROCEDURE `udp_increase_salaries_by_country`(`country_name` VARCHAR(40))
BEGIN
	UPDATE `workers` AS `w`
	JOIN `preserves` AS `p` ON `w`.`preserve_id` = `p`.`id`
	JOIN `countries_preserves` AS `cp` ON `cp`.`preserve_id` = `p`.`id`
	JOIN `countries` AS `c` ON  `cp`.`country_id` = `c`.`id`
	SET `salary` = `salary` * 1.05
    WHERE `c`.`name` = `country_name`;
END $$
DELIMITER ;
;




















