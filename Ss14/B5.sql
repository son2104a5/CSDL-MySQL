delimiter //
create trigger before_insert_payment
before insert on payments
for each row
begin
    declare v_total_amount decimal(10,2);

    -- Lấy tổng tiền của đơn hàng
    select total_amount into v_total_amount from orders where order_id = new.order_id;

    -- Kiểm tra số tiền thanh toán
    if new.amount < v_total_amount then
        signal sqlstate '45000' set message_text = 'số tiền thanh toán không khớp với tổng đơn hàng!';
    end if;
end //
delimiter ;

-- Tạo bảng lưu log thay đổi trạng thái đơn hàng

CREATE TABLE order_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    old_status ENUM('Pending', 'Completed', 'Cancelled'),
    new_status ENUM('Pending', 'Completed', 'Cancelled'),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

delimiter //
create trigger after_update_order_status
after update on orders
for each row
begin
    if old.status <> new.status then
        insert into order_logs (order_id, old_status, new_status, log_date)
        values (new.order_id, old.status, new.status, now());
    end if;
end //
delimiter ;

delimiter //
create procedure sp_update_order_status_with_payment(
    in p_order_id int,
    in p_new_status enum('Pending', 'Completed', 'Cancelled'),
    in p_payment_amount decimal(10,2),
    in p_payment_method enum('Credit Card', 'PayPal', 'Bank Transfer', 'Cash')
)
begin
    declare v_current_status enum('Pending', 'Completed', 'Cancelled');
    declare v_total_amount decimal(10,2);

    start transaction;
    select status, total_amount into v_current_status, v_total_amount 
    from orders where order_id = p_order_id;

    if v_current_status is null then
        signal sqlstate '45000' set message_text = 'đơn hàng không tồn tại!';
        rollback;
    elseif v_current_status = p_new_status then
        signal sqlstate '45000' set message_text = 'đơn hàng đã có trạng thái này!';
        rollback;
    end if;

    if p_new_status = 'Completed' then
        insert into payments (order_id, payment_date, amount, payment_method, status)
        values (p_order_id, now(), p_payment_amount, p_payment_method, 'Completed');
    end if;

    update orders
    set status = p_new_status
    where order_id = p_order_id;

    commit;
end //
delimiter ;

insert into customers (name, email, phone, address) 
values ('nguyen van a', 'a@gmail.com', '0123456789', 'hanoi');

insert into products (name, price, description) 
values ('sản phẩm 1', 100000, 'mô tả sản phẩm 1');

insert into inventory (product_id, stock_quantity) 
values (1, 50);

insert into orders (customer_id, order_date, total_amount, status) 
values (1, now(), 200000, 'Pending');

insert into order_items (order_id, product_id, quantity, price) 
values (1, 1, 2, 100000);

call sp_update_order_status_with_payment(1, 'Completed', 200000, 'Credit Card');

select * from order_logs;

drop trigger if exists before_insert_payment;
drop trigger if exists after_update_order_status;

drop procedure if exists sp_update_order_status_with_payment;
