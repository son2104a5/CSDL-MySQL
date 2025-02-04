Create Database QuanLyDiemSV CHARACTER SET utf8mb4 COLLATE utf8mb4_vietnamese_ci;
use QuanLyDiemSV;
/*=============DANH MUC KHOA==============*/
Create table DMKhoa(
	MaKhoa char(2) primary key,
	TenKhoa nvarchar(30)not null
);
/*==============DANH MUC SINH VIEN============*/
Create table DMSV(
MaSV char(3) not null primary key,
HoSV nvarchar(15) not null,
TenSV nvarchar(7)not null,
Phai nchar(7),
NgaySinh datetime not null,
NoiSinh nvarchar (20),
MaKhoa char(2),
HocBong float
);
/*===================MON HOC========================*/
create table DMMH(
MaMH char (2) not null,
TenMH nvarchar (25)not null,
SoTiet tinyint,
Constraint DMMH_MaMH_pk primary key(MaMH)
);
/*=====================KET QUA===================*/
Create table KetQua
(
MaSV char(3) not null,
MaMH char (2)not null ,
LanThi tinyint,
Diem decimal(4,2),
Constraint KetQua_MaSV_MaMH_LanThi_pk primary key (MaSV,MaMH,LanThi)
);
/*==========================TAO KHOA NGOAI==============================*/
Alter table dmsv
add Constraint DMKhoa_MaKhoa_fk foreign key (MaKhoa)
References DMKhoa (MaKhoa);
Alter table KetQua
add constraint KetQua_MaSV_fk foreign key (MaSV) references DMSV (MaSV);
Alter table KetQua
add constraint DMMH_MaMH_fk foreign key (MaMH) references DMMH (MaMH);
/*==================NHAP DU LIEU====================*/
/*==============NHAP DU LIEU DMMH=============*/
Insert into DMMH(MaMH,TenMH,SoTiet)
values('01','Cơ Sở Dữ Liệu',45);
Insert into DMMH(MaMH,TenMH,SoTiet)
values('02','Trí Tuệ Nhân Tạo',45);
Insert into DMMH(MaMH,TenMH,SoTiet)
values('03','Truyền Tin',45);
Insert into DMMH(MaMH,TenMH,SoTiet)
values('04','Đồ Họa',60);
Insert into DMMH(MaMH,TenMH,SoTiet)
values('05','Văn Phạm',60);
/*==============NHAP DU LIEU DMKHOA=============*/
Insert into DMKhoa(MaKhoa,TenKhoa)
values('AV','Anh Văn');
Insert into DMKhoa(MaKhoa,TenKhoa)
values('TH','Tin Học');
Insert into DMKhoa(MaKhoa,TenKhoa)
values('TR','Triết');
Insert into DMKhoa(MaKhoa,TenKhoa)
values('VL','Vật Lý');
/*==============NHAP DU LIEU DMSV=============*/
Insert into DMSV
values('A01','Nguyễn Thị','Hải','Nữ','1990-03-20','Hà Nội','TH',130000);
Insert into DMSV(MaSV,HoSV,TenSV,Phai,NgaySinh,NoiSinh,MaKhoa,HocBong)
values('A02','Trần Văn','Chính','Nam','1992-12-24','Bình Định','VL',150000);
Insert into DMSV(MaSV,HoSV,TenSV,Phai,NgaySinh,NoiSinh,MaKhoa,HocBong)
values('A03','Lê Thu Bạch','Yến','Nữ','1990-02-21','TP Hồ Chí Minh','TH',170000);
Insert into DMSV(MaSV,HoSV,TenSV,Phai,NgaySinh,NoiSinh,MaKhoa,HocBong)
values('A04','Trần Anh','Tuấn','Nam','1990-12-20','Hà Nội','AV',80000);
Insert into DMSV(MaSV,HoSV,TenSV,Phai,NgaySinh,NoiSinh,MaKhoa,HocBong)
values('B01','Trần Thanh','Mai','Nữ','1991-08-12','Hải Phòng','TR',0);
Insert into DMSV(MaSV,HoSV,TenSV,Phai,NgaySinh,NoiSinh,MaKhoa,HocBong)
values('B02','Trần Thị Thu','Thủy','Nữ','1991-01-02','TP Hồ Chí Minh','AV',0);
/*==============NHAP DU LIEU BANG KET QUA=============*/
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A01','01',1,3);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A01','01',2,6);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A01','02',2,6);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A01','03',1,5);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A02','01',1,4.5);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A02','01',2,7);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A02','03',1,10);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A02','05',1,9);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A03','01',1,2);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A03','01',2,5);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A03','03',1,2.5);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A03','03',2,4);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('A04','05',2,10);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('B01','01',1,7);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('B01','03',1,2.5);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('B01','03',2,5);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('B02','02',1,6);
Insert into KetQua(MaSV,MaMH,LanThi,Diem)
values('B02','04',1,10);

