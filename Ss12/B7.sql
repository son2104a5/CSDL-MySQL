create database ss10_7;
use ss10_7;

CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager VARCHAR(100) NOT NULL,
    budget DECIMAL(15, 2) NOT NULL
);

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INT,
    salary DECIMAL(10, 2) NOT NULL,
    hire_date DATE NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    emp_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

DELIMITER &&
CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 500 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lương nhân viên quá thấp (dưới 500).';
    END IF;
    IF NEW.name = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tên nhân viên không được để trống.';
    END IF;
     IF EXISTS (SELECT 1 FROM projects WHERE emp_id = NEW.emp_id and status = 'Completed') THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nhân viên đang thực hiện dự án đã hoàn thành.';
    END IF;
END &&
DELIMITER ;

CREATE TABLE project_warnings (
    warning_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    warning_message VARCHAR(255) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

CREATE TABLE dept_warnings (
    warning_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_id INT NOT NULL,
    warning_message VARCHAR(255) NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

DELIMITER &&
CREATE TRIGGER after_project_update
AFTER UPDATE ON projects
FOR EACH ROW
BEGIN
    IF NEW.status = 'Delayed' THEN
        INSERT INTO project_warnings (project_id, warning_message)
        VALUES (NEW.project_id, 'Dự án bị trì hoãn.');
    ELSEIF NEW.status = 'Completed' THEN
        -- Kiểm tra tổng lương nhân viên của phòng ban có vượt ngân sách hay không
        SET @dept_id = (SELECT dept_id FROM employees WHERE emp_id = NEW.emp_id);
        SET @total_salary = (SELECT SUM(salary) FROM employees WHERE dept_id = @dept_id);
        SET @budget = (SELECT budget FROM departments WHERE dept_id = @dept_id);
        
        IF @total_salary > @budget THEN
            INSERT INTO dept_warnings (dept_id, warning_message)
            VALUES (@dept_id, 'Tổng lương nhân viên vượt quá ngân sách phòng ban.');
        END IF;
    END IF;
END &&
DELIMITER ;

CREATE VIEW FullOverview AS
SELECT
    e.emp_id,
    e.name AS employee_name,
    d.name AS department_name,
    p.name AS project_name,
    p.status,
    concat('$',e.salary) as salary,
    pw.warning_message
FROM
    employees e
JOIN
    departments d ON e.dept_id = d.dept_id
LEFT JOIN
    projects p ON e.emp_id = p.emp_id
LEFT JOIN
    project_warnings pw ON p.project_id = pw.project_id;
    
INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Alice', 1, 600, '2023-07-01'); 

INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Bob', 999, 1000, '2023-07-01'); 

INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Charlie', 2, 1500, '2023-07-01');

INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('David', 1, 2000, '2023-07-01');

UPDATE projects SET status = 'Delayed' WHERE project_id = 1;

UPDATE projects SET status = 'Completed', end_date = NULL WHERE project_id = 2;

UPDATE projects SET status = 'Completed' WHERE project_id = 3;

UPDATE projects SET status = 'In Progress' WHERE project_id = 4;

SELECT * FROM FullOverview;