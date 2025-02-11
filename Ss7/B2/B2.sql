create table departments (
    department_id int primary key auto_increment,
    department_name varchar(255) not null,
    location varchar(255)
);

create table employees (
    employee_id int primary key auto_increment,
    name varchar(255) not null,
    dob date,
    department_id int,
    salary decimal(10,2),
    foreign key (department_id) references departments(department_id)
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
    project_id int,
    report_date date,
    report_content text,
    foreign key (employee_id) references employees(employee_id),
    foreign key (project_id) references projects(project_id)
);

insert into departments (department_name) values ('it'), ('hr'), ('marketing');

insert into employees (name, dob, department_id, salary) values
('nguyen van a', '1990-05-12', 1, 5000.00),
('tran thi b', '1985-08-24', 2, 4500.00),
('le van c', '1992-11-30', 3, 4800.00);

insert into projects (project_name, start_date, end_date) values
('website redesign', '2024-01-10', '2024-06-15'),
('hr management system', '2024-02-05', '2024-09-30'),
('marketing campaign', '2024-03-12', '2024-08-20');

insert into timesheets (employee_id, project_id, work_date, hours_worked) values
(1, 1, '2024-01-15', 8.00),
(2, 2, '2024-02-10', 7.50),
(3, 3, '2024-03-18', 6.00);

insert into workreports (employee_id, project_id, report_date, report_content) values
(1, 1, '2024-01-20', 'completed initial website layout'),
(2, 2, '2024-02-15', 'finalized hr system requirements'),
(3, 3, '2024-03-25', 'launched first phase of campaign');

update employees set salary = 5500.00 where employee_id = 1;

delete from employees where employee_id = 2;
