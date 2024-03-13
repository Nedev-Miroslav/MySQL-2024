/* 1. Mountains and Peaks */
CREATE DATABASE `mountains_db`;

USE `mountains_db`;

CREATE TABLE `mountains`(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL
);

CREATE TABLE `peaks`(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL,
    `mountain_id` INT,
    CONSTRAINT fk_peaks_mountain_id_mountains_id
		FOREIGN KEY (mountain_id)
		REFERENCES mountains(id)
);
	

/* 2. Trip Organization */
USE `camp`; 

SELECT 
	vehicles.driver_id AS 'driver_id', 
    vehicle_type, 
    CONCAT(campers.first_name, ' ', campers.last_name) AS 'driver_name'
FROM `vehicles`
JOIN `campers` ON vehicles.driver_id = campers.id;


/* 3. SoftUni Hiking */
SELECT 
	starting_point AS 'route_starting_point',
    end_point AS 'route_end_point',
    leader_id,
    CONCAT(first_name, ' ', last_name) AS 'leader_name'
FROM `routes`
	JOIN campers ON routes.leader_id = campers.id;


/* 4. Delete Mountains */
USE `mountains_db`;
DROP TABLE `peaks`;

CREATE TABLE `mountains`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL
);

CREATE TABLE `peaks`(
	`id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL,
    `mountain_id` INT,
    CONSTRAINT `fk_peaks_mountain_id_mountains_id`
		FOREIGN KEY (`mountain_id`)
		REFERENCES `mountains`(`id`)
        ON DELETE CASCADE
);


/* 5. Project Management DB* */
CREATE DATABASE `project_management_db`;
USE `project_management_db`;

CREATE TABLE `clients`(
	`id` INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `client_name` VARCHAR(100)
);

CREATE TABLE `projects`(
	`id` INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	`client_id` INT,
    `project_lead_id` INT,
    CONSTRAINT fk_projects_client_id_clients_id
		FOREIGN KEY (client_id)
        REFERENCES clients(id)
);

CREATE TABLE `employees`(
	`id` INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	`first_name` VARCHAR(30),
    `last_name` VARBINARY(30),
    `project_id` INT,
    CONSTRAINT fk_employees_project_id_projects_id
    FOREIGN KEY (project_id)
    REFERENCES projects(id)
);

ALTER TABLE `projects`
ADD CONSTRAINT fk_projects_project_lead_id_employees_id
FOREIGN KEY (project_lead_id)
REFERENCES employees(id);








