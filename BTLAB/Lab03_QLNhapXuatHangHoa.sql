/* Học phần: Cơ sở dữ liệu
   Ngày: 14/03/2022
   Người thực hiện: Đoàn Quang Huy
*/

CREATE DATABASE Lab03_QLNhapXuatHangHoa;

USE Lab03_QLNhapXuatHangHoa

CREATE TABLE HANGHOA
(
	MAHH CHAR(5) PRIMARY KEY NOT NULL,
	TENHH NVARCHAR(50),
	DVT NCHAR(3),
	SOLUONGTON INT
)

CREATE TABLE DOITAC
(
	MADT CHAR(5) PRIMARY KEY NOT NULL,
	TENDT NVARCHAR(50),
	DIACHI NVARCHAR(50),
	DIENTHOAI NVARCHAR(10) --dùng SELECT FORMAT(0234567890, '(000) 000-0000'); để format số điện thoại
)

CREATE TABLE KHANANGCC
(
	MADT CHAR(5) REFERENCES dbo.DOITAC(MADT),
	MAHH CHAR(5) REFERENCES dbo.HANGHOA(MAHH),
	PRIMARY KEY(MADT, MAHH)
)

CREATE TABLE HOADON
(
	SOHD CHAR(5) PRIMARY KEY NOT NULL,
	NGAYLAPHD DATE,
	MADT CHAR(5) REFERENCES dbo.DOITAC(MADT),
	TONGTG INT
)


CREATE TABLE CT_HOADON
(
	SOHD CHAR(5) REFERENCES dbo.HOADON(SOHD),
	MAHH CHAR(5) REFERENCES dbo.HANGHOA(MAHH),
	DONGIA INT,
	SOLUONG INT,
	PRIMARY KEY(SOHD, MAHH)
)

INSERT INTO dbo.HANGHOA VALUES
('CPU01', N'CPU INTEL,CELERON 600 BOX', N'CÁI', 5),
('CPU02', N'CPU INTEL,PIII 700', 'CÁI', 10),
('CPU03', N'CPU AMD K7 ATHL,ON 600', 'CÁI', 8),
('HDD01', N'HDD 10.2 GB QUANTUM', 'CÁI', 10),
('HDD02', N'HDD 13.6 GB SEAGATE', 'CÁI', 15),
('HDD03', N'HDD 20 GB QUANTUM', 'CÁI', 6),
('KB01', N'KB GENIUS', 'CÁI', 12),
('KB02', N'KB MITSUMIMI', 'CÁI', 5),
('MB01', N'GIGABYTE CHIPSET INTEL', 'CÁI', 10),
('MB02', N'ACOPR BX CHIPSET VIA', 'CÁI', 10),
('MB03', N'INTEL PHI CHIPSET INTEL', 'CÁI', 10),
('MB04', N'ECS CHIPSET SIS', 'CÁI', 10),
('MB05', N'ECS CHIPSET VIA', 'CÁI', 10),
('MNT01', N'SAMSUNG 14" SYNCMASTER', 'CÁI', 5),
('MNT02', N'LG 14"', 'CÁI', 5),
('MNT03', N'ACER 14"', 'CÁI', 8),
('MNT04', N'PHILIPS 14"', 'CÁI', 6),
('MNT05', N'VIEWSONIC 14"', 'CÁI', 7)

SELECT * FROM dbo.HANGHOA

INSERT INTO dbo.DOITAC VALUES
('CC001', N'Cty TNC', N'176 BTX Q1 - TPHCM', N'08.8250259'),
('CC002', N'Cty Hoàng Long', N'15A TTT Q1 – TP. HCM', N'08.8250898'),
('CC003', N'Cty Hợp Nhất', N'152 BTX Q1 – TP.HCM', N'08.8252376'),
('K0001', N'Nguyễn Minh Hải', N'91 Nguyễn Văn Trỗi Tp. Đà Lạt', N'063.831129'),
('K0002', N'Như Quỳnh', N'21 Điện Biên Phủ. N.Trang', N'058590270'),
('K0003', N'Trần nhật Duật', N'Lê Lợi TP. Huế', N'054.848376'),
('K0004', N'Phan Nguyễn Hùng Anh', N'11 Nam Kỳ Khởi nghĩa- TP. Đà lạt', N'063.823409')

SELECT * FROM dbo.DOITAC

