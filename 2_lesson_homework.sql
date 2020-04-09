/*Создайте базу данных example, разместите в ней таблицу users,
 состоящую из двух столбцов, числового id и строкового name.*/

-- создадим БД 
DROP DATABASE IF EXISTS example;
CREATE DATABASE example;
USE example;
		
-- создаем таблицу users1
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id INT UNSIGNED,
	name VARCHAR(255) COMMENT 'Имя пользователя'
);





/* Создайте дамп базы данных example из предыдущего задания,
разверните содержимое дампа в новую базу данных sample. */

/*  

Дамп БД делаю из консоли (выйдя, предварительно из клиента mysql) вот такой командой:
mysqldump -u root -p example >  sample.sql

файл sample.sql сохраняется в директории откуда, данная команда вызывалась.

Далее, чтобы развернуть дамп, нужно выполнить из консоли команду:
mysql -u root -p sample < sample.sql


Предварительно создав базу, куда делаем дамп:

CREARE DATABASE sample;
USE sample;


*/


/*Ознакомьтесь более подробно с документацией утилиты mysqldump. 
Создайте дамп единственной таблицы help_keyword базы данных mysql.
 Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы.*/

/*

mysqldump --where=" 1 limit 100" -u root -p mysql help_keyword > mysql_help_keywords_dump.sql

*/

			