create database studenttest;
use studenttest;

create table test (
    testid int primary key auto_increment,
    name varchar(20) not null
);

create table student (
    rn int primary key auto_increment,
    name varchar(20) not null,
    age int not null
);

create table studenttest (
    rn int,
    testid int,
    date datetime not null,
    mark float check (mark >= 0 and mark <= 10),
    primary key (rn, testid),
    foreign key (rn) references student(rn) on delete cascade,
    foreign key (testid) references test(testid) on delete cascade
);

insert into student (rn, name, age) values
(1, 'Nguyen Hong Ha', 20),
(2, 'Truong Ngoc Anh', 30),
(3, 'Tuan Minh', 25),
(4, 'Dan Truong', 22);

insert into test (testid, name) values
(1, 'EPC'),
(2, 'DWMX'),
(3, 'SQL1'),
(4, 'SQL2');

insert into studenttest (rn, testid, date, mark) values
(1, 1, '2006-07-17', 8),
(1, 2, '2006-07-18', 5),
(1, 3, '2006-07-19', 7),
(2, 1, '2006-07-17', 7),
(2, 2, '2006-07-18', 4),
(2, 3, '2006-07-19', 2),
(3, 1, '2006-07-17', 10),
(3, 3, '2006-07-18', 1);

alter table Student add constraint chk_age check (age between 15 and 55);

alter table StudentTest alter column Mark set default 0;

alter table Test add constraint unique_test_name unique (name);

alter table Test drop constraint unique_test_name;

select 
    S.Name as "Student Name",
    T.Name as "Test Name",
    ST.Mark,
    ST.Date
from StudentTest ST
join Student S on ST.RN = S.RN
join Test T on ST.TestID = T.TestID;

select S.RN, S.Name, S.Age
from Student S
left join StudentTest ST on S.RN = ST.RN
where ST.RN is null;

select 
    S.Name as "Student Name",
    T.Name as "Test Name",
    ST.Mark,
    ST.Date
from StudentTest ST
join Student S on ST.RN = S.RN
join Test T on ST.TestID = T.TestID
where ST.Mark < 5;

select 
    S.Name as "Student Name",
    avg(ST.Mark) as "Average"
from StudentTest ST
join Student S on ST.RN = S.RN
group by S.Name
order by "Average" desc;

select 
    S.Name as "Student Name",
    avg(ST.Mark) as "Average"
from StudentTest ST
join Student S on ST.RN = S.RN
group by S.Name
order by "Average" desc
limit 1;

select 
    T.Name as "Test Name",
    max(ST.Mark) as "Max Mark"
from StudentTest ST
join Test T on ST.TestID = T.TestID
group by T.Name
order by T.Name;

select 
    S.Name as "Student Name",
    coalesce(T.Name, 'NULL') as "Test Name"
from Student S
left join StudentTest ST on S.RN = ST.RN
left join Test T on ST.TestID = T.TestID;

update Student
set Age = Age + 1;

alter table Student
add column Status varchar(10);

update Student
set Status = case 
    when Age < 30 then 'Young' 
    else 'Old' 
end;

select * from Student;

select 
    S.Name as "Student Name",
    T.Name as "Test Name",
    ST.Mark,
    ST.Date
from StudentTest ST
join Student S on ST.RN = S.RN
join Test T on ST.TestID = T.TestID
order by ST.Date asc;

select s.name, t.name, st.mark, st.date
from studenttest st
join Student S on ST.RN = S.RN
join Test T on ST.TestID = T.TestID
order by date asc;

select st.rn, s.name, s.age, avg(st.mark) as avgmark
from studenttest st
join Student S on ST.RN = S.RN
where s.name like 't%' 
group by st.rn, s.name, s.age
having avg(mark) > 4.5;

select st.rn, s.name, s.age, avg(st.mark) as avgmark,
       rank() over (order by avg(mark) desc)
from studenttest st
join Student S on ST.RN = S.RN
group by st.rn, s.name, s.age;

alter table student modify column name nvarchar(100);

update student
set name = 'old ' + name
where age > 20;

update student
set name = 'young ' + name
where age <= 20;

delete from subject
where subjectid not in (select distinct testname from studenttest);

delete from studenttest
where mark < 5;
