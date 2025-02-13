create view view_long_action_movies as
select 
    f.film_id, 
    f.title, 
    f.length, 
    c.name as category_name
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = 'Action' and f.length > 100;
select * from view_long_action_movies;

create view view_texas_customers as
select 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    ci.city
from customer c
join address a on c.address_id = a.address_id
join rental r on c.customer_id = r.customer_id
join city ci on ci.city_id = a.city_id
where a.district = 'Texas'
group by c.customer_id, c.first_name, c.last_name, ci.city;
select * from view_texas_customers;

create view view_high_value_staff as
select 
    s.staff_id, 
    s.first_name, 
    s.last_name, 
    sum(p.amount) as total_payment
from staff s
join payment p on s.staff_id = p.staff_id
group by s.staff_id, s.first_name, s.last_name
having sum(p.amount) > 100;
select * from view_high_value_staff;

create fulltext index idx_film_title_description 
on film (title, description);
select * from film 
where match(title, description) against ('action' in natural language mode);

create index idx_rental_inventory_id 
on rental (inventory_id);

select v.film_id, v.title, v.length, v.category_name
from view_long_action_movies v
join film f on v.film_id = f.film_id
where match(f.title, f.description) against ('war' in natural language mode);

DELIMITER &&
create procedure GetRentalByInventory(inventoryId int)
begin
	select rental_id, rental_date from rental where inventory_id = inventoryId;
end &&
DELIMITER ;
call GetRentalByInventory(2);

drop index idx_film_title_description on film;
drop index idx_rental_inventory_id on rental;
drop view view_high_value_staff;
drop view view_long_action_movies;
drop view view_texas_customers;
drop procedure GetRentalByInventory;