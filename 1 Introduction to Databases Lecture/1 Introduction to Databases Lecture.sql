SELECT * FROM employees;

CREATE TABLE people (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(50) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);


SELECT 
    first_name, last_name
FROM
    employees
LIMIT 2;    





/*
Задача 1
*/

CREATE TABLE employees(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
    
);

CREATE TABLE categories(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
    
);





CREATE TABLE products(
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
    category_id INT NOT NULL

);


/*
Задача 2
*/

INSERT INTO employees VALUES (10, "Query", NULL); /* Непрепопъчителен начин за insert  */

INSERT INTO employees(first_name, last_name) 
VALUES("Fielf", "List"),
	("SecondEntry", "Second"),
    ("ThirdEntry", "Third");

SELECT * FROM employees;


/*
Задача 3
*/

ALTER TABLE employees
ADD COLUMN middle_name VARCHAR(50) NOT NULL;

/*
Задача 4
*/
ALTER TABLE products
ADD CONSTRAINT fk_category_id
FOREIGN KEY (category_id)
REFERENCES categories(id);

/*
Задача 5
*/

ALTER TABLE employees
MODIFY COLUMN middle_name VARCHAR(100);


ALTER TABLE people
ADD CONSTRAINT pk_id
PRIMARY KEY (id);

