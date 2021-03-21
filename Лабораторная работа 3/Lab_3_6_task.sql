--1: Получить результирующее множество, содержащее количество сотрудников в
--   каждом отделе, а также общее количество сотрудников.
select 
    case grouping(deptname)
        when 0 then deptname
        else 'Total'
    end deptname,
    count(empno)
from career join dept using(deptno)
group by rollup(deptname);


--2: Требуется найти количество сотрудников по отделам, по должностям и для
--   каждого сочетания DEPTNAME/JOBNAME.
select deptname, jobname,
    case grouping(deptname) || grouping(jobname)
        when '00' then 'total by (dept, job)'
        when '10' then 'total by job'
        when '01' then 'total by dept'
        when '11' then 'grand total for table'
    end category,
    count(empno) emps_count
from emp 
    join career using(empno)
    join job using(jobno)
    join dept using(deptno)
group by cube(deptname, jobname)
order by grouping(deptname), grouping(jobname);


-- 3: Требуется найти среднее значение суммы всех заработных плат по отделам, по
--    должностям и для каждого сочетания DEPTNAME/JOBNAME.
select deptname, jobname,
    case grouping(deptname) || grouping(jobname)
        when '00' then 'total by (dept, job)'
        when '10' then 'total by job'
        when '01' then 'total by dept'
        when '11' then 'grand total for table'
    end category,
    round(avg(salvalue), 3) avg_salary
from emp 
    join career using(empno)
    join salary using(empno)
    join job using(jobno)
    join dept using(deptno)
group by cube(deptname, jobname)
order by grouping(deptname), grouping(jobname);


--4: Создайте запрос на распознавание строк, сформированных оператором GROUP
--   BY, и строк, являющихся результатом выполнения CUBE.
select 
    deptname, 
    jobname, 
    count(empno) emps_count, 
    grouping(deptname) dept_subtotal,
    grouping(jobname) job_subtotal
from emp 
    join career using(empno)
    join job using(jobno)
    join dept using(deptno)
group by cube(deptname, jobname);


--5: Создайте запрос, использующий расширение GROUPING SET оператора GROUP BY.
SELECT 
    deptno, 
    jobno, 
    manager_id, 
    round(avg(salvalue), 3) as avg_salary
from career
    join dept using(deptno)
    join emp using(empno)
    join job using(jobno)
    join salary using(empno)
group by grouping sets
    ((jobno, manager_id),
    (deptno, jobno),
    (deptno, manager_id));
    
    
--6: Создайте запросы по заданиям пунктов 4-6.   

-- Требуется выполнить агрегацию «в разных измерениях» одновременно. Например,
-- необходимо получить результирующее множество, в котором для каждого
-- сотрудника указаны имя, отдел, количество сотрудников в отделе (включая его
-- самого), количество сотрудников, занимающих ту же должность, что и этот
-- сотрудник (включая его самого), и общее число сотрудников в таблице.

-- Используйте оконную функцию COUNT OVER, задавая разные группы данных, для
-- которых проводится агрегация.
select 
    empname,
    deptname,
    count(empno) over (partition by deptno) as deptname_emps_count,
    jobname,
    count(empno) over (partition by jobno) as jobname_emp_cnt,
    count(*) over () as total
from career
    join emp using(empno)
    join job using(jobno)
    join dept using(deptno);
    

-- Требуется выполнить скользящую агрегацию, например найти скользящую сумму
-- заработных плат. Вычислять сумму для каждого интервала в 90 день, начиная с даты
-- приема на работу (поле STARTDATE таблицы CAREER) первого сотрудника, чтобы
-- увидеть динамику изменения расходов для каждого 90-дневного периода между
-- датами приема на работу первого и последнего сотрудника.

-- Используйте функции SUM OVER, оператор ORDER BY и RANGE BETWEEN 90
-- PRECEDING AND CURRENT ROW.
select 
    startdate, 
    salvalue, 
    sum(salvalue) over (
        partition by startdate 
        order by startdate 
        rows between 90 preceding and current row) as spending_pattern
from career natural join salary
order by startdate;


-- Требуется вывести множество числовых значений, представив каждое из них как
-- долю от целого в процентном выражении. Например, требуется получить
-- результирующее множество, отражающее распределение заработных плат по
-- должностям, чтобы можно было увидеть, какая из позиций JOB обходится компании
-- дороже всего.

-- Используйте оконную функцию COUNT OVER и RATIO_TO_REPORT.
select 
    jobname,
    num_emps,
    sum(round((pct), 2)) || '%' pct_of_all_salaries
from (
    select 
        jobname, 
        count(empno) over (partition by jobno) num_emps,
        ratio_to_report(salvalue)over()*100 pct
    from emp 
        join career using(empno) 
        join job using(jobno)
        join salary using(empno)
    where enddate is null
)
group by jobname, num_emps; 

















