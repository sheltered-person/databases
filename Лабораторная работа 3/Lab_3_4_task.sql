--1: Требуется используя значения столбца START_DATE получить дату за десять дней
--   до и после приема на работу, пол года до и после приема на работу, год до и после
--   приема на работу сотрудника JOHN KLINTON.
SELECT 
    e.EMPNAME, 
    c.STARTDATE, 
    c.STARTDATE-10 AS DAYS_BEFORE,
    c.STARTDATE+10 AS DAYS_AFTER,
    ADD_MONTHS(c.STARTDATE, -6) AS HALF_YEAR_BEFORE,
    ADD_MONTHS(c.STARTDATE, 6) AS HALF_YEAR_AFTER,
    ADD_MONTHS(c.STARTDATE, -12) AS YEAR_BEFORE,
    ADD_MONTHS(c.STARTDATE, 12) AS YEAR_AFTER
FROM CAREER c NATURAL JOIN EMP e
WHERE e.EMPNAME = 'JOHN KLINTON';


--2: Требуется найти разность между двумя датами и представить результат в днях.
--   Вычислите разницу в днях между датами приема на работу сотрудников JOHN
--   MARTIN и ALEX BOUSH.
SELECT
    MAX_DATE - MIN_DATE AS DAYS_BETWEEN
FROM 
    (SELECT 
         MAX(c.STARTDATE) AS MAX_DATE, 
         MIN(c.STARTDATE) AS MIN_DATE
     FROM CAREER c NATURAL JOIN EMP e 
     WHERE e.EMPNAME IN ('JOHN MARTIN', 'ALEX BOUSH'));


--3: Требуется найти разность между двумя датами в месяцах и в годах.
SELECT
    TRUNC(MONTHS_BETWEEN(MAX_DATE, MIN_DATE) / 12) AS YEARS,
    TRUNC(MONTHS_BETWEEN(MAX_DATE, MIN_DATE)) AS MONTHS
FROM 
    (SELECT 
         MAX(c.STARTDATE) AS MAX_DATE, 
         MIN(c.STARTDATE) AS MIN_DATE
     FROM CAREER c NATURAL JOIN EMP e 
     WHERE e.EMPNAME IN ('JOHN MARTIN', 'ALEX BOUSH'));  
     

--4: Требуется определить интервал времени в днях между двумя датами. Для каждого
--   сотрудника 20-го отделе найти сколько дней прошло между датой его приема на
--   работу и датой приема на работу следующего сотрудника.
SELECT 
    e.EMPNAME, 
    c.STARTDATE,
    LEAD(c.STARTDATE) OVER(ORDER BY STARTDATE) NEXT_EMP_DATE
FROM CAREER c
NATURAL JOIN EMP e
WHERE c.DEPTNO = 20
ORDER BY c.STARTDATE;


--5:Требуется подсчитать количество дней в году по столбцу START_DATE.
--  Используйте функцию TRUNC для нахождения начала года, а ADD_MONTHS – для
--  нахождения начала следующего года.
SELECT ADD_MONTHS(TRUNC(STARTDATE), 12) - TRUNC(STARTDATE) AS DAYS_IN_YEAR
FROM CAREER;


--6: Требуется разложить текущую дату на день, месяц, год, секунды, минуты, часы.
--   Результаты вернуть в численном виде.
--   Используйте функции TO_CHAR и TO_NUMBER; форматы ‘hh24’, ‘mi’, ‘ss’, ‘dd’,
--   ‘mm’, ‘yyyy’ для секунд, минут, часов, дней, месяцев, лет соответственно.
SELECT 
    TO_NUMBER(TO_CHAR(SYSDATE, 'dd')) AS DAYS,
    TO_NUMBER(TO_CHAR(SYSDATE, 'mm')) AS MONTH,
    TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy')) AS YEAR,
    TO_NUMBER(TO_CHAR(SYSDATE, 'ss')) AS SECONDS,
    TO_NUMBER(TO_CHAR(SYSDATE, 'mi')) AS MINUTES,
    TO_NUMBER(TO_CHAR(SYSDATE, 'hh24')) AS HOURS
FROM DUAL;


--7: Требуется получить первый и последний дни текущего месяца.
--   Используйте функцию LAST_DAY.
SELECT 
    SYSDATE, 
    LAST_DAY(SYSDATE) AS LAST, 
    TRUNC(SYSDATE, 'MONTH') AS FIRST
FROM DUAL;


--8: Требуется возвратить даты начала и конца каждого из четырех кварталов данного
--   года. С помощью функции ADD_MONTHS найдите начальную и конечную даты каждого
--   квартала. Для представления квартала, которому соответствует та или иная
--   начальная и конечная даты, используйте псевдостолбец ROWNUM.
SELECT ROWNUM AS QUARTER,
       ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), (ROWNUM - 1) * 3) AS QUARTER_START,
       ADD_MONTHS(TRUNC(SYSDATE, 'YEAR'), ROWNUM * 3) - 1 AS QUARTER_END
FROM DUAL 
CONNECT BY ROWNUM <= 4;


--9: Требуется найти все даты года, соответствующие заданному дню недели.
--   Сформируйте список понедельников текущего года.
SELECT * 
FROM (SELECT (TRUNC(SYSDATE, 'YEAR') + LEVEL - 1)  AS DAY 
             FROM DUAL
             CONNECT BY LEVEL <= 366)
WHERE TO_CHAR(DAY, 'fmday') = 'monday';


--10: Требуется создать календарь на текущий месяц. Календарь должен иметь семь
--    столбцов в ширину и пять строк вниз. 
--    Чтобы возвратить все дни текущего месяца используйте рекурсивный оператор
--    CONNECT_BY. Затем разбейте месяц на недели по выбранному дню с помощью
--    выражений CASE и функций MAX.
select
    max(case week_day when 2 then day_number end) as Mo,
    max(case week_day when 3 then day_number end) as Tu,
    max(case week_day when 4 then day_number end) as We,
    max(case week_day when 5 then day_number end) as Th,
    max(case week_day when 6 then day_number end) as Fr,
    max(case week_day when 7 then day_number end) as Sa,
    max(case week_day when 1 then day_number end) as Su
from
(select 
     to_char(trunc(sysdate, 'mm')+level-1, 'iw') as week_number,
     to_char(trunc(sysdate, 'mm')+level-1, 'dd') as day_number,
     to_number(to_char(trunc(sysdate, 'mm')+level-1, 'd')) as week_day
from dual
connect by level <= 30)
group by week_number
order by week_number;





















