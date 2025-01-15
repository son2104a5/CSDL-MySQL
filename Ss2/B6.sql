create table employees(
	emp_id int primary key,
    emp_name varchar(100) not null,
    emp_started date,
    emp_salary float default 5000
);

insert into employees (emp_id, emp_name, emp_started, emp_salary)
values 
    (1, 'Nguyen Van A', '2025-01-01', 6000),
    (2, 'Tran Thi B', '2025-01-10', 5500),
    (3, 'Le Van C', '2025-01-15', 5200);

update employees
set emp_salary = 7000
where emp_id = 1;

delete from employees
where emp_id = 3;