insert into dbo.KHANANGCC values
('CC001', 'CPU01'),
('CC001', 'HDD03'),
('CC001', 'KB01'),
('CC001', 'MB02'),
('CC001', 'MB04'),
('CC001 ', 'MNT01'),
('CC002', 'CPU01'),
('CC002', 'CPU02'),
('CC002', 'CPU03'),
('CC002', 'KB02'),
('CC002', 'MB01'),
('CC002', 'MB05'),
('CC002', 'MNT03'),
('CC003', 'HDD01'),
('CC003', 'HDD02'),
('CC003', 'HDD03'),
('CC003', 'MB03')

select * from KHANANGCC

SET DATEFORMAT dmy; 
insert into HOADON values
('N0001', '25/01/2006', 'CC001',	null),
('N0002', '01/05/2006', 'CC002', null),
('X0001', '12/05/2006', 'K0001', null),
('X0002', '16/06/2006', 'K0002', null),
('X0003', '20/04/2006', 'K0001', null)

select * from HOADON

insert into CT_HOADON values
('N0001', 'CPU01', 63, 10),
('N0001', 'HDD03', 97, 7),
('N0001', 'KB01', 3, 5),
('N0001', 'MB02', 57, 5),
('N0001', 'MNT01', 112, 3),
('N0002', 'CPU02', 115, 3),
('N0002', 'KB02', 5, 7),
('N0002', 'MNT03', 111, 5),
('X0001', 'CPU01', 67, 2),
('X0001', 'HDD03', 100, 2),
('X0001', 'KB01', 5, 2),
('X0001', 'MB02', 62, 1),
('X0002', 'CPU01', 67, 1),
('X0002', 'KB02', 7, 3),
('X0002', 'MNT01', 115, 2),
('X0003', 'CPU01', 67, 1),
('X0003', 'MNT03', 115, 2)

select * from CT_HOADON

------------------- truy van csdl ---------------------------------
-- cau 1) Liệt kê các mặt hàng thuộc loại đĩa cứng.
select * from HANGHOA where MAHH like 'HDD%'
--cau 2) Liệt kê các mặt hàng có số lượng tồn trên 10.
select * from HANGHOA where SOLUONGTON > 10
-- cau 3) Cho biết thông tin về các nhà cung cấp ở Thành phố Hồ Chí Minh
select * from DOITAC where DIACHI like N'%HCM%'
-- cau 4) Liệt kê các hóa đơn nhập hàng trong tháng 5/2006, thông tin hiển thị gồm: sohd; ngaylaphd; tên, địa chỉ, và điện thoại của nhà cung cấp; số mặt hàng
select DISTINCT hd.SOHD, NGAYLAPHD, TENDT, DIACHI, DIENTHOAI
from HOADON hd, DOITAC dt, CT_HOADON cthd
where hd.MADT = dt.MADT and hd.SOHD = cthd.SOHD and MONTH(NGAYLAPHD) = 5 and YEAR(NGAYLAPHD) = 2006
--cau 5) Cho biết tên các nhà cung cấp có cung cấp đĩa cứng.
select hh.MAHH, TENHH, TENDT
from HANGHOA hh, DOITAC dt, KHANANGCC cc
where cc.MADT = dt.MADT and cc.MAHH = hh.MAHH and hh.MAHH like 'HDD%'
-- cau 6) Cho biết tên các nhà cung cấp có thể cung cấp tất cả các loại đĩa cứng.
--sai
select DISTINCT TENDT
from HANGHOA hh, DOITAC dt, KHANANGCC cc
where cc.MADT = dt.MADT and cc.MAHH = hh.MAHH AND hh.MAHH LIKE 'HDD%'
---- cach 2
SELECT DoiTac.TENDT,
       DoiTac.DIACHI,
       DoiTac.DIENTHOAI,
       COUNT(*) AS SoLoaiDiaCung
FROM dbo.KHANANGCC
JOIN dbo.DOITAC ON dbo.KHANANGCC.MADT = dbo.DOITAC.MADT
WHERE dbo.KHANANGCC.MAHH LIKE 'HDD%'
GROUP BY DoiTac.MADT,
         TENDT,
         DIACHI,
         DIENTHOAI
HAVING COUNT(*) = (SELECT COUNT(*)
					FROM HangHoa
					 WHERE MAHH LIKE 'HDD%');
-- cau 7) Cho biết tên nhà cung cấp không cung cấp đĩa cứng.
