CREATE DATABASE `exam_prep_one`;
USE `exam_prep_one`;

/* 1 */
CREATE TABLE `countries`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE `cities` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `population` INT,
    `country_id` INT NOT NULL,
    CONSTRAINT `fk__country_id__cities__id__countries`
    FOREIGN KEY (`country_id`)
    REFERENCES `countries`(`id`)
);

CREATE TABLE `universities` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(60) NOT NULL UNIQUE,
    `address` VARCHAR(80) NOT NULL UNIQUE,
    `tuition_fee` DECIMAL(19,2) NOT NULL,
    `number_of_staff` INT,
    `city_id` INT,
    CONSTRAINT `fk__city_id__universities__id__cities`
    FOREIGN KEY (`city_id`)
    REFERENCES `cities`(`id`)
);

CREATE TABLE `courses`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(40) NOT NULL UNIQUE,
    `duration_hours` DECIMAL(19,2),
    `start_date` DATE,
    `teacher_name` VARCHAR(60) NOT NULL UNIQUE,
    `description` TEXT,
    `university_id` INT,
    CONSTRAINT `fk__university_id__courses__id__universities`
    FOREIGN KEY (`university_id`)
    REFERENCES `universities`(`id`)
);

CREATE TABLE `students`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
    `age` INT,
    `phone` VARCHAR(20) NOT NULL UNIQUE,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `is_graduated` BOOLEAN NOT NULL,
    `city_id` INT,
    CONSTRAINT `fk__city_id__students__id__cities`
    FOREIGN KEY (`city_id`)
    REFERENCES `cities`(`id`)
);

CREATE TABLE `students_courses` (
	`grade` DECIMAL(19,2) NOT NULL,
    `student_id` INT NOT NULL,
    `course_id` INT NOT NULL,
    CONSTRAINT `fk__student_id__students_courses__id__students`
    FOREIGN KEY (`student_id`)
    REFERENCES `students`(`id`),
    CONSTRAINT `fk__course_id__students_courses__id__courses`
    FOREIGN KEY (`course_id`)
    REFERENCES `courses`(`id`)
);



/* 2 */
INSERT INTO `courses`(`name`, `duration_hours`, `start_date`, 
						`teacher_name`, `description`, `university_id`)
SELECT CONCAT(`teacher_name`, ' course'),
		LENGTH(`name`) / 10,
		DATE_ADD(`start_date`, INTERVAL 5 DAY),
        REVERSE(`teacher_name`),
        CONCAT('Course ', `teacher_name`, REVERSE(`description`)),
        DAY(`start_date`)
FROM  `courses`
WHERE `id` <= 5;



/* 3 */
UPDATE `universities`
SET `tuition_fee` = `tuition_fee` + 300
WHERE `id` BETWEEN 5 AND 12;



/* 4 */
DELETE FROM `universities`
WHERE `number_of_staff` IS NULL;



/* 5 */
SELECT `id`, `name`, `population`, `country_id`
FROM `cities`
ORDER BY `population` DESC;



/* 6 */
SELECT `first_name`, `last_name`, `age`, `phone`, `email`
FROM `students`
WHERE `age` >= 21
ORDER BY `first_name`DESC, `email` , `id` 
LIMIT 10;



/* 7 */
SELECT CONCAT(`first_name`, ' ', `last_name`) AS `full_name`, 
		SUBSTRING( `email`, 2, 10) AS `username`,
		REVERSE(`phone`) AS `password `
       FROM `students` AS `s`
LEFT JOIN `students_courses` AS `sk` ON `s`.`id` = `sk`.`student_id`
WHERE `course_id` IS NULL
ORDER BY `password ` DESC;


 
/* 8 */
SELECT COUNT(*) AS `students_count`, `u`.`name` AS `university_name`
FROM `universities` AS `u`
JOIN `courses` AS `c` ON `c`.`university_id` = `u`.`id`
JOIN `students_courses` AS `sc` ON `c`.`id` = `sc`.`course_id`
GROUP BY `university_name`
HAVING `students_count` >= 8
ORDER BY `students_count` DESC, `university_name` DESC;



/* 9 */
SELECT `u`.`name` AS `university_name`, 
		`c`.`name` AS `city_name`,
        `u`.`address`, 
        CASE
        WHEN `u`.`tuition_fee` < 800 THEN 'cheap'
        WHEN `u`.`tuition_fee` < 1200 THEN 'normal'
        WHEN `u`.`tuition_fee` < 2500 THEN 'high'
        WHEN `u`.`tuition_fee` >= 2500 THEN 'expensive'
        END AS 	`price_rank`,
        `u`.`tuition_fee`
FROM `universities` AS `u`
JOIN `cities` AS `c` ON `u`.`city_id` = `c`.`id` 
ORDER BY `tuition_fee`;



/* 10 */
DELIMITER $$
CREATE FUNCTION `udf_average_alumni_grade_by_course_name`(`course_name` VARCHAR(60))
RETURNS DECIMAL(19, 2)
DETERMINISTIC
BEGIN
	DECLARE `result` DECIMAL(19, 2);
    
	SET `result` := (SELECT AVG(`sc`.`grade`) FROM `courses` AS `c`
						JOIN `students_courses` AS `sc` ON `c`.`id` = `sc`.`course_id`
						JOIN `students` AS `s` ON `sc`.`student_id` = `s`.`id`
                        WHERE `c`.`name` = `course_name` AND `s`.`is_graduated` = TRUE
                        GROUP BY `c`.`id`
    );
    
	RETURN `result`;
    
    
END $$
DELIMITER ;
;



/* 11 */
DELIMITER $$
CREATE PROCEDURE `udp_graduate_all_students_by_year`(`year_started` INT)
BEGIN
	UPDATE `students` AS `s`
    JOIN `students_courses` `sc` ON `s`.`id` = `sc`.`student_id`
    JOIN `courses` `c` ON `sc`.`course_id` =  `c`.`id`
	SET `is_graduated` = TRUE
    WHERE YEAR(`c`.`start_date`) = `year_started`;
END $$
DELIMITER ;
;



