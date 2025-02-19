DELIMITER &&
create trigger before_update_phone
before update on employees
for each row
begin
    if char_length(new.phone) != 10 then
        signal sqlstate '45000' set message_text = 'Số điện thoại phải có đúng 10 chữ số';
    end if;
end &&
DELIMITER ;

CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

delimiter //
create trigger after_employee_insert
after insert on employees
for each row
begin
    insert into notifications (employee_id, message)
    values (new.employee_id, concat('chào mừng ', new.name));
end //
delimiter ;

delimiter //
create procedure add_new_employee_with_phone(
    in emp_name varchar(255),
    in emp_email varchar(255),
    in emp_phone varchar(20),
    in emp_hire_date date,
    in emp_department_id int
)
begin
    declare emp_id int;
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    if char_length(emp_phone) != 10 or emp_phone regexp '[^0-9]' then
        signal sqlstate '45000'
        set message_text = 'số điện thoại không hợp lệ';
    end if;

    insert into employees (name, email, phone, hire_date, department_id)
    values (emp_name, emp_email, emp_phone, emp_hire_date, emp_department_id);

    set emp_id = last_insert_id();

    insert into notifications (employee_id, message)
    values (emp_id, concat('chào mừng ', emp_name));

    commit;
end //
delimiter ;

