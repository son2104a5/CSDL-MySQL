create database tbl;
use tbl;

create table tbl_users (
    user_id int auto_increment primary key,
    user_name varchar(50) not null unique,
    user_fullname varchar(100) not null,
    user_address text,
    user_phone varchar(20) not null unique
);

create table tbl_employees (
    emp_id char(5) primary key,
    user_id int unique,
    emp_position varchar(50),
    emp_hire_date date,
    salary decimal(10,2) not null check (salary > 0),
    emp_status enum('Đang làm', 'Đang nghỉ') default 'Đang làm',
    foreign key (user_id) references tbl_users(user_id)
);

create table tbl_orders (
    order_id int auto_increment primary key,
    user_id int,
    order_date date,
    order_total_amount decimal(10,2),
    order_status enum('Pending', 'Processing', 'Completed', 'Cancelled') default 'Pending',
    foreign key (user_id) references tbl_users(user_id)
);

create table tbl_products (
    pro_id char(5) primary key,
    pro_name varchar(100) not null unique,
    pro_price decimal(10,2) not null check (pro_price > 0),
    pro_quantity int not null,
    pro_status enum('Còn hàng', 'Hết hàng') default 'Còn hàng'
);

create table tbl_order_detail (
    order_detail_id int auto_increment primary key,
    order_id int,
    pro_id char(5),
    order_detail_quantity int check (order_detail_quantity > 0),
    order_detail_price decimal(10,2),
    foreign key (order_id) references tbl_orders(order_id),
    foreign key (pro_id) references tbl_products(pro_id)
);

alter table tbl_orders add column order_status enum('Pending', 'Processing', 'Completed', 'Cancelled') default 'Pending';

alter table tbl_users modify column user_phone varchar(11);

alter table tbl_users drop column email;

insert into tbl_users (user_id, user_name, user_fullname, user_address, user_phone) 
values
(1, 'nguyen_van_a', 'Nguyễn Văn A', 'Hà Nội', '01234567890'),
(2, 'tran_thi_b', 'Trần Thị B', 'TP. Hồ Chí Minh', '09876543210'),
(3, 'admin_user', 'Quản trị viên', 'Đà Nẵng', '01122334455');

insert into tbl_employees (emp_id, user_id, emp_position, emp_hire_date, salary, emp_status)
values
('E0001', 3, 'Quản lý', '2023-01-15', 5000, 'Đang làm'),
('E0002', 4, 'Nhân viên bán hàng', '2023-05-10', 3500, 'Đang làm'),
('E0003', 5, 'Nhân viên kho', '2024-02-20', 4000, 'Đang nghỉ');

insert into tbl_products (pro_id, pro_name, pro_price, pro_quantity, pro_status)
values
('P0001', 'Laptop Dell', 20000000, 10, 'Còn hàng'),
('P0002', 'Điện thoại iPhone', 25000000, 5, 'Còn hàng'),
('P0003', 'Chuột Logitech', 500000, 20, 'Còn hàng');

insert into tbl_orders (order_id, user_id, order_date, order_total_amount, order_status)
values
(1, 1, '2024-01-10', 20500000, 'Completed'),
(2, 2, '2024-01-15', 25000000, 'Pending'),
(3, 1, '2024-02-01', 500000, 'Processing');

insert into tbl_order_detail (order_detail_id, order_id, pro_id, order_detail_quantity, order_detail_price)
values
(1, 1, 'P0001', 1, 20000000),
(2, 2, 'P0002', 1, 25000000),
(3, 3, 'P0003', 1, 500000);

select order_id, order_date, order_total_amount, order_status 
from tbl_orders;

select distinct u.user_fullname
from tbl_users u
join tbl_orders o on u.user_id = o.user_id;

select p.pro_name, sum(od.order_detail_quantity) as total_sold
from tbl_order_detail od
join tbl_products p on od.pro_id = p.pro_id
group by p.pro_name;

select p.pro_name, sum(od.order_detail_quantity * od.order_detail_price) as revenue
from tbl_order_detail od
join tbl_products p on od.pro_id = p.pro_id
group by p.pro_name
order by revenue desc;

select u.user_fullname, count(o.order_id) as total_orders
from tbl_users u
join tbl_orders o on u.user_id = o.user_id
group by u.user_fullname;

select u.user_fullname, count(o.order_id) as total_orders
from tbl_users u
join tbl_orders o on u.user_id = o.user_id
group by u.user_fullname
having total_orders >= 2;

select u.user_fullname, sum(o.order_total_amount) as total_spent
from tbl_users u
join tbl_orders o on u.user_id = o.user_id
group by u.user_fullname
order by total_spent desc
limit 5;

select e.emp_id, u.user_fullname, e.emp_position, count(o.order_id) as total_orders
from tbl_employees e
join tbl_users u on e.user_id = u.user_id
left join tbl_orders o on u.user_id = o.user_id
group by e.emp_id, u.user_fullname, e.emp_position;

select u.user_fullname, max(o.order_total_amount) as max_order
from tbl_users u
join tbl_orders o on u.user_id = o.user_id
group by u.user_fullname
order by max_order desc
limit 1;

select p.pro_id, p.pro_name, p.pro_quantity
from tbl_products p
left join tbl_order_detail od on p.pro_id = od.pro_id
where od.order_id is null;

select p.pro_id, p.pro_name, p.pro_quantity
from tbl_products p
left join tbl_order_detail od on p.pro_id = od.pro_id
where od.order_id is null;
