CREATE DATABASE `practis_four`;
USE `practis_four`;


/* 1 */
CREATE TABLE `countries`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(30) NOT NULL UNIQUE,
    `description` TEXT,
    `currency` VARCHAR(5) NOT NULL
);

CREATE TABLE `airplanes`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`model` VARCHAR(50) NOT NULL UNIQUE,
	`passengers_capacity` INT NOT NULL,
    `tank_capacity` DECIMAL(19,2) NOT NULL,
    `cost` DECIMAL(19,2) NOT NULL
);

CREATE TABLE `passengers`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(30),
    `last_name` VARCHAR(30),
    `country_id` INT NOT NULL,
    CONSTRAINT `fk__country_id__passengers__id__countries`
    FOREIGN KEY (`country_id`)
    REFERENCES `countries`(`id`)   
);

CREATE TABLE `flights`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`flight_code` VARCHAR(30) NOT NULL UNIQUE,
	`departure_country` INT NOT NULL,
	`destination_country` INT NOT NULL,
    `airplane_id` INT NOT NULL,
    `has_delay` BOOLEAN,
    `departure` DATETIME,
    CONSTRAINT `fk__departure_country__flights__id__countries`
    FOREIGN KEY (`departure_country`)
    REFERENCES `countries`(`id`),
    CONSTRAINT `fk__destination_country__flights__id__countries`
    FOREIGN KEY (`destination_country`)
    REFERENCES `countries`(`id`),
    CONSTRAINT `fk__airplane_id__flights__id__airplanes`
    FOREIGN KEY (`airplane_id`)
    REFERENCES `airplanes`(`id`)  
);

CREATE TABLE `flights_passengers` (
	`flight_id` INT,
    `passenger_id` INT,
    CONSTRAINT `fk__flight_id__flights_passengers__id__flights`
	FOREIGN KEY (`flight_id`)
    REFERENCES `flights`(`id`),
    CONSTRAINT `fk__passenger_id__flights_passengers__id__passengers`
	FOREIGN KEY (`passenger_id`)
    REFERENCES `passengers`(`id`)
);



/* 2 */
INSERT INTO `airplanes` (`model`, `passengers_capacity`, `tank_capacity`, `cost`)
SELECT CONCAT(REVERSE(`first_name`), '797'),
		CHAR_LENGTH(`last_name`) * 17,
        `p`.`id` * 790,
        CHAR_LENGTH(`first_name`) * 50.6
FROM `passengers` AS `p`
WHERE `id` <= 5;



/* 3 */
UPDATE `flights` AS `f`
JOIN `countries` AS `c` ON `f`.`departure_country` = `c`.`id`
SET `airplane_id` = `airplane_id` + 1
WHERE `c`.`name` = 'Armenia';



/* 4 */
DELETE `f` FROM `flights` AS `f`
LEFT JOIN `flights_passengers` AS `fp` ON `f`.`id` = `fp`.`flight_id`
WHERE `fp`.`flight_id` IS NULL;



/* 5 */
SELECT `id`, `model`, `passengers_capacity`, `tank_capacity`, `cost`
FROM `airplanes`
ORDER BY `cost` DESC, `id` DESC;



/* 6 */
SELECT `flight_code`, `departure_country`, `airplane_id`, `departure`
FROM `flights`
WHERE YEAR(`departure`) = 2022
ORDER BY `airplane_id`, `flight_code`
LIMIT 20;



/* 7 */
SELECT  CONCAT(UPPER(SUBSTRING(`p`.`last_name`, 1, 2)), `p`.`country_id`) AS `flight_code`,
	CONCAT(`p`.`first_name`, ' ', `p`.`last_name`) AS `full_name`,
    `p`.`country_id`
FROM `passengers` AS `p`
LEFT JOIN `flights_passengers` AS `fp` ON `p`.`id` = `fp`.`passenger_id`
LEFT JOIN `flights` AS `f` ON `fp`.`flight_id` = `f`.`id`
WHERE `fp`.`flight_id` IS NULL
ORDER BY `p`.`country_id`;
 


/* 8 */
SELECT `name`, `currency`, COUNT(*) AS `booked_tickets` FROM `countries` `c`
JOIN `flights` AS `f` ON `f`.`destination_country` = `c`.`id`
JOIN `flights_passengers` AS `fp` ON `f`.`id` = `fp`.`flight_id`
GROUP BY `c`.`name`
HAVING `booked_tickets` >= 20
ORDER BY `booked_tickets` DESC;



/* 9 */
SELECT `flight_code`, `departure`,
	        CASE
        WHEN HOUR(`departure`) >= 5 AND HOUR(`departure`) < 12 THEN 'Morning'
        WHEN HOUR(`departure`) >= 12 AND HOUR(`departure`) < 17 THEN 'Afternoon'
        WHEN HOUR(`departure`) >= 17 AND HOUR(`departure`) < 21 THEN 'Evening'
        WHEN (HOUR(`departure`) >= 21 AND HOUR(`departure`) <= 23) 
        OR ((HOUR(`departure`) >= 0 AND HOUR(`departure`) < 5)) THEN 'Night'
       END AS `day_part`
FROM `flights`
ORDER BY `flight_code` DESC;



/* 10 */
DELIMITER $$ 
CREATE FUNCTION `udf_count_flights_from_country`(`country` VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
		DECLARE `result` INT;
		SET `result` := (
			SELECT COUNT(*) FROM `flights` AS `f`
            JOIN `countries` AS `c` ON `f`.`departure_country` = `c`.`id`
            WHERE `c`.`name` = `country`
		);
RETURN `result`;
END $$
DELIMITER ;
;



/* 11 */
DELIMITER $$
CREATE PROCEDURE `udp_delay_flight` (`code` VARCHAR(50))
BEGIN
	 UPDATE `flights` 
     
	 SET `has_delay` = TRUE,
     `departure` = DATE_ADD(`departure`, INTERVAL 30 MINUTE)
     WHERE `flight_code` = `code`;
   
END $$
DELIMITER ;
;



