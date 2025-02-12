create view view_customer_status as
select 
    customernumber, 
    customername, 
    creditlimit, 
    case 
        when creditlimit > 100000 then 'high'
        when creditlimit between 50000 and 100000 then 'medium'
        else 'low'
    end as status
from customers;

select * from view_customer_status;

select status, count(customernumber) as customer_count
from view_customer_status
group by status
order by customer_count desc;