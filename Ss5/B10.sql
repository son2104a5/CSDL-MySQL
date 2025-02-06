SELECT
  CONCAT(p.FullName, ' (', TIMESTAMPDIFF(YEAR, p.DateOfBirth, a.AppointmentDate), ') - ', d.FullName) AS PatientDoctorInfo,
  a.AppointmentDate,
  mr.Diagnosis
FROM patients p
JOIN appointments a
  ON p.PatientID = a.PatientID
JOIN doctors d
  ON a.DoctorID = d.DoctorID
JOIN medicalrecords mr
  ON p.PatientID = mr.PatientID
ORDER BY
  a.AppointmentDate;
  
SELECT
  p.FullName AS PatientName,
  TIMESTAMPDIFF(YEAR, p.DateOfBirth, a.AppointmentDate) AS AgeAtAppointment,
  a.AppointmentDate,
  CASE
    WHEN TIMESTAMPDIFF(YEAR, p.DateOfBirth, a.AppointmentDate) > 50 THEN 'Nguy co cao'
    WHEN TIMESTAMPDIFF(YEAR, p.DateOfBirth, a.AppointmentDate) BETWEEN 30 AND 50 THEN 'Nguy co trung binh'
    ELSE 'Nguy co thap'
  END AS RiskLevel
FROM patients p
JOIN appointments a
  ON p.PatientID = a.PatientID ORDER BY a.AppointmentDate;
  
DELETE FROM Appointments
WHERE
  PatientID IN (
    SELECT
      p.PatientID
    FROM Patients p
    JOIN Appointments a
      ON p.PatientID = a.PatientID
    WHERE
      TIMESTAMPDIFF(YEAR, p.DateOfBirth, a.AppointmentDate) < 30
  )
  AND DoctorID IN (
    SELECT
      d.DoctorID
    FROM Doctors d
    WHERE
      d.Specialization IN ('Noi Tong Quat', 'Chan Thuong Chinh Hinh')
  );
SELECT
  p.FullName AS PatientName,
  d.Specialization,
  TIMESTAMPDIFF(YEAR, p.DateOfBirth, a.AppointmentDate) AS AgeAtAppointment
FROM Patients p
JOIN Appointments a
  ON p.PatientID = a.PatientID
JOIN Doctors d
  ON a.DoctorID = d.DoctorID;
