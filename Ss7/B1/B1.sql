create database ss7;
use ss7;

create table categories (
    category_id int primary key auto_increment,
    category_name varchar(255) not null
);

create table books (
    book_id int primary key auto_increment,
    title varchar(255) not null,
    author varchar(255) not null,
    publication_year int,
    quantity int,
    category_id int,
    foreign key (category_id) references categories(category_id)
);

create table readers (
    reader_id int primary key auto_increment,
    full_name varchar(255) not null,
    phone_number varchar(20),
    email varchar(255) unique not null
);

create table borrowing (
    borrow_id int primary key auto_increment,
    reader_id int,
    book_id int,
    borrow_date date,
    return_date date,
    foreign key (reader_id) references readers(reader_id),
    foreign key (book_id) references books(book_id)
);

create table returning (
    return_id int primary key auto_increment,
    borrow_id int,
    return_date date,
    foreign key (borrow_id) references borrowing(borrow_id)
);

create table fines (
    fine_id int primary key auto_increment,
    return_id int,
    fine_amount decimal(10,2) not null,
    foreign key (return_id) references returning(return_id)
);

insert into categories (category_name) values ('khoa học'), ('văn học'), ('lịch sử');

insert into books (title, author, publication_year, quantity, category_id) values
('sách a', 'tác giả a', 2020, 5, 1),
('sách b', 'tác giả b', 2018, 3, 2),
('sách c', 'tác giả c', 2022, 7, 3);

insert into readers (full_name, email) values
('nguyễn văn a', 'nguyenvana@gmail.com'),
('trần thị b', 'tranthib@gmail.com'),
('lê văn c', 'levanc@gmail.com');

insert into borrowing (reader_id, book_id, borrow_date, return_date) values
(1, 1, '2024-01-10', '2024-01-20'),
(2, 2, '2024-02-05', '2024-02-15'),
(3, 3, '2024-03-12', '2024-03-22');

insert into returning (borrow_id, return_date) values
(1, '2024-01-20'),
(2, '2024-02-15'),
(3, '2024-03-22');

insert into fines (return_id, fine_amount) values
(1, 0.00),
(2, 5.00),
(3, 10.00);

update readers 
set full_name = 'phạm văn d', email = 'phamvand@gmail.com' 
where reader_id = 1;

delete from borrowing where book_id = 1;
delete from books where book_id = 1;

alter table borrowing drop foreign key borrowing_ibfk_2;
alter table borrowing add constraint borrowing_ibfk_2 
foreign key (book_id) references books(book_id) 
on delete cascade;

delete from books where book_id = 1;
