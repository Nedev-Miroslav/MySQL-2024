/* 1. One-To-One Relationship */
CREATE DATABASE `one_to_one_db`;
USE `one_to_one_db`;

CREATE TABLE `passports`(
	`passport_id` INT PRIMARY KEY AUTO_INCREMENT, 
	`passport_number` VARCHAR(50) UNIQUE

);

ALTER TABLE `passports` AUTO_INCREMENT = 101;

INSERT INTO `passports` (`passport_number`)
VALUES('N34FG21B'), 
		('K65LO4R7'),
        ('ZE657QP2');


CREATE TABLE `people`(
	`person_id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(50),
    `salary` DECIMAL(9,2),
	`passport_id` INT UNIQUE,
    
	CONSTRAINT `fk_people_passports`
    FOREIGN KEY (`passport_id`)
    REFERENCES `passports`(`passport_id`)

);

INSERT INTO `people` (`first_name`, `salary`, `passport_id`)
VALUES('Roberto', 43300.00, 102),
	('Tom', 56100.00, 103),
    ('Yana', 60200.00, 101);
    
    
    
/* 2. One-To-Many Relationship */ 
CREATE DATABASE `one_to_many_db`;
USE `one_to_many_db`;

CREATE TABLE `manufacturers`(
	`manufacturer_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50) UNIQUE, /* и без UNIQUE работи в Judge*/
    `established_on` DATE

);

INSERT INTO `manufacturers` (`name`, `established_on`)
VALUES('BMW', '1916/03/01'),
	('Tesla', '2003/01/01'),
    ('Lada', '1966/05/01');

CREATE TABLE `models`(
	`model_id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(100),
    `manufacturer_id` INT,
    CONSTRAINT `fk_models__manufacturer_id__manufacturers__manufacturer_id`
    FOREIGN KEY (`manufacturer_id`)
    REFERENCES `manufacturers`(`manufacturer_id`)

);

ALTER TABLE `models` AUTO_INCREMENT = 101;

INSERT INTO `models`(`name`, `manufacturer_id`)
VALUE('X1', 1),
	('i6', 1),
    ('Model S', 2),
    ('Model X', 2),
    ('Model 3', 2),
    ('Nova', 3);
    
    

/* 3. Many-To-Many Relationship */   
CREATE DATABASE `many_to_many_db`;
USE `many_to_many_db`;
  
CREATE TABLE `students` (
	`student_id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50)
);
    
INSERT INTO `students`(`name`)
VALUES('Mila'),
	('Toni'),
    ('Ron');
    
CREATE TABLE `exams`(
	`exam_id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50)
);
    
ALTER TABLE `exams` AUTO_INCREMENT = 101;    
    
INSERT INTO `exams`(`name`)
VALUES('Spring MVC'),
	('Neo4j'),
    ('Oracle 11g');
 
CREATE TABLE `students_exams` (
	`student_id` INT,
	`exam_id` INT,
    CONSTRAINT `pk`
	PRIMARY KEY (`student_id`, `exam_id`),
	CONSTRAINT `fk__student_id__students__student_id`
    FOREIGN KEY (`student_id`)
    REFERENCES `students`(`student_id`),
    CONSTRAINT `fk__exam_id__exams__exam_id`
    FOREIGN KEY (`exam_id`)
    REFERENCES `exams`(`exam_id`)
    
);  

INSERT INTO `students_exams` (`student_id`, `exam_id`)
VALUES(1, 101),
	(1, 102),
    (2, 101),
    (3, 103),
    (2, 102),
    (2, 103);
 
 
 
/* 4. Self-Referencing */ 
CREATE DATABASE `self_referencing_db`;
USE `self_referencing_db`;

CREATE TABLE `teachers`(
	`teacher_id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50),
    `manager_id` INT
);

ALTER TABLE `teachers` AUTO_INCREMENT = 101;

