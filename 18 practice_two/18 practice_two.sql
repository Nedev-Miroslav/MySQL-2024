CREATE DATABASE `practis_two`;
USE `practis_two`;


/* 1 */
CREATE TABLE `waiters`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `email` VARCHAR(50) NOT NULL,
    `phone` VARCHAR(50),
    `salary` DECIMAL(10,2)
);

CREATE TABLE `tables`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `floor` INT NOT NULL,
    `reserved` BOOLEAN,
    `capacity` INT NOT NULL
);

CREATE TABLE `orders`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`table_id` INT NOT NULL,
    `waiter_id` INT NOT NULL,
    `order_time` TIME NOT NULL,
    `payed_status` BOOLEAN,
    CONSTRAINT `fk__table_id__orders__id__tables`
    FOREIGN KEY (`table_id`)
    REFERENCES `tables`(`id`),
    CONSTRAINT `fk__waiter_id__orders__id__waiters`
    FOREIGN KEY (`waiter_id`)
    REFERENCES `waiters`(`id`)
);

CREATE TABLE `products` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(30) NOT NULL UNIQUE,
    `type` VARCHAR(30) NOT NULL,
    `price` DECIMAL (10,2) NOT NULL
);

CREATE TABLE `clients`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
	`birthdate` DATE NOT NULL,
    `card` VARCHAR(50),
    `review` TEXT
);

CREATE TABLE `orders_products` (
	`order_id` INT,
    `product_id` INT,
    CONSTRAINT `fk__order_id__orders_products__id__orders`
	FOREIGN KEY (`order_id`)
    REFERENCES `orders`(`id`),
    CONSTRAINT `fk__product_id__orders_products__id__products`
    FOREIGN KEY (`product_id`)
    REFERENCES `products`(`id`)
);

CREATE TABLE `orders_clients` (
	`order_id` INT,
    `client_id` INT,
	CONSTRAINT `fk__order_id__orders_clients__id__orders`
	FOREIGN KEY (`order_id`)
    REFERENCES `orders`(`id`),
	CONSTRAINT `fk__client_id__orders_clients__id__clients`
    FOREIGN KEY (`client_id`)
    REFERENCES `clients`(`id`)
);



/* 2 */
INSERT INTO `products` (`name`, `type`, `price`)
SELECT CONCAT(`last_name`, ' ','specialty'), 
		'Cocktail',
        CEILING(`salary` * 0.01)
FROM `waiters`
WHERE `id` > 6;



/* 3 */
UPDATE `orders`
SET `table_id` = `table_id` - 1
WHERE `id` BETWEEN 12 AND 23;



/* 4 */
DELETE `w` FROM `waiters` AS `w`
LEFT JOIN `orders` AS `o` ON `o`.`waiter_id` = `w`.`id`
WHERE `o`.`waiter_id` IS NULL;



/* 5 */
SELECT `id`, `first_name`, `last_name`, `birthdate`, `card`, `review`
FROM `clients`
ORDER BY `birthdate` DESC, `id` DESC;



/* 6 */
SELECT `first_name`, `last_name`, `birthdate`, `review`
FROM `clients`
WHERE `card` IS NULL AND YEAR(`birthdate`) BETWEEN 1978 AND 1993
ORDER BY `last_name` DESC, `id`
LIMIT 5;



/* 7 */
SELECT CONCAT(`last_name`, `first_name`, CHAR_LENGTH(`first_name`), 'Restaurant') AS `username`,
		REVERSE(SUBSTRING(`email`, 2, 12)) AS `password`
FROM `waiters`
WHERE `salary` IS NOT NULL
ORDER BY `password` DESC;
 


/* 8 */
SELECT `id`, `name`, COUNT(*) AS `count` FROM `products` `p`
JOIN `orders_products` AS `op` ON `op`.`product_id` = `p`.`id`
GROUP BY `p`.`name`
HAVING `count` >= 5
ORDER BY `count` DESC, `p`.`name`;



/* 9 */
SELECT `t`.`id`, 
		`t`.`capacity`,
        COUNT(`oc`.`client_id`) AS `count_clients`,
        CASE
        WHEN `t`.`capacity` = COUNT(`oc`.`client_id`) THEN 'Full'
        WHEN `t`.`capacity` > COUNT(`oc`.`client_id`) THEN 'Free seats'
        WHEN `t`.`capacity` < COUNT(`oc`.`client_id`) THEN 'Extra seats'
    END AS `availability`
FROM 
		`tables` AS `t`
JOIN `orders` AS `o` ON `o`.`table_id` = `t`.`id`
JOIN `orders_clients` AS `oc` ON `oc`.`order_id` = `o`.`id`        
WHERE `t`.`floor` = 1
GROUP BY `t`.`id`
ORDER BY `t`.`id` DESC;

/* Друго решение на задача 9 */
SELECT 
    `subquery`.`id`, 
    `subquery`.`capacity`, 
    SUM(`subquery`.`count_clients`) AS `total_clients`,
    CASE
        WHEN `subquery`.`capacity` - SUM(`subquery`.`count_clients`) = 0 THEN 'Full'
        WHEN `subquery`.`capacity` - SUM(`subquery`.`count_clients`) > 0 THEN 'Free seats'
        WHEN `subquery`.`capacity` - SUM(`subquery`.`count_clients`) < 0 THEN 'Extra seats'
    END AS `availability`
FROM 
    (SELECT 
            `t`.`id`, 
            `t`.`capacity`, 
            COUNT(*) AS `count_clients`
        FROM `tables` AS `t`
        JOIN `orders` AS `o` ON `o`.`table_id` = `t`.`id`
        JOIN  `orders_clients` AS `oc` ON `oc`.`order_id` = `o`.`id`
        WHERE  `t`.`floor` = 1
        GROUP BY  `t`.`id`) AS `subquery`
GROUP BY `subquery`.`id`
ORDER BY `subquery`.`id` DESC;



/* 10 */
DELIMITER $$ 
CREATE FUNCTION `udf_client_bill`(`full_name` VARCHAR(50))
RETURNS DECIMAL(19,2)
DETERMINISTIC
BEGIN
		DECLARE `result` DECIMAL(19,2);
		SET `result` := (
			SELECT SUM(`price`) FROM `products` AS `p`
            JOIN `orders_products` AS `op` ON `op`.`product_id` = `p`.`id`
            JOIN `orders` AS `o` ON `op`.`order_id` = `o`.`id`
            JOIN `orders_clients` AS `os` ON `os`.`order_id` = `o`.`id`
            JOIN `clients` AS `c` ON `os`.`client_id` = `c`.`id`
            WHERE CONCAT(`c`.`first_name`, ' ', `c`.`last_name`) = `full_name`
                );
RETURN `result`;
END $$
DELIMITER ;
;



/* 11 */
DELIMITER $$
CREATE PROCEDURE `udp_happy_hour`(`type` VARCHAR(50))
BEGIN
	 UPDATE `products` AS `p`
     SET `p`.`price` = `p`.`price` * 0.80
     WHERE `p`.`type` = `type` AND `price` >= 10;
   
END $$
DELIMITER ;
;









