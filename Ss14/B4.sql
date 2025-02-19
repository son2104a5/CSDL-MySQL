DELIMITER &&
create procedure IncreaseSalary(
    in emp_id int,
    in new_salary decimal(10,2),
    in reason text
)
begin
    declare old_salary decimal(10,2);
    declare emp_exists int;

    start transaction;
    
    select count(*) into emp_exists from salaries where employee_id = emp_id;
    if emp_exists = 0 then
        rollback;
        signal sqlstate '45000' set message_text = 'Nhân viên không tồn tại!';
    end if;
    
    select base_salary into old_salary from salaries where employee_id = emp_id;
    insert into salary_history (employee_id, old_salary, new_salary, change_date, reason)
    values (emp_id, old_salary, new_salary, now(), reason);
    
    update salaries set base_salary = new_salary where employee_id = emp_id;
    
    commit;
end &&
DELIMITER ;

call IncreaseSalary(1, 5000.00, 'Tăng lương định kỳ');

DELIMITER &&
create procedure DeleteEmployee(
    in emp_id int
)
begin
    declare old_salary decimal(10,2);
    declare emp_exists int;

    start transaction;
    
    select count(*) into emp_exists from employees where employee_id = emp_id;
    if emp_exists = 0 then
        rollback;
        signal sqlstate '45000' set message_text = 'Nhân viên không tồn tại!';
    end if;
    
    select base_salary into old_salary from salaries where employee_id = emp_id;
    delete from salaries where employee_id = emp_id;
    
    insert into salary_history (employee_id, old_salary, new_salary, change_date, reason)
    values (emp_id, old_salary, null, now(), 'employee deleted');
    
    delete from employees where employee_id = emp_id;
    
    commit;
end &&
DELIMITER ;

call DeleteEmployee(2);