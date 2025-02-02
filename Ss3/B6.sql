CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL
);

INSERT INTO Books (title, price, stock)
VALUES
('To Kill a Mockingbird', 120.00, 10),
('1984', 90.00, 3),
('The Great Gatsby', 150.00, 20),
('Moby Dick', 200.00, 5),
('Pride and Prejudice', 50.00, 8);

SELECT * FROM Books WHERE price > 100;

DELETE FROM Books WHERE title LIKE '%Pride%';