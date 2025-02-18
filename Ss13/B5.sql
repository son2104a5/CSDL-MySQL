create table transaction_log(
	log_id int primary key auto_increment,
   	log_message text not null,
   	log_time timestamp default(current_time)
);

DELIMITER //

CREATE PROCEDURE paysalary(IN p_emp_id INT)
BEGIN
    DECLARE v_salary DECIMAL(10,2);
    DECLARE v_balance DECIMAL(15,2);
    DECLARE v_emp_exists INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        INSERT INTO transaction_log (log_message) VALUES ('lỗi trong quá trình chuyển lương');
    END;
    
    START TRANSACTION;
    
    SELECT COUNT(*) INTO v_emp_exists FROM employees WHERE emp_id = p_emp_id;
    IF v_emp_exists = 0 THEN
        INSERT INTO transaction_log (log_message) VALUES ('nhân viên không tồn tại');
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'nhân viên không tồn tại';
    END IF;
    
    SELECT salary INTO v_salary FROM employees WHERE emp_id = p_emp_id;
    
    SELECT balance INTO v_balance FROM company_funds WHERE fund_id = 1;
    IF v_balance < v_salary THEN
        INSERT INTO transaction_log (log_message) VALUES ('quỹ không đủ tiền');
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'quỹ không đủ tiền';
    END IF;
    
    UPDATE company_funds SET balance = balance - v_salary WHERE fund_id = 1;
    
    INSERT INTO payroll (emp_id, salary, pay_date) VALUES (p_emp_id, v_salary, CURDATE());
    
    INSERT INTO transaction_log (log_message) VALUES ('chuyển lương cho nhân viên thành công');
    
    COMMIT;
END //

DELIMITER ;

CALL PaySalary(1);