INSERT INTO `teachers` (`teacher_id`, `name`, `manager_id`)
VALUES(101, 'John', NULL),
    (102, 'Maya', 106),
    (103, 'Silvia', 106),
    (104, 'Ted', 105),
    (105, 'Mark', 101),
    (106, 'Greta', 101);
    
ALTER TABLE `teachers`
    ADD CONSTRAINT `fk__manager_id__teachers__teacher_id`
    FOREIGN KEY (`manager_id`)
    REFERENCES `teachers`(`teacher_id`);



/* 5. Online Store Database */
CREATE DATABASE `online_store_db`;
USE `online_store_db`;

CREATE TABLE `item_types`(
	`item_type_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50)

);

CREATE TABLE `cities` (
	`city_id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50)	
   
);

CREATE TABLE `customers` (
	`customer_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50),
    `birthday` DATE,
    `city_id` INT,
    CONSTRAINT `fk__city_id__customers__city__city_id`
    FOREIGN KEY (`city_id`)
    REFERENCES `cities`(`city_id`)

);

CREATE TABLE `orders` (
	`order_id` INT PRIMARY KEY AUTO_INCREMENT,
    `customer_id` INT,
    CONSTRAINT `fk__customer_id__orders__customer_id__customers`
    FOREIGN KEY (`customer_id`)
    REFERENCES `customers`(`customer_id`)

);

CREATE TABLE `items`(
	`item_id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50),
    `item_type_id` INT,
    CONSTRAINT `fk__item_type_id__items__item_type_id__item_types`
    FOREIGN KEY (`item_type_id`)
	REFERENCES `item_types`(`item_type_id`)

);

CREATE TABLE `order_items`(
	`order_id` INT,
	`item_id` INT,
    CONSTRAINT `pk`
    PRIMARY KEY (`order_id`, `item_id`),
    CONSTRAINT `fk__order_id__order_items__order_id__orders`
    FOREIGN KEY (`order_id`)
    REFERENCES `orders`(`order_id`),
    CONSTRAINT `fk__item_id__order_items__item_id__items`
    FOREIGN KEY (`item_id`)
    REFERENCES `items`(`item_id`)

);



/* 6. University Database */   
CREATE DATABASE `university_db`;
USE `university_db`;

CREATE TABLE `majors`(
	`major_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(50)

);
    
CREATE TABLE `subjects`(
	`subject_id` INT PRIMARY KEY AUTO_INCREMENT,
    `subject_name` VARCHAR(50)

);   
    
CREATE TABLE `students` (
	`student_id` INT PRIMARY KEY AUTO_INCREMENT,
    `student_number` VARCHAR(12),
    `student_name` VARCHAR(50),
    `major_id` INT,
    CONSTRAINT `fk__major_id__students__major_id__majors`
    FOREIGN KEY (`major_id`)
    REFERENCES `majors`(`major_id`)

);

CREATE TABLE `payments`(
	`payment_id` INT PRIMARY KEY AUTO_INCREMENT,
    `payment_date` DATE,
    `payment_amount` DECIMAL(8, 2),
    `student_id` INT,
    CONSTRAINT `fk__student_id__payments__student_id__students`
    FOREIGN KEY (`student_id`)
    REFERENCES `students`(`student_id`)

);    
    
CREATE TABLE `agenda`(
	`student_id` INT,
	`subject_id` INT,
    CONSTRAINT `pk`
    PRIMARY KEY (`student_id`, `subject_id`),
    CONSTRAINT `fk__student_id__agenda__student_id__students`
    FOREIGN KEY (`student_id`)
    REFERENCES `students`(`student_id`),
    CONSTRAINT `fk__subject_id__agenda__subject_id__subjects`
    FOREIGN KEY (`subject_id`)
    REFERENCES `subjects`(`subject_id`)

);    
    
  
  
/* 9. Peaks in Rila */
SELECT m.`mountain_range`, p.`peak_name`, p.`elevation`
FROM `mountains` AS m
JOIN `peaks` AS p
ON p.`mountain_id` = m.`id`
WHERE m.`mountain_range` = 'Rila'
ORDER BY p.`elevation` DESC;


