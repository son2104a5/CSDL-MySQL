create database qlbh;
use qlbh;

create table customer (
    cid int primary key,
    name varchar(75),
    cage int
);

create table products (
    pid int primary key,
    pname varchar(75),
    pprice double
);

create table orders (
    oid int primary key,
    cid int,
    odate datetime,
    ototalprice int,
    foreign key (cid) references customer(cid)
);

create table order_detail (
    oid int,
    pid int,
    odqty int,
    primary key (oid, pid),
    foreign key (oid) references orders(oid),
    foreign key (pid) references products(pid)
);


insert into customer values
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);


insert into products values
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 2),
(5, 'Bep Dien', 2);


insert into orders values
(1, 1, '2006-03-21', null),
(2, 1, '2006-03-23', null),
(3, 1, '2006-03-16', null);


insert into order_detail values
(1, 1, 3),
(1, 3, 7),
(2, 2, 1),
(2, 4, 8),
(2, 5, 4),
(3, 1, 3);

select oid, cid, odate, ototalprice
from orders
order by odate desc;

select pname, pprice
from products
where pprice = (select max(pprice) from products);

select customer.name as cname, product.pname  
from orderdetail  
join orders on orderdetail.oid = orders.oid  
join customer on orders.cid = customer.cid  
join product on orderdetail.pid = product.pid;

select customer.name as cName  
from customer  
left join orders on customer.cid = orders.cid  
where orders.cid is null;

select o.oID, o.oDate, od.odQTY, p.pName, p.pPrice
from orders o
join order_details od on o.oID = od.oID
join products p on od.pID = p.pID
order by o.oID desc;

select o.oID, o.oDate, sum(od.odQTY * p.pPrice) as Total
from orders o
join order_details od on o.oID = od.oID
join products p on od.pID = p.pID
group by o.oID, o.oDate
order by o.oID desc;

select concat('alter table ', table_name, ' drop foreign key ', constraint_name, ';') 
from information_schema.table_constraints 
where constraint_type = 'foreign key' 
and table_schema = database();