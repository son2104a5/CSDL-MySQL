-- Tạo bảng employees
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY, 
    full_name VARCHAR(100) NOT NULL,            
    position VARCHAR(50) NOT NULL,              
    salary DECIMAL(10, 2) NOT NULL,             
    hire_date DATE NOT NULL,                    
    department VARCHAR(50) NOT NULL            
);

-- Thêm bản ghi vào employees
INSERT INTO employees (full_name, position, salary, hire_date, department)
VALUES
('Nguyen Van An', 'Software Engineer', 15000000.00, '2022-05-01', 'IT'),
('Tran Thi Bich', 'HR Specialist', 12000000.00, '2021-03-15', 'Human Resources'),
('Le Van Cuong', 'Sales Manager', 18000000.00, '2020-11-20', 'Sales'),
('Pham Minh Hoang', 'Marketing Specialist', 14000000.00, '2023-01-10', 'Marketing'),
('Do Thi Ha', 'Accountant', 13000000.00, '2021-07-25', 'Finance'),
('Hoang Quang Huy', 'Project Manager', 20000000.00, '2019-06-05', 'IT');

select
	e.full_name, e.position, e.salary
from employees e
where e.salary > (select avg(e.salary) from employees e);

select
	full_name, department
from employees
where department in ( select department from employees group by department having count(employee_id) >= 2 );

select
	full_name, department, salary
from employees
where (department, salary) in ( select department, max(salary) from employees group by department );

select
	full_name, department, hire_date
from employees
where (department, hire_date) in ( select department, min(hire_date) from employees group by department );