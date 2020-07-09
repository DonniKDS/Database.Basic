/* 
1. Создать VIEW на основе SELECT-запроса, который вы писали в ДЗ к уроку 3. 
*/

USE vk;

-- возвращающаем список имен (только firstname) пользователей без повторений в алфавитном порядке

CREATE OR REPLACE VIEW view_get_users_firstname AS 
	SELECT DISTINCT firstname
	FROM users
	ORDER BY firstname;

/*
2. Создать функцию, которая найдет пользователя по имени и фамилии.
*/

USE vk;

DROP FUNCTION IF EXISTS func_find_user;

DELIMITER !!

CREATE FUNCTION func_find_user(user_firstname VARCHAR(50), user_lastname VARCHAR(50))
RETURNS BIGINT READS SQL DATA
BEGIN
	DECLARE user_id BIGINT;
    
    SET user_id = (
		SELECT id 
		FROM users
		WHERE firstname = user_firstname AND lastname = user_lastname
        LIMIT 1
	);
    
    RETURN user_id;
END!!

DELIMITER ;

/*
3. Создать триггер, который при обновлении профиля пользователя будет проверять его дату рождения. Если дата из будущего, то подменить ее на сегодняшнее число.
*/

USE vk;

DELIMITER !!

CREATE TRIGGER check_user_age 
BEFORE UPDATE ON profiles FOR EACH ROW
BEGIN
    IF NEW.birthday >= CURRENT_DATE() THEN
        SET NEW.birthday = CURRENT_DATE();
    END IF;
END!!

DELIMITER ;