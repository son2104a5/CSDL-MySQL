CREATE TABLE company_funds (
    fund_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(15,2) NOT NULL -- Số dư quỹ công ty
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50) NOT NULL,   -- Tên nhân viên
    salary DECIMAL(10,2) NOT NULL    -- Lương nhân viên
);

CREATE TABLE payroll (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,                      -- ID nhân viên (FK)
    salary DECIMAL(10,2) NOT NULL,   -- Lương được nhận
    pay_date DATE NOT NULL,          -- Ngày nhận lương
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);


INSERT INTO company_funds (balance) VALUES (50000.00);

INSERT INTO employees (emp_name, salary) VALUES
('Nguyễn Văn An', 5000.00),
('Trần Thị Bốn', 4000.00),
('Lê Văn Cường', 3500.00),
('Hoàng Thị Dung', 4500.00),
('Phạm Văn Em', 3800.00);

DELIMITER &&
drop procedure if exists salaryEmployeePaying;
create procedure salaryEmployeePaying(p_emp_id int, p_fund_id int)
begin
	start transaction;
    if(select balance from company_funds where fund_id = p_fund_id) < (select salary from employees where emp_id = p_emp_id) then
		rollback;
    else
		update company_funds
			set balance = balance - (select salary from employees where emp_id = p_emp_id) where fund_id = p_fund_id;
		insert into payroll(emp_id, salary, pay_date)
			values
				(p_emp_id, (select salary from employees where emp_id = p_emp_id), current_date());
    end if;
    commit;
end &&
DELIMITER ;

call salaryEmployeePaying(1, 1);
select * from company_funds;
select * from payroll;