CREATE DATABASE `practis_one`;
USE `practis_one`;


/* 1 */
CREATE TABLE `movies_additional_info`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`rating` DECIMAL(10,2) NOT NULL,
    `runtime` INT NOT NULL,
    `picture_url` VARCHAR(80) NOT NULL,
	`budget` DECIMAL(10,2),
    `release_date` DATE NOT NULL,
    `has_subtitles` BOOLEAN,
	`description` TEXT
);

CREATE TABLE `countries`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(30) NOT NULL UNIQUE,
    `continent` VARCHAR(30) NOT NULL,
    `currency` VARCHAR(5) NOT NULL
);

CREATE TABLE `actors`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
	`birthdate` DATE NOT NULL,
    `height` INT,
    `awards` INT,
    `country_id` INT NOT NULL,
    CONSTRAINT `fk__country_id__actors__id__countries`
	FOREIGN KEY (`country_id`)
    REFERENCES `countries`(`id`)
);

CREATE TABLE `movies` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`title` VARCHAR(70) NOT NULL UNIQUE,
    `country_id` INT NOT NULL,
    `movie_info_id` INT NOT NULL UNIQUE,
    CONSTRAINT `fk__country_id__movies__id__countries`
    FOREIGN KEY (`country_id`)
    REFERENCES `countries`(`id`),
    CONSTRAINT `fk__movie_info_id__movies__id__movies_additional_info`
    FOREIGN KEY (`movie_info_id`)
    REFERENCES `movies_additional_info`(`id`)
);

CREATE TABLE `movies_actors`(
	`movie_id` INT,
    `actor_id` INT,
    CONSTRAINT `fk__movie_id__movies_actors__id__movies`
    FOREIGN KEY (`movie_id`)
    REFERENCES `movies`(`id`),
    CONSTRAINT `fk__actor_id__movies_actors__id__actors`
	FOREIGN KEY (`actor_id`)
    REFERENCES `actors`(`id`)
);

CREATE TABLE `genres` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE `genres_movies` (
	`genre_id` INT,
	`movie_id` INT,
    CONSTRAINT `fk__genre_id__genres_movies__id__genres`
    FOREIGN KEY (`genre_id`)
	REFERENCES `genres`(`id`),
	CONSTRAINT `fk__movie_id__genres_movies__id__movies`
    FOREIGN KEY (`movie_id`)
	REFERENCES `movies`(`id`)
);



/* 2 */
INSERT INTO `actors` (`first_name`, `last_name`, `birthdate`, 
						`height`, `awards`, `country_id`)
SELECT REVERSE(`first_name`),
		REVERSE(`last_name`),
		DATE_ADD(`birthdate`, INTERVAL -2 DAY),
		`height` + 10,
        `country_id`,
        3
FROM `actors`
WHERE `id` <= 10;



/* 3 */
UPDATE `movies_additional_info`
SET `runtime` = `runtime` - 10
WHERE `id` BETWEEN 15 AND 25;



/* 4 */
DELETE `c` FROM `countries` `c`
LEFT JOIN `movies` AS `m` ON `m`.`country_id` = `c`.`id`
WHERE `m`.`title` IS NULL;



/* 5 */
SELECT `id`, `name`, `continent`, `currency`
FROM `countries`
ORDER BY `currency` DESC, `id`;



/* 6 */
SELECT `mai`.`id`, `m`.`title`, `mai`.`runtime`, `mai`.`budget`, `mai`.`release_date`
FROM `movies_additional_info` AS `mai`
JOIN `movies` AS `m` ON `m`.`movie_info_id` = `mai`.`id`
WHERE YEAR(`mai`.`release_date`) BETWEEN 1996 AND 1999 
ORDER BY `mai`.`runtime`, `mai`.`id` 
LIMIT 20;



/* 7 */
SELECT CONCAT(`first_name`, ' ', `last_name`) AS `full_name`, 
		CONCAT(REVERSE(`last_name`), LENGTH(`last_name`), '@cast.com') AS `email`,
		2022 - YEAR(`birthdate`),
        `height`
       FROM `actors` AS `a`
LEFT JOIN `movies_actors` AS `ma` ON `ma`.`actor_id` = `a`.`id`
WHERE `actor_id` IS NULL
ORDER BY `height`;



/* 8 */
SELECT `name`, COUNT(*) AS `movies_count` FROM `countries` `c`
JOIN `movies` AS `m` ON `m`.`country_id` = `c`.`id`
GROUP BY `c`.`name`
HAVING `movies_count` >= 7
ORDER BY `c`.`name` DESC;



/* 9 */
SELECT `title`, CASE
        WHEN `mai`.`rating` <= 4 THEN 'poor'
        WHEN `mai`.`rating` <= 7 THEN 'good'
        WHEN `mai`.`rating` > 7 THEN 'excellent'
        END AS `rating`,
        IF(`mai`.`has_subtitles` = TRUE, 'english', '-'),
		`mai`.`budget`
FROM `movies_additional_info` AS `mai`
JOIN `movies` AS `m` ON `m`.`movie_info_id` = `mai`.`id`
ORDER BY `budget` DESC;



/* 10 */
DELIMITER $$ 
CREATE FUNCTION `udf_actor_history_movies_count`(`full_name` VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
		DECLARE `result` INT;
		SET `result` := (
        SELECT COUNT(*) FROM `genres` AS `g`
            JOIN `genres_movies` AS `gm` ON `gm`.`genre_id` = `g`.`id`
            JOIN `movies` AS `m` ON `gm`.`movie_id` = `m`.`id`
            JOIN `movies_actors` AS `ma` ON `ma`.`movie_id` = `m`.`id`
            JOIN `actors` AS `a` ON `ma`.`actor_id` = `a`.`id`
            WHERE CONCAT(`a`.`first_name`, ' ', `a`.`last_name`) = `full_name` AND `g`.`name` = 'history'
                );

	RETURN `result`;
  
END $$
DELIMITER ;
;



/* 11 */
DELIMITER $$
CREATE PROCEDURE `udp_award_movie` (`movie_title` VARCHAR(50))
BEGIN
	 UPDATE `actors` AS `a`
     JOIN `movies_actors` AS `ma` ON `ma`.`actor_id` = `a`.`id`
     JOIN `movies` AS `m` ON `ma`.`movie_id` = `m`.`id`
     SET `a`.`awards` = `a`.`awards` + 1
     WHERE `m`.`title` = `movie_title`;
   
END $$
DELIMITER ;
;


