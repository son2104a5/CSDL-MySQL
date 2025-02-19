create table banks(
	bank_id int auto_increment primary key,
    bank_name varchar(255) not null,
    status enum('ACTIVE', 'ERROR')
);

INSERT INTO banks (bank_id, bank_name, status) VALUES 
(1,'VietinBank', 'ACTIVE'),   
(2,'Sacombank', 'ERROR'),    
(3, 'Agribank', 'ACTIVE');

alter table company_funds add column bank_id int;
alter table company_funds add foreign key (bank_id) references banks(bank_id);

UPDATE company_funds SET bank_id = 1 WHERE balance = 50000.00;
INSERT INTO company_funds (balance, bank_id) VALUES (45000.00,2);

DELIMITER &&
create trigger checkBankStatus before insert on payroll for each row
begin
	declare bank_status_check enum('ACTIVE', 'ERROR');
    select status into bank_status_check from banks
		where bank_id = (select bank_id from banks limit 1);
	if bank_status_check = 'ERROR' then
		signal sqlstate '45000'
        set message_text = 'Không thể thực hiện tác vụ!';
	end if;
end &&
DELIMITER ;

DELIMITER &&
create procedure TransferSalary(p_emp_id int, p_bank_id int)
begin
	declare isEmp int;
    declare p_salary decimal(10, 2);
    declare bank_status_value enum('ACTIVE', 'ERROR');
    declare p_balance decimal (10, 2);
    declare error_message text;
	start transaction;
    select count(emp_id) into isEmp from employees where emp_id = p_emp_id;
    select salary into p_salary from employees where emp_id = p_emp_id;
    select status into bank_status_value from banks where bank_id = p_bank_id;
    if bank_status_value = 'Error' then
        set error_message = 'Ngân hàng đang gặp sự cố, không thể thực hiện trả lương.';
        insert into transaction_log (log_message) values (error_message);
    end if;
    if isEmp = 0 then
		insert into transaction_log(log_message) value ('Không tìm thấy nhân viên');
		rollback;
	else
		select balance into p_balance from company_funds where bank_id = p_bank_id;
        if p_balance < (select salary from employees where emp_id = p_emp_id) then
			set error_message = 'Số dư tài khoản không đủ để thực hiện giao dịch.';
			insert into transaction_log (log_message) values (error_message);
			rollback;
		else
			update company_funds
				set balance = balance - p_salary where bank_id = p_bank_id;
			insert into payroll(emp_id, salary, pay_date)
				values (p_emp_id, p_salary, curdate());
			update employees
				set last_pay_date = curdate() where emp_id = p_emp_id;
			set error_message = 'Giao dịch thành công.';
			insert into transaction_log (log_message) values (error_message);
		end if;
    end if;
end &&
DELIMITER ;

call TransferSalary(1, 1);

select * from transaction_log;
select * from company_funds;
select * from payroll;
select * from employees;