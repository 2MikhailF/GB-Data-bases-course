/*�������� ���� ������ example, ���������� � ��� ������� users,
 ��������� �� ���� ��������, ��������� id � ���������� name.*/

-- �������� �� 
DROP DATABASE IF EXISTS example;
CREATE DATABASE example;
USE example;
		
-- ������� ������� users1
DROP TABLE IF EXISTS users1;
CREATE TABLE users1 (
	id INT UNSIGNED,
	name VARCHAR(255) COMMENT '��� ������������'
);





/* �������� ���� ���� ������ example �� ����������� �������,
���������� ���������� ����� � ����� ���� ������ sample. */

/*  

���� �� ����� �� ������� (�����, �������������� �� ������� mysql) ��� ����� ��������:
mysqldump -u root -p example >  sample.sql

���� sample.sql ����������� � ���������� ������, ������ ������� ����������.

�����, ����� ���������� ����, ����� ��������� �� ������� �������:
mysql -u root -p sample < sample.sql
�� � ���� ������-�� �� �������� ������ �������.
���������� ������ ����� mysql ������ � �������:

CREARE DATABASE sample;
USE sample;
SOURCE sample.sql;


*/


/*������������ ����� �������� � ������������� ������� mysqldump. 
�������� ���� ������������ ������� help_keyword ���� ������ mysql.
 ������ ��������� ����, ����� ���� �������� ������ ������ 100 ����� �������.*/

/*

mysqldump --where=" 1 limit 100" -u root -p mysql help_keyword > mysql_help_keywords_dump.sql

*/

			