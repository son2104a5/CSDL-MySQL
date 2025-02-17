create view view_high_value_customers as
select 
    c.CustomerId, 
    concat(c.lastName, ' ', c.firstName) as full_name, 
    c.email, 
    sum(i.total) as total_spending
from customer c
join invoice i on c.customerId = i.CustomerId
where year(i.invoiceDate) >= 2010  
and c.country <> 'Brazil'  
group by c.customerId, c.lastName, c.firstName, c.email
having total_spending > 200;

create view view_popular_tracks as
select 
    t.trackId, 
    t.name as trackName, 
    sum(il.quantity) as total_sales
from track t
join invoiceline il on t.trackId = il.trackId
where t.unitPrice > 1.00  
group by t.trackId, t.name
having total_sales > 15;

create index idx_customer_country on customer (country) using hash;
select * from customer where country = 'Canada';
explain select * from customer where country = 'Canada';

create fulltext index idx_track_name_ft on track(name);
select * from track 
where match(name) against('Love' in natural language mode);
explain select * from track 
where match(name) against('Love' in natural language mode);

select vpt.trackId, vpt.trackName, vpt.total_sales, t.unitPrice
from view_popular_tracks vpt
join track t on vpt.trackId = t.trackId
where match(t.name) against('Love' in natural language mode);

DELIMITER &&
create procedure GetHighValueCustomersByCountry(in p_Country varchar(50))
begin
    select vhvc.customerId, vhvc.full_name, vhvc.email, vhvc.total_spending, c.country
    from view_high_value_customers vhvc
    join customer c on vhvc.customerId = c.customerId
    where c.country = p_Country;
end &&
DELIMITER ;

DELIMITER &&
create procedure UpdateCustomerSpending(in p_CustomerId int, in p_Amount decimal(10,2))
begin
    update invoice
    set total = total + p_Amount
    where customerId = p_CustomerId
    order by invoiceDate desc;
end &&
DELIMITER ;

call UpdateCustomerSpending(5, 50.00);

select * from view_high_value_customers where customerId = 5;

drop view if exists view_popular_tracks;
drop view if exists view_high_value_customers;
drop index idx_customer_country on customer;
drop index idx_track_name_ft on track;
drop procedure if exists GetHighValueCustomersByCountry;
drop procedure if exists UpdateCustomerSpending;
