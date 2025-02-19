create table student_status(
	student_id int primary key,
    status enum('ACTIVE', 'GRADUATED', 'SUSPENSED'),
	foreign key (student_id) references students(student_id)
);

INSERT INTO student_status (student_id, status) VALUES
(1, 'ACTIVE'), -- Nguyễn Văn An có thể đăng ký
(2, 'GRADUATED'); -- Trần Thị Ba đã tốt nghiệp, không thể đăng ký

DELIMITER &&
create procedure register_course(
    in p_student_name varchar(50),
    in p_course_name varchar(100)
)
begin
    declare v_student_id int;
    declare v_course_id int;
    declare v_status enum('ACTIVE', 'GRADUATED', 'SUSPENDED');
    declare v_available_seats int;
    declare exit handler for sqlexception
    begin
        rollback;
        insert into enrollments_history (student_id, course_id, action)
        values (v_student_id, v_course_id, 'FAILED: Student not eligible');
        select 'error: student not eligible' as message;
    end;
    start transaction;
    select student_id into v_student_id from students where student_name = p_student_name;
    if v_student_id is null then
        rollback;
        insert into enrollments_history (student_id, course_id, action)
        values (null, null, 'FAILED: Student does not exist');
        select 'error: student does not exist' as message;
    end if;
    select course_id, available_seats into v_course_id, v_available_seats from courses where course_name = p_course_name;
    if v_course_id is null then
        rollback;
        insert into enrollments_history (student_id, course_id, action)
        values (v_student_id, null, 'FAILED: Course does not exist');
        select 'error: course does not exist' as message;
    end if;
    if exists (select 1 from enrollments where student_id = v_student_id and course_id = v_course_id) then
        rollback;
        insert into enrollments_history (student_id, course_id, action)
        values (v_student_id, v_course_id, 'FAILED: Already enrolled');
        select 'error: already enrolled' as message;
    end if;
    select status into v_status from student_status where student_id = v_student_id;
    if v_status in ('GRADUATED', 'SUSPENDED') then
        signal sqlstate '45000' set message_text = 'student not eligible';
    end if;
    if v_available_seats > 0 then
        insert into enrollments (student_id, course_id) values (v_student_id, v_course_id);
        update courses set available_seats = available_seats - 1 where course_id = v_course_id;
        insert into enrollments_history (student_id, course_id, action) values (v_student_id, v_course_id, 'REGISTERED');
        commit;
        select 'success: registered' as message;
    else
        rollback;
        insert into enrollments_history (student_id, course_id, action)
        values (v_student_id, v_course_id, 'FAILED: No available seats');
        select 'error: no available seats' as message;
    end if;
end &&
DELIMITER ;

call register_course('Nguyễn Văn An', 'Lập trình C');

select * from enrollments;
select * from courses;
select * from enrollments_history;