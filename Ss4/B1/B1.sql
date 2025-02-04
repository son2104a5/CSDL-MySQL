create database ss4;

use ss4;

CREATE TABLE ComputerRoom (
    CR_id INT PRIMARY KEY AUTO_INCREMENT,
    CR_name VARCHAR(100) NOT NULL,
    CR_managementName VARCHAR(100) NOT NULL
);

CREATE TABLE Computer (
    computer_id INT PRIMARY KEY AUTO_INCREMENT,
    cpu VARCHAR(50) NOT NULL,
    ram VARCHAR(50) NOT NULL,
    rom VARCHAR(50) NOT NULL,
    CR_id INT,
    FOREIGN KEY (CR_id) REFERENCES ComputerRoom(CR_id)
);

CREATE TABLE Subject (
    sub_id INT PRIMARY KEY AUTO_INCREMENT,
    sub_name VARCHAR(100) NOT NULL,
    duration INT NOT NULL
);

CREATE TABLE Registation (
    CR_id INT,
    sub_id INT,
    registration_date DATE NOT NULL,
    PRIMARY KEY (CR_id, sub_id),
    FOREIGN KEY (CR_id) REFERENCES ComputerRoom(CR_id),
    FOREIGN KEY (sub_id) REFERENCES Subject(sub_id)
);