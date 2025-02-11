create table employees (
    employee_id int primary key auto_increment,
    name varchar(255) not null,
    dob date not null,
    department_id int,
    salary decimal(10,2) not null
);

create table departments (
    department_id int primary key auto_increment,
    department_name varchar(255) not null,
    location varchar(255)
);

create table projects (
    project_id int primary key auto_increment,
    project_name varchar(255) not null,
    start_date date,
    end_date date
);

create table timesheets (
    timesheet_id int primary key auto_increment,
    employee_id int,
    project_id int,
    work_date date,
    hours_worked decimal(5,2),
    foreign key (employee_id) references employees(employee_id),
    foreign key (project_id) references projects(project_id)
);

create table workreports (
    report_id int primary key auto_increment,
    employee_id int,
    report_date date,
    report_content text,
    foreign key (employee_id) references employees(employee_id)
);

-- Insert sample data into Departments table
INSERT INTO Departments (department_id, department_name, location) VALUES
(1, 'IT', 'Building A'),
(2, 'HR', 'Building B'),
(3, 'Finance', 'Building C');
-- Insert sample data into Employees table
INSERT INTO Employees (employee_id, name, dob, department_id, salary) VALUES
(1, 'Alice Williams', '1985-06-15', 1, 5000.00),
(2, 'Bob Johnson', '1990-03-22', 2, 4500.00),
(3, 'Charlie Brown', '1992-08-10', 1, 5500.00),
(4, 'David Smith', '1988-11-30', NULL, 4700.00);
-- Insert sample data into Projects table
INSERT INTO Projects (project_id, project_name, start_date, end_date) VALUES
(1, 'Project A', '2025-01-01', '2025-12-31'),
(2, 'Project B', '2025-02-01', '2025-11-30');
-- Insert sample data into WorkReports table
INSERT INTO WorkReports (report_id, employee_id, report_date, report_content) VALUES
(1, 1, '2025-01-31', 'Completed initial setup for Project A.'),
(2, 2, '2025-02-10', 'Completed HR review for Project A.'),
(3, 3, '2025-01-20', 'Worked on debugging and testing for Project A.'),
(4, 4, '2025-02-05', 'Worked on financial reports for Project B.'),
(5, NULL, '2025-02-15', 'No report submitted.');
-- Insert sample data into Timesheets table
INSERT INTO Timesheets (timesheet_id, employee_id, project_id, work_date, hours_worked) VALUES
(1, 1, 1, '2025-01-10', 8),
(2, 1, 2, '2025-02-12', 7),
(3, 2, 1, '2025-01-15', 6),
(4, 3, 1, '2025-01-20', 8),
(5, 4, 2, '2025-02-05', 5);

select e.name, d.department_name 
from employees e 
join departments d on e.department_id = d.department_id 
order by e.name;

select name, salary 
from employees 
where salary > 5000 
order by salary desc;

select e.name, coalesce(sum(t.hours_worked), 0) as total_hours 
from employees e 
left join timesheets t on e.employee_id = t.employee_id 
group by e.name;

select d.department_name, coalesce(avg(e.salary), 0) as avg_salary 
from departments d 
left join employees e on d.department_id = e.department_id 
group by d.department_name;

select p.project_name, coalesce(sum(t.hours_worked), 0) as total_hours 
from projects p 
join timesheets t on p.project_id = t.project_id 
where month(t.work_date) = 2 and year(t.work_date) = 2025 
group by p.project_name;

select e.name, p.project_name, coalesce(sum(t.hours_worked), 0) as total_hours 
from employees e 
join timesheets t on e.employee_id = t.employee_id 
join projects p on t.project_id = p.project_id 
group by e.name, p.project_name;

select d.department_name, count(e.employee_id) as employee_count 
from departments d 
join employees e on d.department_id = e.department_id 
group by d.department_name 
having count(e.employee_id) > 1;

select w.report_date, e.name, w.report_content 
from workreports w 
join employees e on w.employee_id = e.employee_id 
order by w.report_date desc 
limit 2 offset 1;

select w.report_date, e.name, count(*) as report_count 
from workreports w 
join employees e on w.employee_id = e.employee_id 
where w.report_content is not null and w.report_date between '2025-01-01' and '2025-02-01' 
group by w.report_date, e.name;

select e.name, p.project_name, sum(t.hours_worked) as total_hours, round(sum(t.hours_worked * e.salary), 2) as total_salary 
from employees e 
join timesheets t on e.employee_id = t.employee_id 
join projects p on t.project_id = p.project_id 
group by e.name, p.project_name 
having sum(t.hours_worked) > 5 
order by total_salary desc;
