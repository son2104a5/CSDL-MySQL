CREATE TABLE StudentB1 (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(255) NOT NULL,
    age INT CHECK(age >= 18) NOT NULL,
    gender VARCHAR(10) CHECK(gender IN ('Male', 'Female', 'Other')) NOT NULL,
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
);


INSERT INTO StudentB1 (student_id, student_name, age, gender, registration_date)
VALUES
    (1, 'Nguyễn Văn A', 20, 'Male', '2025-01-15 08:30:00'),
    (2, 'Trần Thị B', 22, 'Female', '2025-01-14 09:00:00'),
    (3, 'Lê Minh C', 19, 'Male', '2025-01-13 10:15:00'),
    (4, 'Phan Thị D', 21, 'Female', '2025-01-12 11:20:00'),
    (5, 'Hoàng Văn E', 23, 'Other', '2025-01-11 14:30:00');