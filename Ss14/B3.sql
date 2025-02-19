delimiter //
create procedure sp_create_order(
    in p_customer_id int,
    in p_product_id int,
    in p_quantity int,
    in p_price decimal(10,2)
)
begin
    declare v_stock int;
    declare v_order_id int;

    start transaction;
    select stock_quantity into v_stock from inventory where product_id = p_product_id;
    
    if v_stock is null or v_stock < p_quantity then
        signal sqlstate '45000' set message_text = 'không đủ hàng trong kho!';
        rollback;
    else
        insert into orders (customer_id, order_date, total_amount, status) 
        values (p_customer_id, now(), 0, 'Pending');
        
        set v_order_id = last_insert_id();
        
        insert into order_items (order_id, product_id, quantity, price) 
        values (v_order_id, p_product_id, p_quantity, p_price);
        
        update inventory
        set stock_quantity = stock_quantity - p_quantity
        where product_id = p_product_id;

        commit;
    end if;
end //
delimiter ;

delimiter //
create procedure sp_cancel_order(
    in p_order_id int
)
begin
    declare v_status enum('Pending', 'Completed', 'Cancelled');

    start transaction;
    select status into v_status from orders where order_id = p_order_id;

    if v_status is null then
        signal sqlstate '45000' set message_text = 'đơn hàng không tồn tại!';
        rollback;
    elseif v_status <> 'Pending' then
        signal sqlstate '45000' set message_text = 'chỉ có thể hủy đơn hàng ở trạng thái pending!';
        rollback;
    else
        update orders
        set status = 'Cancelled'
        where order_id = p_order_id;

        update inventory i
        join order_items oi on i.product_id = oi.product_id
        set i.stock_quantity = i.stock_quantity + oi.quantity
        where oi.order_id = p_order_id;

        commit;
    end if;
end //
delimiter ;

delimiter //
create procedure sp_cancel_order_2(
    in p_order_id int
)
begin
    declare v_status enum('Pending', 'Completed', 'Cancelled');

    start transaction;
    select status into v_status from orders where order_id = p_order_id;

    if v_status is null then
        signal sqlstate '45000' set message_text = 'đơn hàng không tồn tại!';
        rollback;
    elseif v_status <> 'Pending' then
        signal sqlstate '45000' set message_text = 'chỉ có thể hủy đơn hàng ở trạng thái pending!';
        rollback;
    else
        update inventory i
        join order_items oi on i.product_id = oi.product_id
        set i.stock_quantity = i.stock_quantity + oi.quantity
        where oi.order_id = p_order_id;

        delete from order_items where order_id = p_order_id;

        update orders
        set status = 'Cancelled'
        where order_id = p_order_id;

        commit;
    end if;
end //
delimiter ;

drop procedure if exists sp_create_order;
drop procedure if exists sp_cancel_order;
drop procedure if exists sp_cancel_order_2;