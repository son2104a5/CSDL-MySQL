create database employee_management;

use employee_management;

create table employee (
    employee_id char(4) primary key,
    employee_name varchar(50) not null,
    date_of_birth date,
    sex bit not null,
    base_salary int not null check (base_salary > 0),
    phone_number char(11) not null unique
);

create table department (
    department_id int primary key auto_increment,
    department_name varchar(50) not null unique,
    address varchar(50) not null
);

alter table employee 
add column department_id int not null;

alter table employee 
add constraint fk_employee_department 
foreign key (department_id) references department(department_id);

insert into department (department_name, address) 
values
('Kế toán', 'Tầng 2, Tòa nhà A'),
('Nhân sự', 'Tầng 3, Tòa nhà B'),
('IT', 'Tầng 5, Tòa nhà C'),
('Marketing', 'Tầng 4, Tòa nhà D'),
('Kinh doanh', 'Tầng 6, Tòa nhà E');

insert into employee (employee_id, employee_name, date_of_birth, sex, base_salary, phone_number, department_id) 
values
('E001', 'Nguyễn Minh Nhật', '2004-12-11', 1, 4000000, '0987836473', 1),
('E002', 'Đỗ Đức Long', '2004-01-12', 1, 3500000, '0982378673', 2),
('E003', 'Mai Tiến Linh', '2004-02-03', 1, 3500000, '0976734562', 3),
('E004', 'Nguyễn Ngọc Ánh', '2004-10-04', 0, 5000000, '0987352772', 4),
('E005', 'Phạm Minh Sơn', '2003-12-03', 1, 4000000, '0987236568', 5),
('E006', 'Nguyễn Ngọc Minh', '2003-11-11', 0, 5000000, '0928864736', 1),
('E007', 'Trần Văn Bình', '2002-09-15', 1, 4500000, '0912345678', 2),
('E008', 'Lê Thanh Hương', '2002-07-22', 0, 4800000, '0934567890', 3),
('E009', 'Phạm Quang Huy', '2001-05-30', 1, 5500000, '0978456123', 4),
('E010', 'Đinh Thị Hoa', '2000-03-18', 0, 6000000, '0961237894', 5);

alter table employee drop foreign key fk_employee_department;

alter table employee 
add constraint employee_department_fk foreign key (department_id) 
references department(department_id) 
on delete cascade;

delete from department where department_id = 1;

update department
set department_name = 'Phòng Kế Toán'
where department_id = 1;

select * from employee;
select * from department;