select p.product_name, p.category, p.price, p.stock_quantity from products p order by p.price desc limit 3;

select p.product_name, p.category, p.price, p.stock_quantity from products p limit 2 offset 2;

select p.product_name, p.category, p.price, p.stock_quantity from products p where p.category = 'Electronics' order by p.price desc;

select p.product_name, p.category, p.price, p.stock_quantity from products p where p.category = 'Clothing'
and price = (select min(price) from products where category = 'Clothing');

