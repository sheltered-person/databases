--1: Рефлексивное соединение. Требуется представить имя каждого 
--   сотрудника таблицы EMP, а также имя его руководителя.
SELECT (e.EMPNAME || ' works for ' || m.EMPNAME) AS WORKS_FOR
FROM EMP e 
JOIN EMP m 
ON e.MANAGER_ID = m.EMPNO;


--2: Требуется представить имя каждого сотрудника таблицы EMP (даже сотрудника,
--   которому не назначен руководитель) и имя его руководителя. 
--   Используйте ключевые слова иерархических запросов START WITH, CONNECT BY PRIOR.
SELECT EMPNAME || ' reports to ' || PRIOR EMPNAME AS WORK_TOP_DOWN
FROM EMP
START WITH MANAGER_ID IS NULL 
CONNECT BY PRIOR EMPNO = MANAGER_ID;


--3: Требуется показать иерархию от CLARK до JOHN KLINTON: 
--   Используйте функцию SYS_CONNECT_BY_PATH получите CLARK и его
--   руководителя ALLEN, затем руководителя ALLEN ― JOHN KLINTON. А также
--   ключевые слова иерархических запросов LEVEL, START WITH, CONNECT BY
--   PRIOR; функцию LTRIM.
SELECT LTRIM(SYS_CONNECT_BY_PATH(LEVEL || ' ' || EMPNAME, '->'), '->') 
AS LEAF_BRANCH_ROOT
FROM EMP
WHERE EMPNAME = 'JOHN KLINTON'
START WITH EMPNAME = 'CLARK'
CONNECT BY EMPNO = PRIOR MANAGER_ID;


--4: Требуется получить результирующее множество, описывающее иерархию всей
--   таблицы.
SELECT LTRIM(SYS_CONNECT_BY_PATH(EMPNAME, '->'), '->') 
AS LEAF_BRANCH_ROOT
FROM EMP
START WITH EMPNAME = 'JOHN KLINTON'
CONNECT BY PRIOR EMPNO = MANAGER_ID;


--5: Требуется показать уровень иерархии каждого сотрудника.
--   Используйте ключевые слова иерархических запросов LEVEL, START WITH,
--   CONNECT BY PRIOR; функцию LPAD.
SELECT LPAD(EMPNAME, LENGTH(EMPNAME) + (LEVEL * 2) - 2, '*') 
AS ORG_CHART
FROM EMP
START WITH EMPNAME = 'JOHN KLINTON'
CONNECT BY PRIOR EMPNO = MANAGER_ID;


--6: Требуется найти всех служащих, которые явно или неявно подчиняются ALLEN.
SELECT EMPNAME
FROM EMP
START WITH EMPNAME = 'ALLEN'
CONNECT BY PRIOR EMPNO = MANAGER_ID;



















