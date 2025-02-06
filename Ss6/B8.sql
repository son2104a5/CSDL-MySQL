select
	s.student_id, s.name as student_name, s.email, c.course_name, e.enrollment_date
from enrollments e
join students s on s.student_id = e.student_id
join courses c on c.course_id = e.course_id
where e.student_id in (
	select e.student_id from enrollments e
    group by e.student_id
    having count(distinct course_id) > 1
)
order by s.student_id, e.enrollment_date;

select 
    s.name as student_name, 
    s.email, 
    e.enrollment_date, 
    c.course_name, 
    c.fee
from enrollments e
join students s on e.student_id = s.student_id
join courses c on e.course_id = c.course_id
where e.course_id = (
    select e2.course_id
    from enrollments e2
    join students s2 on e2.student_id = s2.student_id
    where s2.name = 'nguyen van an'
)
and s.name <> 'nguyen van an'
order by e.enrollment_date;

select 
    c.course_name, 
    c.duration, 
    c.fee, 
    count(e.student_id) as total_students
from enrollments e
join courses c on e.course_id = c.course_id
group by c.course_id, c.course_name, c.duration, c.fee
having count(e.student_id) > 2
order by total_students desc;

select 
    s.name as student_name, 
    s.email, 
    sum(c.fee) as total_fee_paid, 
    count(e.course_id) as courses_count
from enrollments e
join students s on e.student_id = s.student_id
join courses c on e.course_id = c.course_id
group by s.student_id, s.name, s.email
having count(e.course_id) >= 2 
and min(c.duration) > 30;
