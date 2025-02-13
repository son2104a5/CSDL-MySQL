create index idx_phone_number on customers(PhoneNumber);

EXPLAIN SELECT * FROM Customers WHERE PhoneNumber = '0901234567';

create index idx_branch_salary on employees(BranchID, Salary);

EXPLAIN SELECT * FROM Employees WHERE BranchID = 1 AND Salary > 20000000;

create unique index idx_unique_acc_customer on accounts(AccountID, CustomerID);

show index from customers;
show index from employees;
show index from accounts;