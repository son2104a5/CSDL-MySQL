CREATE TABLE budget_warnings (
    warning_id INT AUTO_INCREMENT PRIMARY KEY,
    project_id INT NOT NULL,
    warning_message VARCHAR(255) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

DELIMITER &&
CREATE TRIGGER after_project_update
AFTER UPDATE ON projects
FOR EACH ROW
BEGIN
    IF NEW.total_salary > NEW.budget THEN
        IF NOT EXISTS (SELECT 1 FROM budget_warnings WHERE project_id = NEW.project_id AND warning_message = 'Budget exceeded due to high salary') THEN
            INSERT INTO budget_warnings (project_id, warning_message) VALUES (NEW.project_id, 'Budget exceeded due to high salary');
        END IF;
    END IF;
END;
DELIMITER ;

CREATE VIEW ProjectOverview AS
SELECT
    p.project_id,
    p.name AS project_name,
    p.budget,
    p.total_salary,
    bw.warning_message
FROM
    projects p
LEFT JOIN
    budget_warnings bw ON p.project_id = bw.project_id;

INSERT INTO workers (name, project_id, salary) VALUES ('Michael', 1, 6000.00);
INSERT INTO workers (name, project_id, salary) VALUES ('Sarah', 2, 10000.00);
INSERT INTO workers (name, project_id, salary) VALUES ('David', 3, 1000.00);

SELECT * FROM budget_warnings;
SELECT * FROM ProjectOverview;