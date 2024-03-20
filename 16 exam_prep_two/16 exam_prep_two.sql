CREATE DATABASE `exam_prep_two`;
USE `exam_prep_two`;


/* 1 */
CREATE TABLE `cities`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE `buyers`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
	`phone` VARCHAR(20) NOT NULL UNIQUE,
    `email` VARCHAR(50) NOT NULL UNIQUE,
    `city_id` INT,
	CONSTRAINT `fk__city_id__buyers__id__cities`
    FOREIGN KEY (`city_id`)
    REFERENCES `cities`(`id`)
);

CREATE TABLE `agents`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
	`phone` VARCHAR(20) NOT NULL UNIQUE,
    `email` VARCHAR(50) NOT NULL UNIQUE,
    `city_id` INT,
	CONSTRAINT `fk__city_id__agents__id__cities`
    FOREIGN KEY (`city_id`)
    REFERENCES `cities`(`id`)
);

CREATE TABLE `property_types`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `type` VARCHAR(40) NOT NULL UNIQUE,
    `description` TEXT

);

CREATE TABLE `properties`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `address` VARCHAR(80) NOT NULL UNIQUE,
    `price` DECIMAL(19,2) NOT NULL,
    `area` DECIMAL(19,2),
    `property_type_id` INT,
    `city_id` INT,
    CONSTRAINT `fk__property_type_id__id__property_types`
    FOREIGN KEY (`property_type_id`)
    REFERENCES `property_types`(`id`),
	CONSTRAINT `fk__city_id__properties__id__cities`
    FOREIGN KEY (`city_id`)
    REFERENCES `cities`(`id`)
    
);

CREATE TABLE `property_transactions`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `property_id` INT NOT NULL,
    `buyer_id` INT NOT NULL,
    `transaction_date` DATE,
    `bank_name` VARCHAR(30),
    `iban` VARCHAR (40) UNIQUE,
    `is_successful` BOOLEAN,
    CONSTRAINT `fk__property_id__property_transactions__id__properties`
    FOREIGN KEY (`property_id`)
    REFERENCES `properties`(`id`),
    CONSTRAINT `fk__buyer_id__property_transactions__id__buyers`
    FOREIGN KEY (`buyer_id`)
    REFERENCES `buyers`(`id`)
);

CREATE TABLE `property_offers`(
    `property_id` INT NOT NULL,
    `agent_id` INT NOT NULL,
    `price` DECIMAL(19,2) NOT NULL,
    `offer_datetime` DATETIME,
	CONSTRAINT `fk__property_id__property_offers__id__properties`
    FOREIGN KEY (`property_id`)
    REFERENCES `properties`(`id`),
    CONSTRAINT `fk__agent_id__property_offers__id__agents`
	FOREIGN KEY (`agent_id`)
    REFERENCES `agents`(`id`)
);



/* 2 */
INSERT INTO `property_transactions` (`property_id`, `buyer_id`, `transaction_date`, `bank_name`, `iban`, `is_successful`)
SELECT DAY(`offer_datetime`) + `agent_id`,
		MONTH(`offer_datetime`) + `agent_id`,
        DATE(`offer_datetime`),
        CONCAT('Bank ', `agent_id`),
        CONCAT('BG', `price`, `agent_id`),
		TRUE
FROM `property_offers` 
WHERE `agent_id` <= 2;



/* 3 */
UPDATE `properties`
SET `price` = `price` - 50000
WHERE `price` >= 800000;



/* 4 */
DELETE FROM `property_transactions`
WHERE `is_successful` = FALSE;



/* 5 */
SELECT `id`, `first_name`, `last_name`, `phone`, `email`, `city_id`
FROM `agents`
ORDER BY `city_id` DESC, `phone` DESC;



/* 6 */
SELECT `property_id`, `agent_id`, `price`, `offer_datetime`
FROM `property_offers`
WHERE YEAR(`offer_datetime`) = 2021
ORDER BY `price`
LIMIT 10;



/* 7 */
SELECT SUBSTRING(`address`, 1, 6) AS `agent_name`, LENGTH(`address`) * 5430 AS `price`
FROM `properties` AS `p`
LEFT JOIN `property_offers` AS `po` ON `p`.`id` = `po`.`property_id`
WHERE `po`.`agent_id` IS NULL
ORDER BY `agent_name` DESC, `price` DESC;



/* 8 */
SELECT `bank_name`, COUNT(*) AS `count`
FROM `property_transactions`
GROUP BY `bank_name`
HAVING `count` >= 9
ORDER BY `count` DESC, `bank_name`;



/* 9 */
SELECT `address`, `area`,
	        CASE
        WHEN `area` <= 100 THEN 'small'
        WHEN `area` <= 200 THEN 'medium'
        WHEN `area` <= 500 THEN 'large'
        WHEN `area` > 500 THEN 'extra large'
        END AS 	`size`
FROM `properties`
ORDER BY `area`, `address` DESC;



/* 10 */
DELIMITER $$
CREATE FUNCTION `udf_offers_from_city_name` (`cityName` VARCHAR(50)) 
RETURNS INT
DETERMINISTIC
BEGIN
		DECLARE `result` INT;
        SET `result` := (
			SELECT COUNT(*) FROM `property_offers` AS `po`
            JOIN `properties` AS `p` ON `po`.`property_id` = `p`.`id`
            JOIN `cities` AS `c` ON `p`.`city_id` = `c`.`id`
            WHERE `c`.`name` = 	`cityName`
        );
        
        RETURN `result`;
END $$
DELIMITER ;
;



/* 11 */
DELIMITER $$
CREATE PROCEDURE `udp_special_offer`(`first_name` VARCHAR(50))
BEGIN
	UPDATE `property_offers` AS `po`
    JOIN `agents` AS `a` ON `po`.`agent_id` = `a`.`id`
	SET `po`.`price` = `po`.`price` * 0.90
    WHERE `a`.`first_name` = `first_name`;
END $$
DELIMITER ;
;
      
            
            