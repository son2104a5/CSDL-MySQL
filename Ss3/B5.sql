CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    department VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2) CHECK (salary > 0)
);

INSERT INTO Employees (name, email, department, salary)
VALUES
    ('Nguyen Van A', 'nguyenvana@example.com', 'Sales', 50000.00),
    ('Le Thi B', 'lethib@example.com', 'IT', 60000.00),
    ('Tran Van C', 'tranvanc@example.com', 'HR', 45000.00),
    ('Pham Thi D', 'phamthid@example.com', 'Marketing', 55000.00);

SELECT * FROM Employees WHERE department = 'Sales';

UPDATE Employees
SET salary = salary * 1.10
WHERE department = 'Marketing';