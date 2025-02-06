delete from appointments
where appointmentdate < curdate() 
and doctorid not in (select doctorid from doctors where fullname = 'Phan Huong');
select a.appointmentid, 
       p.fullname as patientname, 
       d.fullname as doctorname, 
       a.appointmentdate, 
       a.status
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
order by a.appointmentdate;

update appointments
set status = 'Dang cho'
where appointmentdate >= curdate() 
and patientid in (select patientid from patients where fullname = 'Nguyen Van An')
and doctorid in (select doctorid from doctors where fullname = 'Phan Huong');
select a.appointmentid, 
       p.fullname as patientname, 
       d.fullname as doctorname, 
       a.appointmentdate, 
       a.status
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
order by a.appointmentdate;

select p.fullname as PatientName, 
       d.fullname as DoctorName, 
       a.appointmentdate, 
       mr.diagnosis
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
join medicalrecords mr on p.patientid = mr.patientid
where (p.patientid, d.doctorid) in (
    select patientid, doctorid 
    from appointments 
    group by patientid, doctorid 
    having count(*) >= 2
)
order by p.fullname, d.fullname, a.appointmentdate;

select upper(concat('BỆNH NHÂN: ', p.fullname, ' - BÁC SĨ: ', d.fullname)) as PatientDoctorInfo, 
       a.appointmentdate, 
       mr.diagnosis, 
       a.status
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
join medicalrecords mr on p.patientid = mr.patientid
order by a.appointmentdate;