select c.name, c.phone, o.order_id, o.total_amount from customers c left join orders o
on c.customer_id = o.customer_id where o.status = 'Pending' and total_amount > 300000;

select c.name, c.email, o.order_id from customers c left join orders o
on c.customer_id = o.customer_id where o.status = 'Completed' or o.status is null;

select c.name, c.email, o.order_id, o.status from customers c left join orders o
on c.customer_id = o.customer_id where o.status = 'Pending' or o.status = 'Cancelled';

select c.name, c.phone, o.order_id, o.total_amount from customers c left join orders o
on c.customer_id = o.customer_id where o.total_amount between 300000 and 600000;