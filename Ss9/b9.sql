create index idx_customernumber 
on payments (customernumber);

create view view_customer_payments as
select 
    customernumber, 
    sum(amount) as total_payments, 
    count(checknumber) as payment_count
from payments
group by customernumber;

select * from view_customer_payments;

select c.customername, c.country, v.total_payments, v.payment_count, 
       (v.total_payments / v.payment_count) as average_payment, c.creditlimit
from view_customer_payments v
join customers c on v.customernumber = c.customernumber
where v.total_payments > 150000 and v.payment_count > 3
order by v.total_payments desc
limit 5;