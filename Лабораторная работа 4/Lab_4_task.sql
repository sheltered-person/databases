--1: Поднимите нижнюю границу минимальной заработной платы в таблице JOB до 1000$.
update job set minsalary = 1000
where minsalary = (select min(minsalary) from job);


--2: Поднимите минимальную зарплату в таблице JOB на 10% для всех 
--   специальностей, кроме финансового директора.
update job set minsalary = minsalary * 1.1
where not jobname = 'FINANCIAL DIRECTOR';


--3: Поднимите минимальную зарплату в таблице JOB на 10% для клерков и 
--   на 20% для финансового директора (одним оператором).
update job set minsalary = 
    case
        when jobname = 'CLERK' then minsalary * 1.1
        when jobname = 'FINANCIAL DIRECTOR' then minsalary * 1.2
        else minsalary
    end;    
    

--4: Установите минимальную зарплату финансового директора равной 90% 
--   от зарплаты исполнительного директора.
update job set minsalary = 0.9 * (
    select minsalary 
    from job 
    where jobname = 'EXECUTIVE DIRECTOR'
) where jobname = 'FINANCIAL DIRECTOR';


--5: Приведите в таблице EMP имена служащих, начинающиеся на букву ‘J’, 
--   к нижнему регистру.
update emp set empname = lower(empname)
where empname like 'J%';


--6: Измените в таблице EMP имена служащих, состоящие из двух слов, так, 
--   чтобы оба слова в имени начинались с заглавной буквы, а продолжались прописными.
update emp set empname = initcap(empname)
where length(empname) - length(replace(empname, ' ', '')) = 1;


--7: Приведите в таблице EMP имена служащих к верхнему регистру.
update emp set empname = upper(empname);


--8: Перенесите отдел исследований (RESEARCH) в тот же город, в котором 
--   расположен отдел продаж (SALES).
update dept set deptaddr = (select deptaddr from dept where deptname = 'SALES')
where deptname = 'RESEARCH';


--9: Добавьте нового сотрудника в таблицу EMP. Его имя и фамилия должны 
--   совпадать с Вашими, записанными латинскими буквами согласно паспорту, 
--   дата рождения также совпадает с Вашей.
insert into emp values(7799, 'ELISAVETA MOYSEYCHIK', to_date('24-10-1999', 'dd-mm-yyyy'), NULL);


--10: Определите нового сотрудника (см. предыдущее задание) на работу 
--    в бухгалтерию (отдел ACCOUNTING) начиная с текущей даты.
insert into career values (
    (select jobno from job where jobname = 'CLERK'), 
    (select empno from emp where empname = 'ELISAVETA MOYSEYCHIK'), 
    (select deptno from dept where deptname = 'ACCOUNTING'), 
    to_date(sysdate, 'dd-mm-yyyy'), 
    NULL);

--11: Удалите все записи из таблицы TMP_EMP. Добавьте в нее информацию о 
--    сотрудниках, которые работают клерками в настоящий момент.
delete from tmp_emp;

insert into tmp_emp
    select * 
    from emp 
    where empno in(
        select empno 
        from emp 
        natural join career 
        natural join job 
        where jobname = 'CLERK' and enddate is NULL);
        
--12: Добавьте в таблицу TMP_EMP информацию о тех сотрудниках, которые уже 
--    не работают на предприятии, а в период работы занимали только одну должность.
delete from tmp_emp;

insert into tmp_emp
select * from emp e
where e.empno in
(select out_emp.empno
from emp out_emp join career out_career on out_emp.empno = out_career.empno
where out_career.enddate is not null and (
    select count(*) 
    from career in_career
    where out_emp.empno = in_career.empno
    and in_career.enddate is not null
    and in_career.startdate between out_career.startdate and out_career.enddate) = 1
    and (select count(*) 
         from career in2_career
         where out_emp.empno = in2_career.empno and in2_career.enddate is null) = 0);


--13: Выполните тот же запрос для тех сотрудников, которые никогда не приступали
--    к работе на предприятии.
delete from tmp_emp;

insert into tmp_emp
    select * from emp
    where empno in (
        select empno 
        from emp out_emp
        where (select count(*) from career where career.empno = out_emp.empno) = 0
    );


--14: Удалите все записи из таблицы TMP_JOB и добавьте в нее информацию 
--    по тем специальностям, которые не используются в настоящий момент на предприятии.
delete from tmp_job;

insert into tmp_job
    select * from job
    where jobno in (
        select jobno
        from job out_job
        where (select count(*) 
               from career c 
               where c.enddate is null 
               and out_job.jobno = c.jobno) = 0
    );


--15: Начислите зарплату в размере 120% минимального должностного оклада всем 
--    сотрудникам, работающим на предприятии. Зарплату начислять по должности, 
--    занимаемой сотрудником в настоящий момент и отнести ее на прошлый месяц 
--    относительно текущей даты.
insert into salary
    select 
        empno,
        extract(month from add_months(sysdate, -1)) as month,
        extract(year from add_months(sysdate, -1)) as year,
        minsalary * 1.2 as salvalue
    from career
    join job using(jobno)
    where enddate is null;


--16: Удалите данные о зарплате за прошлый год.
delete from salary
where year = extract(year from sysdate) - 1;


--17: Удалите информацию о карьере сотрудников, которые в настоящий момент уже 
--    не работают на предприятии, но когда-то работали.
delete from career
where enddate is not null;


--18: Удалите информацию о начисленной зарплате сотрудников, которые в настоящий 
--    момент уже не работают на предприятии (можно использовать результаты 
--    работы предыдущего запроса).
delete from salary
where empno not in (
    select empno from career group by empno
);


--19: Удалите записи из таблицы EMP для тех сотрудников, которые никогда 
--    не приступали к работе на предприятии.
delete from emp
where empno not in (
    select empno from career
);













