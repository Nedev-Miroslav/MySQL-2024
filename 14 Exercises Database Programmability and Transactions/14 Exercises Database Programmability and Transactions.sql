/* Part I – Queries for SoftUni Database */

/* 1. Employees with Salary Above 35000 */
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_salary_above_35000`()
BEGIN
	SELECT `first_name`, `last_name`
    FROM `employees`
    WHERE `salary` > 35000
    ORDER BY `first_name`, `last_name`, `employee_id`;
END $$

DELIMITER ;
;



/* 2. Employees with Salary Above Number */
DELIMITER $$
CREATE PROCEDURE `usp_get_employees_salary_above`(`input_salary` DECIMAL(19, 4)) 
BEGIN
	SELECT `first_name`, `last_name`
    FROM `employees`
	WHERE `salary` >= `input_salary`
    ORDER BY `first_name`, `last_name`, `employee_id`;
END $$

DELIMITER ;
;



/* 3. Town Names Starting With */
DELIMITER $$
CREATE PROCEDURE `usp_get_towns_starting_with`(`input_town` VARCHAR(50))
BEGIN
	SELECT `name` AS `town_name`
    FROM `towns`
    WHERE `name` LIKE CONCAT(input_town, '%')
	ORDER BY `town_name`;
END $$

DELIMITER ;
;

/* Друго решение на задача 3 */
DELIMITER $$
CREATE PROCEDURE `usp_get_towns_starting_with`(`input_town` VARCHAR(50))
BEGIN
	SELECT `name` AS `town_name`
    FROM `towns`
    WHERE LEFT(`name`, CHAR_LENGTH(input_town)) = input_town
	ORDER BY `town_name`;
END $$

DELIMITER ;
;



/* 4. Employees from Town */
DELIMITER $$ 
CREATE PROCEDURE `usp_get_employees_from_town`(`town_name` VARCHAR(50))
BEGIN 
	SELECT `first_name`, `last_name`
    FROM `employees` AS `e`
    JOIN `addresses` AS `a` USING (`address_id`)
    JOIN `towns` AS `t` USING (`town_id`)
    WHERE `t`.`name` = `town_name`
    ORDER BY `first_name`, `last_name`, `employee_id`;
END $$  
  
DELIMITER ;
;



/* 5. Salary Level Function */
DELIMITER $$ 
CREATE FUNCTION `ufn_get_salary_level`(`salary` DECIMAL(19, 4))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	DECLARE `salary_level_to_return` VARCHAR(20);
	IF `salary` < 30000 THEN SET `salary_level_to_return` := 'Low';
    ELSEIF `salary` <= 50000 THEN SET `salary_level_to_return` := 'Average';
    ELSE SET `salary_level_to_return` := 'High';
	END IF;
    RETURN `salary_level_to_return`;
END $$

DELIMITER ;
;


/* 6. Employees by Salary Level */
DELIMITER $$ 
CREATE PROCEDURE `usp_get_employees_by_salary_level`(`level_of_salary` VARCHAR(20))
BEGIN 
SELECT `first_name`, `last_name`
    FROM `employees`
	WHERE `ufn_get_salary_level`(`salary`) LIKE `level_of_salary`
    ORDER BY `first_name` DESC, `last_name` DESC;
END $$

DELIMITER ;
;



/* 7. Define Function */
DELIMITER $$ 
CREATE FUNCTION `ufn_is_word_comprised`(set_of_letters varchar(50), word varchar(50))  
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN word REGEXP (CONCAT('^[', set_of_letters, ']+$'));
END $$

DELIMITER ;
;



/* PART II – Queries for Bank Database */

/* 8. Find Full Name */
DELIMITER $$ 
CREATE PROCEDURE `usp_get_holders_full_name`()
BEGIN
	SELECT CONCAT(`first_name`, ' ', `last_name`) AS `full_name`
	FROM `account_holders`
	ORDER BY `full_name`;
END $$

DELIMITER ;
;



/* 9. People with Balance Higher Than */
DELIMITER $$
CREATE PROCEDURE `usp_get_holders_with_balance_higher_than`(target_salary DECIMAL(19,4))
BEGIN
    SELECT `ah`.`first_name`, `ah`.`last_name`
    FROM `account_holders` AS `ah`
    JOIN `accounts` AS `a` ON `ah`.`id` = `a`.`account_holder_id`
	WHERE target_salary < (SELECT SUM(`balance`)
							FROM `accounts`
                            WHERE `account_holder_id` = `ah`.`id`
							GROUP BY `account_holder_id`)
	GROUP BY `ah`.`id`
	ORDER BY `ah`.`id`;
END $$

DELIMITER ;
;



/* 10. Future Value Function */
DELIMITER $$
CREATE FUNCTION `ufn_calculate_future_value`(`input_sum` DECIMAL (19, 4), `yearly_interest_rate` DOUBLE, `years` INT)
RETURNS DECIMAL(19, 4)
DETERMINISTIC
BEGIN
	DECLARE `final_sum_to_return` DECIMAL(19, 4);
    SET `final_sum_to_return` := `input_sum` * POW(1 + `yearly_interest_rate`, `years`);
	RETURN `final_sum_to_return`;

END $$

DELIMITER ;
;



/* 11. Calculating Interest */
DELIMITER $$
CREATE PROCEDURE `usp_calculate_future_value_for_account`(`input_id` INT, `interest_rate` DECIMAL(19, 4))
BEGIN
	SELECT `a`.`id` AS `account_id`, `ah`.`first_name`, `ah`.`last_name`, `a`.`balance` AS `current_balance`,
    `ufn_calculate_future_value`(`a`.`balance`, `interest_rate`, 5) AS `balance_in_5_years`
    FROM `account_holders` AS `ah`
    JOIN `accounts` AS `a` ON `ah`.`id` = `a`.`account_holder_id`
	WHERE `input_id` = `a`.`id`;
    

END $$

DELIMITER ;
;



/* 12. Deposit Money */
DELIMITER $$
CREATE PROCEDURE `usp_deposit_money`(`account_id` INT, `money_amount` DECIMAL(19, 4))
BEGIN 
	START TRANSACTION;
    IF (`money_amount` <= 0)
	THEN ROLLBACK;
    ELSE
    UPDATE `accounts` AS `ac` SET `ac`.`balance` = `ac`.`balance` + `money_amount`
    WHERE `ac`.`id` = `account_id`;
    END IF;
END $$    

DELIMITER ;
;



/* 13. Withdraw Money */
DELIMITER $$
CREATE PROCEDURE `usp_withdraw_money`(`account_id` INT, `money_amount` DECIMAL(19, 4))
BEGIN
	START TRANSACTION;
    IF (`money_amount` <= 0 OR (SELECT `balance` FROM `accounts` AS `a` WHERE `a`.`id` = `account_id`) < `money_amount`)
	THEN ROLLBACK;
    ELSE
    UPDATE `accounts` AS `ac` SET `ac`.`balance` = `ac`.`balance` - `money_amount`
    WHERE `ac`.`id` = `account_id`;
    END IF;
END $$

DELIMITER ;
;



/* 14. Money Transfer */
DELIMITER $$
CREATE PROCEDURE `usp_transfer_money`(`from_account_id` INT, `to_account_id` INT, `money_amount` DECIMAL(19, 4)) 
BEGIN
	START TRANSACTION;
	IF (`money_amount` <= 0 
    OR (SELECT `balance` FROM `accounts` AS `a` WHERE `a`.`id` = `from_account_id`) < `money_amount`)
    OR `from_account_id` = `to_account_id` 
    OR (SELECT COUNT(`id`) FROM `accounts` WHERE `id` = `from_account_id`) <> 1
    OR (SELECT COUNT(`id`) FROM `accounts` WHERE `id` = `to_account_id`) <> 1
    THEN ROLLBACK;
    ELSE
    UPDATE `accounts` SET `balance` = `balance` - `money_amount` WHERE `id` = `from_account_id`;
    UPDATE `accounts` SET `balance` = `balance` + `money_amount` WHERE `id` = `to_account_id`;
    COMMIT;
    END IF;
END $$

DELIMITER ;
;



/* 15. Log Accounts Trigger */
CREATE TABLE `logs`(
    `log_id` INT PRIMARY KEY AUTO_INCREMENT, 
    `account_id` INT NOT NULL,
    `old_sum` DECIMAL(19, 4) NOT NULL,
    `new_sum` DECIMAL(19, 4) NOT NULL
);

DELIMITER $$
CREATE TRIGGER `tr_change_balance`
AFTER UPDATE ON `accounts`
FOR EACH ROW
BEGIN
    INSERT INTO `logs`(`account_id`, `old_sum`, `new_sum`) 
    VALUES (OLD.id, OLD.balance, NEW.balance);
END $$

DELIMITER ;
;


 
# 16. Emails Trigger 
CREATE TABLE `notification_emails`(
    `id` INT PRIMARY KEY AUTO_INCREMENT, 
    `recipient` INT NOT NULL,
    `subject` TEXT,
    `body` TEXT
);

DELIMITER $$
CREATE TRIGGER `tr_email_on_change_balance`
AFTER INSERT
ON `logs`
FOR EACH ROW
BEGIN
    INSERT INTO `notification_emails`(`recipient`, `subject`, `body`)
    VALUES (NEW.`account_id`, 
    concat_ws(' ', 'Balance change for account:', NEW.`account_id`), 
    concat_ws(' ', 'On', NOW(), 'your balance was changed from', NEW.`old_sum`, 'to', NEW.`new_sum`, '.'));
END $$

DELIMITER ;
;

