--1: Создайте представление, содержащее данные о сотрудниках пенсионного возраста.
create or replace view elderly_emps as (
    select *
    from emp 
    where birthdate is not null 
    and add_months(sysdate, -12*63) >= birthdate);

--select add_months(sysdate, -12*63) as threshold_date from dual;

--select * from elderly_emps;

--insert into elderly_emps values 
    --(9090, 'ivan', to_date('19-07-1949', 'dd-mm-yyyy'), null);   

--update elderly_emps set empname = 'ivan ivanov'
--where empname = 'ivan';
    
--select * from elderly_emps;
--select * from emp;

--delete elderly_emps where empname = 'ivan ivanov';
--select * from elderly_emps;
--select * from emp;


--2: Создайте представление, содержащее данные об уволенных сотрудниках: 
--   имя сотрудника, дата увольнения, отдел, должность.
create or replace view dismissal_emps as (
    select 
        empno,
        empname,
        deptno,
        jobno,
        enddate
    from emp
    natural join career
    where enddate is not null
);

--select * from dismissal_emps;

--insert into dismissal_emps values 
    --(9090, 'ivan', 10, 1000, to_date('19-07-2020', 'dd-mm-yyyy'));
    
--update dismissal_emps set empname = 'ivan ivanov'
--where empname = 'ivan';

--delete dismissal_emps where empname = 'ivan ivanov';


--3: Создайте представление, содержащее имя сотрудника, должность, занимаемую 
--   сотрудником в данный момент, суммарную заработную плату сотрудника за 
--   третий квартал 2010 года. Первый столбец назвать Sotrudnik, второй – 
--   Dolzhnost, третий – Itogo_3_kv.
create or replace view otchet_3_kv as (
    select 
        empname as Sotrudnik, 
        jobname as Dolzhnost, 
        sum(salvalue) as Itogo_3_kv
    from salary 
    natural join emp
    natural join career
    natural join job
    where enddate is null 
    and year = 2010
    and month between 7 and 9
    group by empname, jobname
);

--select * from otchet_3_kv;

--insert into otchet_3_kv values
    --('ivan', 'manager', 12000);
    
--update otchet_3_kv set Itogo_3_kv = 13000
--where Itogo_3_kv < 13000;

--delete otchet_3_kv where Sotrudnik = 'ALLEN';

--select * from otchet_3_kv;


--4: На основе представления из задания 2 и таблицы SALARY создайте представление, 
--  содержащее данные об уволенных сотрудниках, которым зарплата начислялась 
--  более 2 раз. В созданном представлении месяц начисления зарплаты и сумма 
--  зарплаты вывести в одном столбце, в качестве разделителя использовать запятую.
create or replace view dismissal_2 as (
    select 
        d.empname,
        d.deptno,
        d.jobno,
        d.enddate,
        s.month || ', ' || s.salvalue as month_salary
    from dismissal_emps d
    join salary s on d.empno = s.empno
    where (select count(*) 
           from salary inner_sal 
           where inner_sal.empno = s.empno) > 2
);

select * from dismissal_2;

insert into dismissal_2 values
    ('ivan', 10, 1001, to_date('10-10-2010', 'dd-mm-yyyy'), 8 || ', ' || 1200);
    
update dismissal_2 set deptno = 10;

delete dismissal_2 where jobno = 1001;















