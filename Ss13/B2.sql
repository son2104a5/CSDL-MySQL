CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(50),
    price DECIMAL(10,2),
    stock INT NOT NULL
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT NOT NULL,
    total_price DECIMAL(10,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_name, price, stock) VALUES
('Laptop Dell', 1500.00, 10),
('iPhone 13', 1200.00, 8),
('Samsung TV', 800.00, 5),
('AirPods Pro', 250.00, 20),
('MacBook Air', 1300.00, 7);

DELIMITER &&
drop procedure if exists checkQuantity;
create procedure checkQuantity(
	p_pro_id int,
    p_quantity int
)
begin
	declare total_money decimal(10, 2);
	start transaction;
    if(select stock from products where product_id = p_pro_id) < p_quantity then
		rollback;
	else
		set total_money = (select price from products where p_pro_id = product_id);
        set total_money = total_money * p_quantity;
		insert into orders(product_id, quantity, total_price)
        values
			(p_pro_id, p_quantity, total_money);
		update products
			set stock = stock - p_quantity;
	end if;
    commit;
end &&
DELIMITER ;

call checkQuantity(1, 5);

select * from products;
select * from orders;