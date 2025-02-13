DELIMITER &&
create procedure UpdateSalaryByID(employee_id int, inout current_salary decimal(10, 2))
begin
	select Salary into current_salary from employees
    where EmployeeID = employee_id;
    if current_salary > 20000000 then
		set current_salary = current_salary * 1.05;
    else
		set current_salary = current_salary * 1.1;
	end if;
    
    update employees
    set Salary = current_salary where EmployeeID = employee_id;
    
    select FullName, Salary from employees where EmployeeID = employee_id;
end &&
DELIMITER ;
set @current_salary = 18000000;
call UpdateSalaryByID(4, @current_salary);

DELIMITER &&
create procedure GetLoanAmountByCustomerID(customer_id int, TotalLoan decimal(10, 2))
begin
	select CustomerID, coalesce(sum(LoanAmount), 0) from loans where CustomerID = customer_id group by CustomerID;
end &&
DELIMITER ;
set @TotalLoan = 0;
call GetLoanAmountByCustomerID(1, @TotalLoan);

DELIMITER &&
create procedure DeleteAccountIfLowBalance(acc_id int)
begin
	declare v_balance decimal(15,2);
    
    select Balance into v_balance from accounts where acc_id = AccountID;
    
    if v_balance < 1000000 then
		delete from accounts where acc_id = AccountID;
		select concat('Tài khoản', acc_id, 'đã được xóa') as message;
    else
		select concat('Tài khoản ', acc_id, ' không thể xóa vì số dư lớn hơn 1 triệu') as message;
	end if;
end &&
DELIMITER ;
call DeleteAccountIfLowBalance(8);

DELIMITER &&
create procedure TransferMoney(from_account int, to_account int, inout amount decimal(10, 2))
begin
	declare is_exist bit default(0);
    declare is_more_than bit default(0);
    if (select count(AccountID) from accounts where AccountID = from_account) > 0
		and (select count(AccountID) from accounts where AccountID = to_account) > 0
		then set is_exist = 1;
	end if;
    
    if is_exist = 1 then
		if (select Balance from accounts where AccountID = from_account) > amount
			then set is_more_than = 1;
		end if;
	end if;
    
    if is_more_than = 1 then
		update accounts
        set Balance = Balance + amount where AccountID = to_account;
        update accounts
        set Balance = Balance - amount where AccountID = from_account;
	end if;
    
    select AccountID, Balance from accounts where AccountID = to_account or AccountID = from_account;
end &&
DELIMITER ;
set @amount = 2000000;
call TransferMoney(1, 3, @amount);

drop procedure if exists UpdateSalaryByID;
drop procedure DeleteAccountIfLowBalance;
drop procedure TransferMoney;
drop procedure GetLoanAmountByCustomerID;