--1: Выдать информацию о местоположении отдела продаж (SALES) компании.
SELECT DEPTNAME, DEPTADDR 
FROM DEPT d 
WHERE d.DEPTNAME='SALES';


--2: Выдать информацию об отделах, расположенных в Chicago и New York.
SELECT * 
FROM DEPT d 
WHERE d.DEPTADDR IN ('CHICAGO', 'NEW YORK');


--3: Найти минимальную заработную плату, начисленную в 2009 году.
SELECT MIN(SALVALUE) 
FROM SALARY s 
WHERE s.YEAR=2009;


--4: Выдать информацию обо всех работниках, родившихся не позднее 1 января 1960 года.
SELECT * 
FROM EMP e 
WHERE e.BIRTHDATE<=to_date('01-01-1960','dd-mm-yyyy');


--5: Подсчитать число работников, сведения о которых имеются в базе данных.
SELECT COUNT(EMPNO) 
FROM EMP e 
WHERE e.EMPNAME IS NOT NULL;


--6: Найти работников, чьё имя состоит из одного слова. Имена выдать на нижнем регистре, с удалением стоящей справа буквы t.
SELECT 
CASE WHEN SUBSTR(LOWER(EMPNAME), -1) = 't' 
	THEN SUBSTR(LOWER(EMPNAME), 0, LENGTH(LOWER(EMPNAME)) - 1)
ELSE 
    LOWER(EMPNAME)
END as name
FROM EMP WHERE EMPNAME NOT LIKE '% %';


--7: Выдать информацию о работниках, указав дату рождения в формате день(число), месяц(название), год(название). Тоже, но год числом.
SELECT EMPNO, EMPNAME, 
    TO_CHAR(BIRTHDATE, 'DD MONTH YEAR', 'nls_date_language=russian')
FROM EMP;

SELECT EMPNO, EMPNAME, 
    TO_CHAR(BIRTHDATE, 'DD MONTH YYYY', 'nls_date_language=russian')
FROM EMP;


--8: Выдать информацию о должностях, изменив названия должности “CLERK” и “DRIVER” на “WORKER”.
SELECT JOBNO,
(CASE JOBNAME 
     WHEN 'CLERK' THEN 'WORKER'
     WHEN 'DRIVER' THEN 'WORKER'
ELSE JOBNAME 
END) AS JNAME
FROM JOB;


--9: Определите среднюю зарплату за годы, в которые были начисления не менее чем за три месяца.
SELECT YEAR, AVG(SALVALUE) 
FROM SALARY 
GROUP BY YEAR 
HAVING COUNT(MONTH) >= 3;


--10: Выведете ведомость получения зарплаты с указанием имен служащих (оператор NATURAL JOIN).
SELECT e.EMPNAME, s.MONTH, s.YEAR
FROM SALARY s NATURAL JOIN EMP e;


--11: Найдите сведения о карьере сотрудников с указанием вместо номера сотрудника его имени (оператор JOIN USING).
SELECT e.EMPNAME, 
    TO_CHAR(c.STARTDATE, 'dd-mm-yyyy') AS STARTDATE, 
    TO_CHAR(c.ENDDATE, 'dd-mm-yyyy') AS ENDDATE, 
    c.JOBNO, 
    c.DEPTNO
FROM CAREER c JOIN EMP e USING(EMPNO);


--12: Найдите сведения о карьере сотрудников с указанием вместо номера сотрудника его имени (оператор JOIN ON).
SELECT 
    e.EMPNAME, 
    TO_CHAR(c.STARTDATE, 'dd-mm-yyyy') AS STARTDATE, 
    TO_CHAR(c.ENDDATE, 'dd-mm-yyyy') AS ENDDATE, 
    c.JOBNO, 
    c.DEPTNO
FROM CAREER c JOIN EMP e 
ON c.EMPNO = e.EMPNO;


--13: Укажите сведения о начислении сотрудникам зарплаты, попадающей в вилку: минимальный оклад по должности - минимальный оклад по должности плюс
--пятьсот. Укажите соответствующую вилке должность (оператор JOIN ON).
SELECT j.JOBNAME, e.EMPNAME, s.SALVALUE, j.MINSALARY 
FROM EMP e
NATURAL JOIN CAREER c
NATURAL JOIN JOB j
JOIN SALARY s ON s.SALVALUE 
BETWEEN j.MINSALARY AND j.MINSALARY + 500;


--13: Выдайте сведения о карьере сотрудников с указанием их имён, наименования должности, и названия отдела.
SELECT 
    e.EMPNAME,
    TO_CHAR(c.STARTDATE, 'dd-mm-yyyy') AS STARTDATE, 
    TO_CHAR(c.ENDDATE, 'dd-mm-yyyy') AS ENDDATE, 
    j.JOBNAME, 
    d.DEPTNAME
FROM EMP e
NATURAL JOIN CAREER c
NATURAL JOIN JOB j
NATURAL JOIN DEPT d
ORDER BY e.EMPNAME;


--14: Выдайте сведения о карьере сотрудников с указанием их имён. Какой вид внешнего объединения Вы использовали? 
--Составьте запрос с использованием противоположного вида соединения. Составьте запрос с использованием полного внешнего соединения.
SELECT e.EMPNAME, c.STARTDATE, c.ENDDATE
FROM EMP e 
RIGHT JOIN CAREER c USING(EMPNO);
		 
SELECT e.EMPNAME, c.STARTDATE, c.ENDDATE
FROM EMP e 
LEFT JOIN CAREER c USING(EMPNO);

SELECT e.EMPNAME, c.STARTDATE, c.ENDDATE
FROM EMP e 
FULL JOIN CAREER c USING(EMPNO);