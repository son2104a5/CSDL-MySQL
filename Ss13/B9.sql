create table accounts(
	acc_id int primary key auto_increment,
    emp_id int,
    bank_id int,
    foreign key (emp_id) references employees(emp_id),
    foreign key (bank_id) references banks(bank_id),
    amount_added decimal(15, 2),
    total_amount decimal(15, 2)
);

INSERT INTO accounts (emp_id, bank_id, amount_added, total_amount) VALUES
(1, 1, 0.00, 12500.00),  
(2, 1, 0.00, 8900.00),   
(3, 1, 0.00, 10200.00),  
(4, 1, 0.00, 15000.00),  
(5, 1, 0.00, 7600.00);

DELIMITER &&
create procedure TransferSalaryAll()
begin
    declare done int default 0;
    declare v_emp_id int;
    declare v_salary decimal(10,2);
    declare company_balance decimal(15,2);
    declare total_paid int default 0;
    declare error_message text;
    
    declare cur cursor for select emp_id, salary from employees;
    declare continue handler for not found set done = 1;
    declare exit handler for sqlexception 
    begin
        set error_message = 'Lỗi xảy ra trong quá trình xử lý.';
        insert into transaction_log (log_message) values (error_message);
        rollback;
    end;
    
    select balance into company_balance from company_funds limit 1;
    open cur;
    start transaction;
    read_loop: loop
        fetch cur into v_emp_id, v_salary;
        if done then
            leave read_loop;
        end if;
        
        if company_balance < v_salary then
            set error_message = 'Số dư quỹ không đủ để trả lương.';
            insert into transaction_log (log_message) values (error_message);
            rollback;
        end if;
        
        update company_funds set balance = balance - v_salary;
        insert into payroll (emp_id, salary, pay_date) values (v_emp_id, curdate());
        update employees set last_pay_date = curdate() where emp_id = v_emp_id;
        update accounts set amount_added = v_salary, total_amount = total_amount + v_salary where emp_id = v_emp_id;
        set total_paid = total_paid + 1;
    end loop;
    close cur;
    
    insert into transaction_log (log_message) values (concat('Chuyển lương thành công cho ', total_paid, ' nhân viên'));
    commit;
end &&
DELIMITER ;

call TransferSalaryAll;

select * from company_funds;
select * from payroll;
select * from accounts;
select * from transaction_log;