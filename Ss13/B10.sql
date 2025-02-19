CREATE TABLE course_fees (
    course_id INT PRIMARY KEY,
    fee DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

CREATE TABLE student_wallets (
    student_id INT PRIMARY KEY,
    balance DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

INSERT INTO course_fees (course_id, fee) VALUES
(1, 100.00), -- Lập trình C: 100$
(2, 150.00); -- Cơ sở dữ liệu: 150$

INSERT INTO student_wallets (student_id, balance) VALUES
(1, 200.00), -- Nguyễn Văn An có 200$
(2, 50.00);  -- Trần Thị Ba chỉ có 50$

DELIMITER &&
create procedure registerCourseStudent(
	p_student_name VARCHAR(50),
    p_course_name VARCHAR(100)
)
begin
    declare v_student_id int;
    declare v_course_id int;
    declare v_available_seats int;
    declare v_balance decimal(10,2);
    declare v_fee decimal(10,2);
    declare exit handler for sqlexception
    begin
        rollback;
        insert into enrollments_history (student_id, course_id, action)
        values (v_student_id, v_course_id, 'FAILED: Transaction error');
        select 'error: transaction error' as message;
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
    if v_available_seats <= 0 then
        rollback;
        insert into enrollments_history (student_id, course_id, action)
        values (v_student_id, v_course_id, 'FAILED: No available seats');
        select 'error: no available seats' as message;
    end if;
    select balance into v_balance from student_wallets where student_id = v_student_id;
    select fee into v_fee from course_fees where course_id = v_course_id;
    if v_balance < v_fee then
        rollback;
        insert into enrollments_history (student_id, course_id, action)
        values (v_student_id, v_course_id, 'FAILED: Insufficient balance');
        select 'error: insufficient balance' as message;
    end if;
    insert into enrollments (student_id, course_id) values (v_student_id, v_course_id);
    update student_wallets set balance = balance - v_fee where student_id = v_student_id;
    update courses set available_seats = available_seats - 1 where course_id = v_course_id;
    insert into enrollments_history (student_id, course_id, action) values (v_student_id, v_course_id, 'REGISTERED');
    commit;
    select 'success: registered' as message;
end &&
DELIMITER ;

call studentRegisterCourse('Nguyễn Văn An', 'Tin học cơ sở');

select * from student_wallets;