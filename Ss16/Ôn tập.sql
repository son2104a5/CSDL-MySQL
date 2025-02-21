-- 2.1
drop database if exists shoppingManagerDB;
create database shoppingManagerDB;
use shoppingManagerDB;

-- 2.2.
create table Customers(
	customer_id int primary key auto_increment,
    customer_name varchar(100) not null,
    phone varchar(20) not null unique,
    address varchar(255)
);

create table Products(
	pro_id int primary key auto_increment,
    pro_name varchar(100) not null unique,
    price decimal(10, 2) not null,
    quantity int not null check(quantity >= 0),
    category varchar(50) not null
);

create table Employees(
	emp_id int primary key auto_increment,
    emp_name varchar(100) not null,
    birthday varchar(50) not null,
    position varchar(50) not null,
    salary decimal(10, 2) not null,
    revenue decimal(10, 2) default(0)
);

create table Orders(
	order_id int primary key auto_increment,
    customer_id int,
    foreign key (customer_id) references customers(customer_id),
    emp_id int,
    foreign key (emp_id) references employees(emp_id),
    order_date datetime default current_timestamp,
    total_amount decimal(10, 2) default(0)
);

create table OrderDetail(
	order_detail_id int primary key auto_increment,
    order_id int,
    pro_id int,
    foreign key (order_id) references Orders(order_id),
    foreign key (pro_id) references Products(pro_id),
    quantity int not null check(quantity > 0),
    unit_price decimal(10, 2) not null
);

-- 4.
INSERT INTO Customers (customer_name, phone, address) VALUES
('nguyen van a', '0987654321', '123 le loi, hanoi'),
('tran thi b', '0976543210', '456 tran hung dao, hcm'),
('pham van c', '0965432109', '789 ba trieu, da nang'),
('le thi d', '0954321098', '159 hoang dieu, hue'),
('hoang van e', '0943210987', '357 ly thai to, can tho');

INSERT INTO Products (pro_name, price, quantity, category) VALUES
('laptop1', 1500.00, 1234, 'laptop'),
('samsung s22', 1400.00, 5423, 'electronics'),
('macbook air', 1200.00, 5999, 'laptop'),
('iphone 13', 1300.00, 8000, 'electronics'),
('ipad pro', 1100.00, 1200, 'tablet');

INSERT INTO Employees (emp_name, birthday, salary, revenue, position) VALUES
('pham quang', '1990-05-15', 700.00, 5000.00, 'Quản lí'),
('tran tuan', '1985-09-10', 750.00, 5200.00, 'Nhân viên tiếp thị'),
('nguyen linh', '1992-12-20', 720.00, 4900.00, 'Thu ngân'),
('le khanh', '1988-07-25', 710.00, 5100.00, 'Nhân viên tiếp thị'),
('hoang minh', '1995-03-05', 680.00, 4800.00, 'Thu ngân');

INSERT INTO Orders (customer_id, emp_id, order_date, total_amount) VALUES
(1, 2, '2025-02-15 10:30:00', 2900.00),
(2, 3, '2025-02-16 14:45:00', 1400.00),
(3, 1, '2025-02-17 09:20:00', 1500.00),
(4, 4, '2025-02-18 16:10:00', 2300.00),
(5, 5, '2025-02-19 11:50:00', 1200.00);

INSERT INTO OrderDetail (order_id, pro_id, quantity, unit_price) VALUES
(1, 1, 2, 1500.00),
(1, 5, 3, 1100.00),
(2, 2, 1, 1400.00),
(3, 1, 1, 1500.00),
(4, 3, 1, 1200.00);

-- 3.1
alter table customers add column email varchar(100) unique;
UPDATE customers SET email = CONCAT('customer', customer_id, '@example.com') WHERE email IS NULL;
ALTER TABLE customers MODIFY COLUMN email VARCHAR(100) NOT NULL UNIQUE;

-- 3.2
alter table employees drop column birthday;

-- 5.1
select customer_id, customer_name, email, phone, address from customers;

-- 5.2
update products
	set pro_name = 'Laptop Dell XPS', price = 99.99
    where pro_id = 1;
    
-- 5.3
select o.order_id, c.customer_name, e.emp_name, o.total_amount, o.order_date
	from orders o
    join customers c on c.customer_id = o.customer_id
    join employees e on e.emp_id = o.emp_id;
    
-- 6.1
select 
	c.customer_id as 'Mã KH',
    c.customer_name as 'Tên KH',
    count(o.order_id) as 'Tổng số đơn'
from orders o
    join customers c on c.customer_id = o.customer_id
    group by c.customer_id;
    
-- 6.2
select
	e.emp_id,
    e.emp_name,
    sum(o.total_amount)
from orders o
    join employees e on e.emp_id = o.emp_id
    where year(o.order_date) = year(now())
    group by e.emp_id
    order by e.emp_id;

