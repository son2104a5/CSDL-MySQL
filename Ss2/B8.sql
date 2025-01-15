/*
	a) Phân tích các vấn đề trong bảng:
		Thiếu ràng buộc khóa chính:

		Cột MaSV cần được xác định là khóa chính để đảm bảo tính duy nhất của mỗi sinh viên.
		Thiếu ràng buộc NOT NULL:

		Cả hai cột MaSV và Diem nên được khai báo NOT NULL để đảm bảo không có giá trị trống trong các cột này.
		Thiếu ràng buộc kiểm tra giá trị (CHECK):

		Cột Diem cần giới hạn giá trị trong khoảng 0 đến 10.
*/

-- b)
create table Score(
	stu_id varchar(100) not null primary key,
    score int not null check (score > 0 and score <= 10)
);