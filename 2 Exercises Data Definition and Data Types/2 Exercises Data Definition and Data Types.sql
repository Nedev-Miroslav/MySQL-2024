CREATE DATABASE `minions`;

USE `minions`;

/* Задача 1 */
CREATE TABLE `minions`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(255),
    `age` INT
);

CREATE TABLE `towns` (
    `town_id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL
);


/* Задача 2 */
ALTER TABLE `minions`
ADD COLUMN `town_id` INT NOT NULL,
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY (`town_id`)
REFERENCES `towns` (`id`);


/* Задача 3 */
INSERT INTO `towns`(`id`, `name`)
VALUES (1, "Sofia"), (2, "Plovdiv"), (3, "Varna");

INSERT INTO `minions`(`id`, `name`, `age`, `town_id`)
VALUES (1, "Kevin", 22, 1), 
(2, "Bob", 15, 3), 
(3, "Steward", NULL, 2);


/* Задача 4 */
TRUNCATE TABLE `minions`;


/* Задача 5 */ 
DROP TABLE `minions`;
DROP TABLE `towns`;


/* Задача 6 */ 
CREATE DATABASE `exercise`;
USE `exercise`;

CREATE TABLE `people`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name`  VARCHAR(200) NOT NULL,
    `picture` BLOB,
    `height` DOUBLE(10, 2),
    `weight` DOUBLE(10, 2),
    `gender`  CHAR(1) NOT NULL,
    `birthdate` DATE NOT NULL,
    `biography` TEXT
);


INSERT INTO `people` (`name`, `gender`, `birthdate`)
VALUES
	("Pesho", 'm', "2000-10-29"),
	("Gosho", 'm', "1999-01-12"),
	("Desi", 'f', "1998-02-11"),
	("Viki", 'f', "1997-06-12"),
	("Tosho", 'm', DATE(now()));


/* Задача 7 */ 
CREATE TABLE `users` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(30) NOT NULL,
	`password` VARCHAR(26) NOT NULL,
    `profile_picture` BLOB,
    `last_login_time` TIME,
    `is_deleted` BOOLEAN
);

INSERT INTO `users` (`username`, `password` )
VALUES 
	("pesho1", "112323"),
	("pesho2", "1235534"),
	("gosho1", "1123434543"),
	("toshko", "13544353"),
	("pesho34", "134243454");


/* Задача 8 */ 
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD PRIMARY KEY pk_users (`id`, `username`);


/* Задача 9 */ 
ALTER TABLE `users`
MODIFY COLUMN `last_login_time` DATETIME DEFAULT NOW();


/* Задача 10 */ 
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY `users` (`id`) ,
MODIFY COLUMN `username` VARCHAR(30) UNIQUE;


/* Задача 11 */ 
CREATE DATABASE `Movies`;
USE `Movies`;

CREATE TABLE `directors`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `director_name` VARCHAR(255) NOT NULL,
    `notes` TEXT
);

INSERT INTO `directors`(`director_name`, `notes`)
VALUES 
	("Pesho1", "Peshosnotes1"),
	("Pesho2", "Peshosnotes2"),
	("Pesho3", "Peshosnotes3"),
	("Pesho4", "Peshosnotes4"),
	("Pesho5", "Peshosnotes5");

CREATE TABLE `genres`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `genre_name` VARCHAR(255) NOT NULL,
    `notes` TEXT
);

INSERT INTO `genres` (`genre_name`, `notes`)
VALUES 
	("Gosho1", "Goshosnotes1"),
	("Gosho2", "Goshosnotes2"),
	("Gosho3", "Goshosnotes3"),
	("Gosho4", "Goshosnotes4"),
	("Gosho5", "Goshosnotes5");


CREATE TABLE `categories`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `category_name` VARCHAR(255) NOT NULL,
    `notes` TEXT
);

INSERT INTO `categories`(`category_name`, `notes`)
VALUES 
	("test1", "notes1"),
	("test2", "notes2"),
	("test3", "notes3"),
	("test4", "notes4"),
	("test5", "notes5");


CREATE TABLE `movies`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `director_id` INT,
    `copyright_year` INT,
    `length` INT, 
    `genre_id` INT,
    `category_id` INT,
    `rating` DOUBLE,
    `notes` TEXT
);

INSERT INTO `movies` (`title`)
VALUES 
	("moviestest1"),
	("moviestest2"),
	("moviestest3"),
	("moviestest4"),
	("moviestest5");



/* Задача 12 */ 
CREATE DATABASE `car_rental`;
USE `car_rental`;

