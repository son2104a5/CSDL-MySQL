CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    date_of_birth DATE,
    gender VARCHAR(10),
    gpa DECIMAL(3, 2)
);

INSERT INTO Students (name, email, date_of_birth, gender, gpa)
VALUES
('Nguyen Van A', 'nguyenvana@example.com', '2000-05-15', 'Male', 3.50),
('Tran Thi B', 'tranthib@example.com', '1999-08-22', 'Female', 3.80),
('Le Van C', 'levanc@example.com', '2001-01-10', 'Male', 2.70),
('Pham Thi D', 'phamthid@example.com', '1998-12-05', 'Female', 3.00),
('Hoang Van E', 'hoangvane@example.com', '2000-03-18', 'Male', 3.60),
('Do Thi F', 'dothif@example.com', '2001-07-25', 'Female', 4.00),
('Vo Van G', 'vovang@example.com', '2000-11-30', 'Male', 3.20),
('Nguyen Thi H', 'nguyenthih@example.com', '1999-09-15', 'Female', 2.90),
('Bui Van I', 'buivani@example.com', '2002-02-28', 'Male', 3.40),
('Tran Thi J', 'tranthij@example.com', '2001-06-12', 'Female', 3.75);

SELECT * FROM Students WHERE gender = 'Female' AND gpa > 3.0;

SELECT * FROM Students WHERE date_of_birth > '2000-01-01' ORDER BY gpa DESC LIMIT 1;

SELECT * FROM Students WHERE date_of_birth = (SELECT date_of_birth FROM Students WHERE student_id = 1);

UPDATE Students SET gpa = CASE WHEN gpa < 2.5 THEN LEAST(gpa + 0.5, 4.0) ELSE gpa END;

UPDATE Students SET gender = 'Other' WHERE email LIKE '%test%';

DELETE FROM Students ORDER BY date_of_birth ASC LIMIT 1;

SELECT name,  TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age FROM Students;