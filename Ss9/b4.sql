explain analyze
select ordernumber, orderdate, status
from orders
where year(orderdate) = 2003 and status = 'shipped';

create index idx_orderdate_status
on orders (orderdate, status);

explain analyze
select ordernumber, orderdate, status
from orders
where year(orderdate) = 2003 and status = 'shipped';

explain analyze
select customernumber, customername, phone
from customers
where phone = '2035552570';

create unique index idx_customernumber
on customers (customernumber);

explain analyze
select customernumber, customername, phone
from customers
where phone = '2035552570';

drop index idx_orderdate_status;
drop index idx_customernumber;
drop index idx_phone;