CREATE TABLE `categories`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `category` VARCHAR(255),
    `daily_rate` DOUBLE,
    `weekly_rate` DOUBLE,
    `monthly_rate` DOUBLE,
    `weekend_rate` DOUBLE
);
INSERT INTO `categories`(`category`,`daily_rate`, `weekly_rate`, `monthly_rate`, `weekend_rate`)
VALUES
("CategoryTest1", 1.0, 2.0, 3.0, 4.0),
("CategoryTest2", 1.1, 2.1, 3.1, 4.1),
("CategoryTest2", 1.2, 2.2, 3.2, 4.2);


CREATE TABLE `cars` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `plate_number` VARCHAR(255),
    `make` VARCHAR(255),
    `model` VARCHAR(255),
    `car_year` INT,
    `category_id` INT,
    `doors` INT,
    `picture` BLOB,
    `car_condition` VARCHAR(255),
    `available` BOOLEAN
);
INSERT INTO `cars` (`plate_number`, `make`, `model`, `car_year`, `category_id`, `doors`, `picture`, `car_condition`, `available`)
VALUES
("plate1", "make1", "model1", 2004, 3, 4, "pic1", "old", false),
("plate2", "make2", "model2", 2004, 3, 4, "pic2", "old", true),
("plate3", "make3", "model3", 2004, 3, 4, "pic3", "old", false);


CREATE TABLE `employees`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(255),
    `last_name` VARCHAR(255),
    `title` VARCHAR(255),
    `notes` TEXT
    
);
INSERT INTO `employees`(`first_name`, `last_name`, `title`, `notes`)
VALUES
("firstName1", "lastName1", "title1", "notes1"),
("firstName2", "lastName2", "title2", "notes2"),
("firstName3", "lastName3", "title3", "notes3");


CREATE TABLE `customers`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `driver_licence_number` VARCHAR(255),
    `full_name` VARCHAR(255),
    `address` VARCHAR(255),
    `city` VARCHAR(255),
    `zip_code` VARCHAR(255),
    `notes` TEXT
    
);
INSERT INTO `customers`(`driver_licence_number`, `full_name`)
VALUES
("firstName1", "lastName1"),
("firstName2", "lastName2"),
("firstName3", "lastName3");

CREATE TABLE `rental_orders`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `employee_id` INT,
    `customer_id` INT,
    `car_id` INT,
    `car_condition` VARCHAR(255),
    `tank_level` VARCHAR(255),
    `kilometrage_start` INT,
    `kilometrage_end` INT,
    `total_kilometrage` INT,
    `start_date` DATE,
    `end_date` DATE,
     `total_days` INT,
    `rate_applied` DOUBLE,
    `tax_rate` DOUBLE,
    `order_status` VARCHAR(20),
    `notes` TEXT
    
);
INSERT INTO `rental_orders` (`employee_id`, `customer_id`)
VALUES 
(1, 2),
(2, 3),
(3, 1);


/* Задача 13 */
CREATE DATABASE `soft_uni`;
USE `soft_uni`;

CREATE TABLE `addresses`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`address_text` VARCHAR(255) NOT NULL,
`town_id` INT NOT NULL
);

CREATE TABLE `departments` (
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL
);

CREATE TABLE `employees` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `first_name` VARCHAR(255) NOT NULL,
    `middle_name` VARCHAR(255) NOT NULL,
    `last_name` VARCHAR(255) NOT NULL,
    `job_title` VARCHAR(255) NOT NULL,
    `department_id` INT NOT NULL,
    `hire_date` DATE,
    `salary` DECIMAL,
    `address_id` INT 
);
/* В judge се събмитва само пълненето на създадените таблици */
INSERT INTO `towns` (`name`)
VALUES ("Sofia"), ("Plovdiv"), ("Varna"), ("Burgas");
 
INSERT INTO `departments` (`name`)
VALUES ("Engineering"), ("Sales"), ("Marketing"), ("Software Development"), ("Quality Assurance");
  
INSERT INTO `employees` (`first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`)
VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);


/* Задача 14 */
SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;


/* Задача 15 */
SELECT * FROM `towns`
ORDER BY `name`;

SELECT * FROM `departments`
ORDER BY `name`;

SELECT * FROM `employees`
ORDER BY `salary` DESC;


/* Задача 16 */
SELECT `name` FROM `towns`
ORDER BY `name`;

SELECT `name` FROM `departments`
ORDER BY `name`;

SELECT `first_name`, `last_name`, `job_title`, `salary` FROM `employees`
ORDER BY `salary` DESC;


/* Задача 17 */
UPDATE `employees`
SET `salary` = `salary` * 1.10;
SELECT `salary` FROM `employees`;

