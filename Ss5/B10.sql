SELECT
  CONCAT(p.FullName, ' (', TIMESTAMPDIFF(YEAR, p.DateOfBirth, a.AppointmentDate), ') - ', d.FullName) AS PatientDoctorInfo,
  a.AppointmentDate AS AppointmentDate,
  mr.Diagnosis AS Diagnosis
FROM patients AS p
JOIN appointments AS a
  ON p.PatientID = a.PatientID
JOIN doctors AS d
  ON a.DoctorID = d.DoctorID
JOIN medicalrecords AS mr
  ON p.PatientID = mr.PatientID
ORDER BY
  a.AppointmentDate;
  
SELECT
  p.FullName AS PatientName,
  TIMESTAMPDIFF(YEAR, p.DateOfBirth, a.AppointmentDate) AS AgeAtAppointment,
  a.AppointmentDate AS AppointmentDate,
  CASE
    WHEN TIMESTAMPDIFF(YEAR, p.DateOfBirth, a.AppointmentDate) > 50
    THEN 'Nguy co cao'
    WHEN TIMESTAMPDIFF(YEAR, p.DateOfBirth, a.AppointmentDate) >= 30
    AND TIMESTAMPDIFF(YEAR, p.DateOfBirth, a.AppointmentDate) <= 50
    THEN 'Nguy co trung binh'
    ELSE 'Nguy co thap'
  END AS RiskLevel
FROM patients AS p
JOIN appointments AS a
  ON p.PatientID = a.PatientID ORDER BY a.AppointmentDate;
  
DELETE FROM Appointments
WHERE
  PatientID IN (
    SELECT
      p.PatientID
    FROM Patients AS p
    JOIN Appointments AS a
      ON p.PatientID = a.PatientID
    WHERE
      TIMESTAMPDIFF(YEAR, p.DateOfBirth, a.AppointmentDate) < 30
  )
  AND DoctorID IN (
    SELECT
      d.DoctorID
    FROM Doctors AS d
    WHERE
      d.Specialization IN ('Noi Tong Quat', 'Chan Thuong Chinh Hinh')
  );
SELECT
  p.FullName AS PatientName,
  d.Specialization AS Specialization,
  TIMESTAMPDIFF(YEAR, p.DateOfBirth, a.AppointmentDate) AS AgeAtAppointment
FROM Patients AS p
JOIN Appointments AS a
  ON p.PatientID = a.PatientID
JOIN Doctors AS d
  ON a.DoctorID = d.DoctorID;