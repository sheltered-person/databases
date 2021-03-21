--1: Выполнить ранжирование сотрудников по значениям средних зарплат за каждый год.
--   Используйте функции RANK и DENSE_RANK.
select 
    empname, 
    year, 
    round(avg_salary, 2) as avg_sal, 
    dense_rank() over (partition by year order by avg_salary desc) as salary_rank 
from (
    select 
        empno, 
        year, 
        avg(salvalue) as avg_salary
    from salary
    group by empno, year
) natural join emp;


--2: Выведите результирующее множество, отражающее распределение заработных 
--   плат по отделам, чтобы можно было увидеть, какая из должностей обходится компании дороже всего.
--   Используйте функцию RATIO_TO_REPORT.
select 
    deptname, 
    num_emps, 
    sum(round(pct, 2)) || '%' as pct_of_all_salaries
from (
    select 
        deptname, 
        count(*) over (partition by deptname) as num_emps,
        ratio_to_report(salvalue) over () * 100 as pct
    from emp 
        natural join career 
        natural join dept 
        natural join salary
    where enddate is null
) group by deptname, num_emps;


--3: Составьте запросы, которые будут выполнять подсчет долей с 
--   помощью функций CUME_DIST, PERCENT_RANK.
select distinct
       year, 
       month, 
       empname, 
       salvalue, 
       round(cume_dist() over (partition by year order by salvalue), 2) as cume_dist,
       round(percent_rank() over (partition by year order by salvalue), 2) as pct_rank
from salary natural join emp
order by year, salvalue;


--4: Требуется организовать данные в одинаковые по размеру блоки с преопределенным 
--   количеством элементов в каждом блоке. Общее количество блоков неизвестно, 
--   но каждый из них должен содержать одинаковое число элементов. 
--   Например, необходимо организовать сотрудников из таблицы EMP 
--   в группы по три на основании значения EMPNO
select 
    ceil(row_number() over (order by empno) / 3.0) as fix_group,
    empno, 
    empname
from emp;


--5: Требуется организовать данные в определенное число блоков. 
--   Например, записи таблицы EMP должны быть разделены на три группы.
select 
    ntile(3) over (order by empno) fix_group,
    empno, 
    empname
from emp
order by 1;


--6: Требуется создать горизонтальную гистограмму: отобразить количество 
--   служащих в каждом отделе в виде горизонтальной гистограммы, в которой каждый 
--   служащий представлен экземпляром символа «*».
select 
    deptno, 
    lpad('*', count(*), '*') as emp_count
from career
group by deptno
order by emp_count;


--7: Требуется создать гистограмму, в которой значения увеличиваются вдоль 
--   оси снизу вверх: отобразить количество служащих в каждом отделе в виде 
--   вертикальной гистограммы, в которой в которой каждый служащий 
--   представлен экземпляром символа «*».
select 
    max(deptno_10) d10,
    max(deptno_20) d20,
    max(deptno_30) d30,
    max(deptno_40) d40
from (
    select 
        row_number() over (partition by deptno order by empno) rn,
        case when deptno = 10 then '*' else null end deptno_10,
        case when deptno = 20 then '*' else null end deptno_20,
        case when deptno = 30 then '*' else null end deptno_30,
        case when deptno = 40 then '*' else null end deptno_40
    from career
) group by rn
order by 
    1 desc, 
    2 desc, 
    3 desc, 
    4 desc;















