DELIMITER //
CREATE PROCEDURE GetDoctorDetails (
    IN input_doctor_id INT
)
BEGIN
    DECLARE doctor_name VARCHAR(100);
    DECLARE specialization_value VARCHAR(100);
    DECLARE total_patients INT;
    DECLARE total_revenue DECIMAL(15, 2);
    DECLARE total_medicines_prescribed INT;

    SELECT name, specialization INTO doctor_name, specialization_value
    FROM doctors
    WHERE doctor_id = input_doctor_id;

    SELECT COUNT(DISTINCT patient_id) INTO total_patients
    FROM appointments
    WHERE doctor_id = input_doctor_id;

    SELECT COUNT(*) * 50 INTO total_revenue
    FROM appointments
    WHERE doctor_id = input_doctor_id;

    SELECT COUNT(*) INTO total_medicines_prescribed
    FROM appointments a
    JOIN prescriptions p ON a.appointment_id = p.appointment_id
    WHERE a.doctor_id = input_doctor_id;

    SELECT doctor_name AS doctor_name,
           specialization_value AS specialization,
           total_patients AS total_patients,
           total_revenue AS total_revenue,
           total_medicines_prescribed AS total_medicines_prescribed;
END //
DELIMITER ;

CREATE TABLE cancellation_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    log_message VARCHAR(255),
    log_date DATETIME
);

CREATE TABLE appointment_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    log_message VARCHAR(255) NOT NULL,
    log_date DATETIME NOT NULL
);

DELIMITER &&
CREATE TRIGGER after_appointment_delete
AFTER DELETE ON appointments
FOR EACH ROW
BEGIN
    DELETE FROM prescriptions WHERE appointment_id = OLD.appointment_id;

    IF OLD.status = 'Cancelled' THEN
        INSERT INTO cancellation_logs (appointment_id, log_message, log_date)
        VALUES (OLD.appointment_id, 'Cancelled appointment was deleted', NOW());
    END IF;

    IF OLD.status = 'Completed' THEN
        INSERT INTO appointment_logs (appointment_id, log_message, log_date)
        VALUES (OLD.appointment_id, 'Completed appointment was deleted', NOW());
    END IF;
END &&
DELIMITER ;

CREATE VIEW FullRevenueReport AS
SELECT
    d.doctor_id,
    d.name AS doctor_name,
    (SELECT COUNT(*) FROM appointments WHERE doctor_id = d.doctor_id) AS total_appointments,
    (SELECT COUNT(DISTINCT patient_id) FROM appointments WHERE doctor_id = d.doctor_id) AS total_patients,
    (SELECT COUNT(*) * 50 FROM appointments WHERE doctor_id = d.doctor_id AND status = 'Completed') AS total_revenue,
    (SELECT COUNT(*) FROM appointments a JOIN prescriptions p ON a.appointment_id = p.appointment_id WHERE a.doctor_id = d.doctor_id) AS total_medicines
FROM
    doctors d;
    
CALL GetDoctorDetails(1);

INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) VALUES (1, 1, NOW(), 'Cancelled');
INSERT INTO prescriptions (appointment_id, medicine_name, dosage, duration) VALUES (3, 'MedicineA', '10mg', '7 days');

DELETE FROM appointments WHERE appointment_id = 3;

INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) VALUES (2, 2, NOW(), 'Completed');
INSERT INTO prescriptions (appointment_id, medicine_name, dosage, duration) VALUES (2, 'MedicineB', '20mg', '14 days');

DELETE FROM appointments WHERE appointment_id = 2;

SELECT * FROM FullRevenueReport;