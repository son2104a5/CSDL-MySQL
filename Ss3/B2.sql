CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    age INT CHECK (age > 0)
);

INSERT INTO Students (name, email, age)
VALUES
    ('Nguyen Van A', 'nguyenvana@example.com', 22),
    ('Le Thi B', 'lethib@example.com', 20),
    ('Tran Van C', 'tranvanc@example.com', 23),
    ('Pham Thi D', 'phamthid@example.com', 21);

UPDATE Students
SET email = 'newemail@example.com'
WHERE student_id = 3;