-- 1. Danh sách sinh viên sắp xếp theo Mã sinh viên tăng dần
SELECT MaSV, HoSV, TenSV, HocBong 
FROM DMSV 
ORDER BY MaSV;

-- 2. Danh sách sinh viên sắp xếp theo Nam/Nữ
SELECT MaSV, CONCAT(HoSV, ' ', TenSV) AS HoTen, Phai, NgaySinh 
FROM DMSV 
ORDER BY Phai DESC;

-- 3. Danh sách sinh viên sắp xếp theo Ngày sinh tăng dần và Học bổng giảm dần
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, NgaySinh, HocBong 
FROM DMSV 
ORDER BY NgaySinh ASC, HocBong DESC;

-- 4. Môn học có tên bắt đầu bằng chữ T
SELECT MaMH, TenMH, SoTiet 
FROM DMMH 
WHERE TenMH LIKE 'T%';

-- 5. Sinh viên có chữ cái cuối cùng trong tên là 'I'
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, NgaySinh, Phai 
FROM DMSV 
WHERE TenSV LIKE '%I';

-- 6. Khoa có ký tự thứ hai là 'N'
SELECT MaKhoa, TenKhoa 
FROM DMKhoa 
WHERE TenKhoa LIKE '_N%';

-- 7. Sinh viên có họ chứa chữ "Thị"
SELECT * FROM DMSV 
WHERE HoSV LIKE '%Thị%';

-- 8. Sinh viên có học bổng lớn hơn 100,000 sắp xếp theo Mã khoa giảm dần
SELECT MaSV, CONCAT(HoSV, ' ', TenSV) AS HoTen, MaKhoa, HocBong 
FROM DMSV 
WHERE HocBong > 100000 
ORDER BY MaKhoa DESC;

-- 9. Sinh viên có học bổng từ 150,000 trở lên và sinh ở Hà Nội
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, MaKhoa, NoiSinh, HocBong 
FROM DMSV 
WHERE HocBong >= 150000 AND NoiSinh = 'Hà Nội';

-- 10. Sinh viên của khoa Anh văn và Vật lý
SELECT MaSV, MaKhoa, Phai 
FROM DMSV 
WHERE MaKhoa IN ('AV', 'VL');

-- 11. Sinh viên có ngày sinh từ 01/01/1991 đến 05/06/1992
SELECT MaSV, NgaySinh, NoiSinh, HocBong 
FROM DMSV 
WHERE NgaySinh BETWEEN '1991-01-01' AND '1992-06-05';

-- 12. Sinh viên có học bổng từ 80,000 đến 150,000
SELECT MaSV, NgaySinh, Phai, MaKhoa 
FROM DMSV 
WHERE HocBong BETWEEN 80000 AND 150000;

-- 13. Môn học có số tiết lớn hơn 30 và nhỏ hơn 45
SELECT MaMH, TenMH, SoTiet 
FROM DMMH 
WHERE SoTiet > 30 AND SoTiet < 45;

