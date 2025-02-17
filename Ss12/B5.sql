CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    budget DECIMAL(15, 2) NOT NULL,
    total_salary DECIMAL(15, 2) DEFAULT 0
);

CREATE TABLE workers (
    worker_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    project_id INT,
    salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO projects (name, budget) VALUES
('Bridge Construction', 10000.00),
('Road Expansion', 15000.00),
('Office Renovation', 8000.00);

CREATE TRIGGER after_worker_insert
AFTER INSERT ON workers
FOR EACH ROW
UPDATE projects
SET total_salary = total_salary + NEW.salary
WHERE project_id = NEW.project_id;

CREATE TRIGGER after_worker_delete
AFTER DELETE ON workers
FOR EACH ROW
UPDATE projects
SET total_salary = total_salary - OLD.salary
WHERE project_id = OLD.project_id;

INSERT INTO workers (name, project_id, salary) VALUES
('John', 1, 2500.00),
('Alice', 1, 3000.00),
('Bob', 2, 2000.00),
('Eve', 2, 3500.00),
('Charlie', 3, 1500.00);

SELECT * FROM projects;

DELETE FROM workers WHERE name = 'Alice';

SELECT * FROM projects;