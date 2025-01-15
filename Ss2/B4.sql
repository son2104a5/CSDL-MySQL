create table employees(
	emp_id int primary key,
    emp_name varchar(100) not null,
    emp_started date,
    emp_salary float default 5000
);