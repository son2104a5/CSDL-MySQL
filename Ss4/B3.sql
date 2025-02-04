create database customer_mangement;
use customer_mangement;

create table Customer (
	customer_id int auto_increment primary key,
    customer_name varchar(50) not null,
    birthday date not null,
    sex bit not null,
    job varchar(50),
    phone_number char(11) not null unique,
    email varchar(100) not null unique,
    address varchar(255) not null
);

insert into Customer (customer_name, birthday, sex, job, phone_number, email, address)
values
    ('Nguyen Van A', '1990-05-15', 1, 'Software Engineer', '0987654321', 'nguyenvana@example.com', '123 Nguyen Trai, Hanoi'),
    ('Tran Thi B', '1985-09-20', 0, 'Doctor', '0978123456', 'tranthib@example.com', '45 Le Loi, Ho Chi Minh City'),
    ('Le Van C', '1992-12-10', 1, 'Teacher', '0967345678', 'levanc@example.com', '67 Tran Hung Dao, Da Nang'),
    ('Pham Thi D', '1998-07-25', 0, 'Marketing Specialist', '0945123890', 'phamthid@example.com', '89 Pasteur, Can Tho'),
    ('Hoang Van E', '1995-03-18', 1, 'Graphic Designer', '0934567890', 'hoangvane@example.com', '101 Vo Van Kiet, Hue'),
    ('Do Thi F', '1987-11-05', 0, 'Nurse', '0923456789', 'dothif@example.com', '54 Bach Dang, Nha Trang'),
    ('Bui Van G', '2000-04-30', 1, 'Student', '0912345678', 'buivang@example.com', '23 Phan Chu Trinh, Hai Phong'),
    ('Ngo Thi H', '1993-08-12', 0, 'Accountant', '0901122334', 'ngothih@example.com', '77 Tran Phu, Da Lat'),
    ('Vu Van I', '1989-02-17', 1, 'Entrepreneur', '0899233445', 'vuvani@example.com', '35 Ly Tu Trong, Vung Tau'),
    ('Dang Thi J', '1997-06-28', 0, 'Receptionist', '0888123456', 'dangthij@example.com', '90 Cach Mang Thang 8, Binh Duong');

update customer
set customer_name = 'Nguyễn Quang Nhật' where customer_id = 1;

delete from Customer where month(birthday) = 8;

select customer_id, 
       customer_name, 
       birthday, 
       case 
           when sex = 1 then 'Nam' 
           else 'Nữ' 
       end as gender, 
       phone_number
from Customer
where birthday > '2000-01-01';

select * from customer where job is NULL;