-- 14. Sinh viên nam của khoa Anh văn và Tin học
SELECT MaSV, CONCAT(HoSV, ' ', TenSV) AS HoTen, MaKhoa, Phai 
FROM DMSV 
WHERE MaKhoa IN ('AV', 'TH') AND Phai = 'Nam';

-- 15. Sinh viên nữ có tên chứa chữ 'N'
SELECT * FROM DMSV 
WHERE Phai = 'Nữ' AND TenSV LIKE '%N%';

-- 16. Sinh viên sinh ở Hà Nội và sinh vào tháng 02
SELECT HoSV, TenSV, NoiSinh, NgaySinh 
FROM DMSV 
WHERE NoiSinh = 'Hà Nội' AND MONTH(NgaySinh) = 2;

-- 17. Sinh viên có tuổi lớn hơn 20
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) AS Tuoi, HocBong 
FROM DMSV 
WHERE TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) > 20;

-- 18. Sinh viên có tuổi từ 20 đến 25
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) AS Tuoi, MaKhoa 
FROM DMSV 
WHERE TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) BETWEEN 20 AND 25;

-- 19. Sinh viên sinh vào mùa xuân năm 1990
SELECT CONCAT(HoSV, ' ', TenSV) AS HoTen, Phai, NgaySinh 
FROM DMSV 
WHERE YEAR(NgaySinh) = 1990 AND MONTH(NgaySinh) BETWEEN 1 AND 3;

-- 20. Mức học bổng của sinh viên
SELECT MaSV, Phai, MaKhoa, 
       CASE WHEN HocBong > 500000 THEN 'Học bổng cao' ELSE 'Mức trung bình' END AS MucHocBong 
FROM DMSV;

-- 21. Tổng số sinh viên
SELECT COUNT(*) AS TongSV 
FROM DMSV;

-- 22. Tổng số sinh viên và tổng sinh viên nữ
SELECT COUNT(*) AS TongSV, SUM(CASE WHEN Phai = 'Nữ' THEN 1 ELSE 0 END) AS TongSVNu 
FROM DMSV;

-- 23. Tổng số sinh viên của từng khoa
SELECT MaKhoa, COUNT(*) AS TongSV 
FROM DMSV 
GROUP BY MaKhoa;

-- 24. Số lượng sinh viên học từng môn
SELECT MaMH, COUNT(DISTINCT MaSV) AS SoLuongSV 
FROM KetQua 
GROUP BY MaMH;

-- 25. Số lượng môn học mà sinh viên đã học
SELECT COUNT(DISTINCT MaMH) AS TongSoMon 
FROM KetQua;

-- 26. Tổng số học bổng của mỗi khoa
SELECT MaKhoa, SUM(HocBong) AS TongHocBong 
FROM DMSV 
GROUP BY MaKhoa;

-- 27. Học bổng cao nhất của mỗi khoa
SELECT MaKhoa, MAX(HocBong) AS HocBongCaoNhat 
FROM DMSV 
GROUP BY MaKhoa;

-- 28. Tổng số sinh viên nam và nữ của mỗi khoa
SELECT MaKhoa, 
       SUM(CASE WHEN Phai = 'Nam' THEN 1 ELSE 0 END) AS TongNam, 
       SUM(CASE WHEN Phai = 'Nữ' THEN 1 ELSE 0 END) AS TongNu 
FROM DMSV 
GROUP BY MaKhoa;

-- 29. Số lượng sinh viên theo từng độ tuổi
SELECT TIMESTAMPDIFF(YEAR, NgaySinh, CURDATE()) AS Tuoi, COUNT(*) AS SoLuongSV 
FROM DMSV 
GROUP BY Tuoi;

-- 30. Những năm sinh có đúng 2 sinh viên
SELECT YEAR(NgaySinh) AS NamSinh, COUNT(*) AS SoLuongSV 
FROM DMSV 
GROUP BY YEAR(NgaySinh) 
HAVING COUNT(*) = 2;