-- 6.3
select p.pro_id, p.pro_name, sum(od.quantity) as 'Số lượt đặt hàng'
from orderdetail od 
	left join products p on p.pro_id = od.pro_id
	join orders o on o.order_id = od.order_id
where month(o.order_date) = month(curdate())
group by p.pro_id, p.pro_name, od.quantity
having sum(od.quantity) >= 100
order by od.quantity desc;

-- 7.
-- 7.1
SELECT c.customer_id, c.customer_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- 7.2
SELECT pro_id, pro_name, price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

-- 7.3
SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING total_spent = (
    SELECT MAX(total_spent) FROM (
        SELECT customer_id, SUM(total_amount) AS total_spent
        FROM Orders
        GROUP BY customer_id
    ) AS customer_spending
);

-- 8.
-- 8.1
CREATE VIEW view_order_list AS
SELECT 
    o.order_id,
    c.customer_name,
    e.emp_name,
    o.total_amount,
    o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Employees e ON o.emp_id = e.emp_id
ORDER BY o.order_date DESC;

-- 8.2
CREATE VIEW view_order_detail_product AS
SELECT 
    od.order_detail_id,
    p.pro_name,
    od.quantity,
    od.unit_price
FROM OrderDetail od
JOIN Products p ON od.pro_id = p.pro_id
ORDER BY od.quantity DESC;

-- 9.
-- 9.1
DELIMITER //
CREATE PROCEDURE proc_insert_employee(
    IN p_emp_name VARCHAR(100),
    IN p_birthday VARCHAR(50),
    IN p_position VARCHAR(50),
    IN p_salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO Employees (emp_name, birthday, position, salary) 
    VALUES (p_emp_name, p_birthday, p_position, p_salary);
    
    SELECT LAST_INSERT_ID() AS new_employee_id;
END //
DELIMITER ;

-- 9.2.
DELIMITER //
CREATE PROCEDURE proc_get_orderdetails(
    IN p_order_id INT
)
BEGIN
    SELECT 
        od.order_detail_id,
        p.pro_name,
        od.quantity,
        od.unit_price
    FROM OrderDetail od
    JOIN Products p ON od.pro_id = p.pro_id
    WHERE od.order_id = p_order_id;
END //
DELIMITER ;

-- 9.3.
DELIMITER //
CREATE PROCEDURE proc_cal_total_amount_by_order(
    IN p_order_id INT
)
BEGIN
    SELECT COUNT(DISTINCT pro_id) AS total_products
    FROM OrderDetail
    WHERE order_id = p_order_id;
END //
DELIMITER ;

-- 10.
DELIMITER //
CREATE TRIGGER trigger_after_insert_order_details
BEFORE INSERT ON OrderDetail
FOR EACH ROW
BEGIN
    DECLARE available_quantity INT;

    -- Lấy số lượng sản phẩm hiện có trong kho
    SELECT quantity INTO available_quantity
    FROM Products
    WHERE pro_id = NEW.pro_id;

    IF available_quantity < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng sản phẩm trong kho không đủ';
    ELSE
        UPDATE Products
        SET quantity = quantity - NEW.quantity
        WHERE pro_id = NEW.pro_id;
    END IF;
END //
DELIMITER ;

-- 11.
DELIMITER //
CREATE PROCEDURE proc_insert_order_details(
    IN p_order_id INT,
    IN p_pro_id INT,
    IN p_quantity INT,
    IN p_unit_price DECIMAL(10,2)
)
BEGIN
    DECLARE v_order_exists INT DEFAULT 0;
    DECLARE v_available_quantity INT;
    DECLARE v_total_price DECIMAL(10,2);
    
    -- Bắt lỗi nếu có bất kỳ lỗi nào xảy ra
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi xảy ra khi thêm chi tiết đơn hàng';
    END;
    START TRANSACTION;

    SELECT COUNT(*) INTO v_order_exists 
    FROM Orders 
    WHERE order_id = p_order_id;

    IF v_order_exists = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không tồn tại mã hóa đơn';
    END IF;

    SELECT quantity INTO v_available_quantity
    FROM Products
    WHERE pro_id = p_pro_id
    FOR UPDATE; 

    IF v_available_quantity < p_quantity THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng sản phẩm trong kho không đủ';
    END IF;

    SET v_total_price = p_quantity * p_unit_price;

    INSERT INTO OrderDetail (order_id, pro_id, quantity, unit_price)
    VALUES (p_order_id, p_pro_id, p_quantity, p_unit_price);

    UPDATE Orders
    SET total_amount = total_amount + v_total_price
    WHERE order_id = p_order_id;

    UPDATE Products
    SET quantity = quantity - p_quantity
    WHERE pro_id = p_pro_id;

    COMMIT;
END //
DELIMITER ;
