--1: Найти имена сотрудников, получивших за годы начисления зарплаты 
--   минимальную зарплату.
SELECT e.EMPNAME, s.SALVALUE
FROM EMP e NATURAL JOIN SALARY s
WHERE s.SALVALUE = (SELECT min(s.SALVALUE) FROM SALARY s);


--2: Найти имена сотрудников, работавших или работающих в тех же отделах, в
--   которых работал или работает сотрудник с именем RICHARD MARTIN.
SELECT e.EMPNAME
FROM EMP e 
NATURAL JOIN CAREER c
WHERE c.DEPTNO IN (SELECT c.DEPTNO 
                  FROM CAREER c 
                  NATURAL JOIN EMP e 
                  WHERE e.EMPNAME = 'RICHARD MARTIN')
GROUP BY e.EMPNAME;


--3: Найти имена сотрудников, работавших или работающих в тех же отделах и
--   должностях, что и сотрудник RICHARD MARTIN.
SELECT e.EMPNAME
FROM EMP e 
NATURAL JOIN CAREER c
WHERE (c.DEPTNO, c.JOBNO) IN (SELECT c.DEPTNO, c.JOBNO 
                              FROM CAREER c 
                              NATURAL JOIN EMP e 
                              WHERE e.EMPNAME = 'RICHARD MARTIN')
GROUP BY e.EMPNAME;


--4: Найти сведения о номерах сотрудников, получивших за какой-либо месяц зарплату
--   большую, чем средняя зарплата за 2007 г. или большую чем средняя зарплата за
--   2008г.
SELECT s.EMPNO
FROM SALARY s
WHERE SALVALUE > ANY(
    (SELECT AVG(SALVALUE) FROM SALARY WHERE YEAR = 2007), 
    (SELECT AVG(SALVALUE) FROM SALARY WHERE YEAR = 2008))
GROUP BY EMPNO;


--5: Найти сведения о номерах сотрудников, получивших зарплату за какой-либо месяц
--   большую, чем средние зарплаты за все годы начислений.
SELECT s.EMPNO
FROM SALARY s
WHERE SALVALUE > ALL(SELECT AVG(SALVALUE) FROM SALARY GROUP BY YEAR);


--6: Определить годы, в которые начисленная средняя зарплата была больше средней
--   зарплаты за все годы начислений.
SELECT YEAR 
FROM SALARY 
GROUP BY YEAR 
HAVING AVG(SALVALUE) > (SELECT AVG(SALVALUE) FROM SALARY);


--7: Определить номера отделов, в которых работали или работают сотрудники,
--   имеющие начисления зарплаты.
SELECT c.deptno
FROM CAREER c
WHERE c.empno IN (SELECT s.empno
                  FROM SALARY s 
                  WHERE s.empno = c.empno
                  AND s.salvalue IS NOT NULL);


--8: Определить номера отделов, в которых работали или работают сотрудники,
--   имеющие начисления зарплаты.
SELECT DEPTNO
FROM DEPT d 
WHERE EXISTS (SELECT DEPTNO 
              FROM CAREER c
              NATURAL JOIN EMP e
              NATURAL JOIN SALARY s
              WHERE d.DEPTNO = c.DEPTNO);
    
    
--9: Определить номера отделов, для сотрудников которых не начислялась зарплата.
SELECT DEPTNO
FROM DEPT d
WHERE NOT EXISTS (SELECT DEPTNO 
                  FROM CAREER c 
                  NATURAL JOIN EMP e
                  NATURAL JOIN SALARY s
                  WHERE d.DEPTNO = c.DEPTNO);


--10: Определить целую часть средних зарплат, по годам начисления.
SELECT YEAR, CAST(AVG(SALVALUE) as int)
FROM SALARY
GROUP BY YEAR;


--12: Разделите сотрудников на возрастные группы: A) возраст 20-30 лет; B) 31-40 лет;
--    C) 41-50; D) 51-60 или возраст не определён.
SELECT EMPNAME,
CASE
     WHEN MONTHS_BETWEEN(SYSDATE, BIRTHDATE)/12 BETWEEN 20 AND 30 THEN 'A'
     WHEN MONTHS_BETWEEN(SYSDATE, BIRTHDATE)/12 BETWEEN 30 AND 40 THEN 'B'
     WHEN MONTHS_BETWEEN(SYSDATE, BIRTHDATE)/12 BETWEEN 40 AND 50 THEN 'C'
     ELSE 'D' END AS AGEGROUP FROM EMP;


--13: Перекодируйте номера отделов, добавив перед номером отдела буквы BI для
--    номеров <=20, буквы LN для номеров >=30.
SELECT DEPTNAME, 
CASE 
    WHEN DEPTNO <= 20 THEN CONCAT('BI', CAST(DEPTNO as VARCHAR(10)))
    WHEN DEPTNO >= 30 THEN CONCAT('LN', CAST(DEPTNO as VARCHAR(10)))
    ELSE CAST(DEPTNO as VARCHAR(10)) END AS DEPTPREFIX FROM DEPT;
    

--14: Выдать информацию о сотрудниках из таблицы EMP, заменив отсутствие данного
--    о дате рождения датой '01-01-1000'.
SELECT e.EMPNO, 
       e.EMPNAME, 
       COALESCE(e.BIRTHDATE, to_date('01-01-1000', 'dd-mm-yyyy')) AS BIRTHDAY
FROM EMP e;
    




