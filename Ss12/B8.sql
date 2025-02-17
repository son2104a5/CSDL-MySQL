create database ss10_8;
use ss10_8;

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

CREATE TABLE salary_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    old_salary DECIMAL(10, 2) NOT NULL,
    new_salary DECIMAL(10, 2) NOT NULL,
    change_date DATETIME NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE salary_warnings (
    warning_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    warning_message VARCHAR(255) NOT NULL,
    warning_date DATETIME NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

DELIMITER &&
CREATE TRIGGER after_employee_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salary_history (emp_id, old_salary, new_salary, change_date)
    VALUES (OLD.emp_id, OLD.salary, NEW.salary, NOW());

    IF NEW.salary < OLD.salary * 0.7 THEN
        INSERT INTO salary_warnings (emp_id, warning_message, warning_date)
        VALUES (OLD.emp_id, 'Salary decreased by more than 30%', NOW());
    END IF;

    IF NEW.salary > OLD.salary * 1.5 THEN
        UPDATE employees SET salary = OLD.salary * 1.5 WHERE emp_id = NEW.emp_id;

        INSERT INTO salary_warnings (emp_id, warning_message, warning_date)
        VALUES (OLD.emp_id, 'Salary increased above allowed threshold (adjusted to 150% of previous salary)', NOW());
    END IF;
END; &&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER before_project_insert
BEFORE INSERT ON projects
FOR EACH ROW
BEGIN
    SET @active_projects = (SELECT COUNT(*) FROM projects WHERE emp_id = NEW.emp_id AND status != 'Completed');
    IF @active_projects >= 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nhân viên đã tham gia quá nhiều dự án đang hoạt động.';
    END IF;

    IF NEW.status = 'In Progress' AND NEW.start_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ngày bắt đầu dự án không hợp lệ.';
    END IF;
END; &&
DELIMITER ;

CREATE VIEW PerformanceOverview AS
SELECT
    p.project_id,
    p.name AS project_name,
    (SELECT COUNT(*) FROM projects WHERE project_id = p.project_id) AS employee_count,
    DATEDIFF(COALESCE(p.end_date, CURDATE()), p.start_date) AS total_days,
    p.status
FROM
    projects p;
    
INSERT INTO employees (name, dept_id, salary, hire_date) VALUES
('John Doe', 1, 1000.00, '2023-01-01'),
('Jane Smith', 2, 2000.00, '2023-02-01');

INSERT INTO projects (name, emp_id, start_date, status) VALUES
('Project A', 1, '2023-03-01', 'In Progress'),
('Project B', 2, '2023-04-01', 'In Progress');

UPDATE employees SET salary = salary * 0.5 WHERE emp_id = 1;

UPDATE employees SET salary = salary * 2 WHERE emp_id = 2;

INSERT INTO projects (name, emp_id, start_date, status) VALUES ('New Project 1', 1, CURDATE(), 'In Progress');
INSERT INTO projects (name, emp_id, start_date, status) VALUES ('New Project 2', 1, CURDATE(), 'In Progress');
INSERT INTO projects (name, emp_id, start_date, status) VALUES ('New Project 3', 1, CURDATE(), 'In Progress');
INSERT INTO projects (name, emp_id, start_date, status) VALUES ('New Project 4', 1, CURDATE(), 'In Progress');

INSERT INTO projects (name, emp_id, start_date, status) VALUES ('Future Project', 2, DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'In Progress');

SELECT * FROM PerformanceOverview;

SELECT * FROM salary_history;
SELECT * FROM salary_warnings;