create database quanlysinhvien;
use quanlysinhvien;

create table students (
    studentid int primary key auto_increment,
    studentname varchar(50) not null,
    age int not null,
    email varchar(100) not null
);

create table class (
    classid int primary key auto_increment,
    classname varchar(50) not null
);

create table subjects (
    subjectid int primary key auto_increment,
    subjectname varchar(50) not null
);

create table classstudent (
    studentid int not null,
    classid int not null,
    primary key (studentid, classid),
    foreign key (studentid) references students(studentid),
    foreign key (classid) references class(classid)
);

create table marks (
    subject_id int not null,
    student_id int not null,
    mark int not null,
    primary key (subject_id, student_id),
    foreign key (subject_id) references subjects(subjectid),
    foreign key (student_id) references students(studentid)
);

insert into students (studentname, age, email) values
('Nguyen Quang An', 18, 'an@yahoo.com'),
('Nguyen Cong Vinh', 20, 'vinh@gmail.com'),
('Nguyen Van Quyen', 19, 'quyen'),
('Pham Thanh Binh', 25, 'binh@com'),
('Nguyen Van Tai Em', 30, 'taiem@sport.vn');

insert into class (classname) values
('C0706L'),
('C0708G');

insert into classstudent (studentid, classid) values
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 2),
(5, 1)
on duplicate key update classid = values(classid);

insert into subjects (subjectname) values
('SQL'),
('Java'),
('C'),
('Visual Basic');

insert into marks (mark, subject_id, student_id) values
(8, 1, 1),
(4, 2, 1),
(9, 1, 1),
(7, 1, 3),
(3, 1, 4),
(5, 2, 5),
(8, 3, 3),
(1, 3, 5),
(3, 2, 4);

select * from students;

select * from subjects;

select 
    s.studentid, 
    s.studentname, 
    avg(m.mark) as diem_trung_binh
from students s
join mark m on s.studentid = m.studentid
group by s.studentid, s.studentname;

select distinct sub.subjectname
from mark m
join subjects sub on m.subjectid = sub.subjectid
where m.mark > 9;

select 
    s.studentid, 
    s.studentname, 
    avg(m.mark) as diem_trung_binh
from students s
join mark m on s.studentid = m.studentid
group by s.studentid, s.studentname
order by diem_trung_binh desc;

update subjects 
set subjectname = concat('day la mon hoc ', subjectname);

delimiter //
create trigger check_student_age
before insert on students
for each row
begin
    if new.age <= 15 or new.age >= 50 then
        signal sqlstate '45000'
        set message_text = 'do tuoi phai lon hon 15 va nho hon 50';
    end if;
end;
//
delimiter ;

alter table mark drop foreign key mark_ibfk_1;
alter table mark drop foreign key mark_ibfk_2;
alter table classstudent drop foreign key classstudent_ibfk_1;
alter table classstudent drop foreign key classstudent_ibfk_2;

delete from students where studentid = 1;

alter table students add column status bit default 1;

update students set status = 0;