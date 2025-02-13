DELIMITER &&
create procedure GetCustomerByPhone(phone_number varchar(20))
begin
	select CustomerID, FullName, DateOfBirth, Address, Email
    from customers where PhoneNumber = phone_number;
end &&
DELIMITER ;
call GetCustomerByPhone('0901234567');

DELIMITER &&
create procedure GetTotalBalance(customer_id int, out TotalBalance decimal(10, 2))
begin
	select sum(Balance) from accounts where CustomerID = customer_id group by CustomerID;
end &&
DELIMITER ;
set @TotalBalance = 0;
call GetTotalBalance(1, @TotalBalance);

DELIMITER &&
create procedure IncreaseEmployeeSalary(inout current_salary decimal(10, 2), employee_id int)
begin
	update employees
    set Salary = current_salary * 1.1
    where EmployeeID = employee_id;
    
    select EmployeeID, FullName, Salary from employees where EmployeeID = employee_id;
end &&
DELIMITER ;
set @current_salary = 10000000;
call IncreaseEmployeeSalary(@current_salary, 4);

drop procedure GetCustomerByPhone;
drop procedure GetTotalBalance;
drop procedure IncreaseEmployeeSalary;