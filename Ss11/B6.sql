create view view_film_category as
select 
    f.film_id, 
    f.title, 
    c.name as category_name
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id;

create view view_high_value_customers as
select 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    sum(p.amount) as total_payment
from customer c
join payment p on c.customer_id = p.customer_id
group by c.customer_id, c.first_name, c.last_name
having sum(p.amount) > 100;

create index idx_rental_rental_date 
on rental (rental_date);

select * from rental 
where rental_date = '2005-06-14';

explain select * from rental 
where rental_date = '2005-06-14';

DELIMITER &&
create procedure CountCustomerRentals(customer_id int, out rental_count int)
begin
	select count(c.customer_id) from rental r join customer c on r.customer_id = c.customer_id
    where c.customer_id = customer_id
    group by customer_id;
end &&
DELIMITER ;
set @rental_count = 0;
call CountCustomerRentals(10, @rental_count);

DELIMITER &&
create procedure GetCustomerEmail(customerId int)
begin
	select customer_id, email from customer where customer_id = customerId;
end &&
DELIMITER ;
call GetCustomerEmail(3);

drop view view_film_category;
drop view view_high_value_customers;
drop index idx_rental_rental_date on rental;
drop procedure CountCustomerRentals;
drop procedure GetCustomerEmail;