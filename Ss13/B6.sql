create table enrollments_history (
    history_id int primary key auto_increment,
    student_id int,
    course_id int,
    action varchar(50),
    timestamp datetime default(current_timestamp),
    foreign key (student_id) references students(student_id),
    foreign key (course_id) references courses(course_id)
);

DELIMITER &&
create procedure enroll_student(
    in p_student_name varchar(50),
    in p_course_name varchar(100)
)
begin
    declare v_student_id int;
    declare v_course_id int;
    declare v_enrolled int;
    declare v_available_seats int;
    
    declare exit handler for sqlexception 
    begin
        rollback;
        insert into enrollments_history (student_id, course_id, action)
        values (v_student_id, v_course_id, 'failed');
    end;
    
    start transaction;
    
    select student_id into v_student_id from students where student_name = p_student_name;
    select course_id, available_seats into v_course_id, v_available_seats from courses where course_name = p_course_name;
    
    select count(*) into v_enrolled from enrollments where student_id = v_student_id and course_id = v_course_id;
    if v_enrolled > 0 then
        rollback;
    end if;
    
    if v_available_seats > 0 then
        insert into enrollments (student_id, course_id) values (v_student_id, v_course_id);
        update courses set available_seats = available_seats - 1 where course_id = v_course_id;
        insert into enrollments_history (student_id, course_id, action) values (v_student_id, v_course_id, 'registered');
        commit;
    else
        insert into enrollments_history (student_id, course_id, action) values (v_student_id, v_course_id, 'failed');
        rollback;
    end if;
end &&
DELIMITER ;

call enroll_student('nguyễn văn an', 'lập trình c');

select * from enrollments;
select * from courses;
select * from enrollments_history;