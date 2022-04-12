CREATE DATABASE Lab05_QLTour;

USE Lab05_QLTour;

CREATE TABLE Tour
(
	MaTour CHAR(4) PRIMARY KEY NOT NULL,
	TongSoNgay INT
)

CREATE TABLE ThanhPho
(
	MaTP CHAR(2) PRIMARY KEY NOT NULL,
	TenTP NVARCHAR(50)
)

CREATE TABLE Tour_TP
(
	MaTour CHAR(4),
	MaTP CHAR(2) REFERENCES ThanhPho(MaTP),
	SoNgay INT
	PRIMARY KEY(MaTour, MaTP)
)
--SET DATEFORMAT dmy;
CREATE TABLE Lich_TourDL
(
	MaTour char(4) REFERENCES Tour(MaTour),
	NgayKH DATE,
	TenHDV NVARCHAR(50),
	SoNguoi INT,
	TenKH NVARCHAR(50)
	PRIMARY KEY(MaTour, NgayKH)
)

SELECT * FROM Tour
SELECT * FROM ThanhPho
SELECT * FROM Tour_TP
SELECT * FROM Lich_TourDL

----------XÂY DỰNG CÁC THỦ TỤC NHẬP DỮ LIỆU -------------
CREATE PROC usp_ThemTour
	@MaTour char(4), @TongSoNgay INT
As
	IF EXISTS(SELECT * FROM Tour WHERE MaTour = @MaTour) -- kiểm tra xem có trùng khóa không
	print N'Đã có Tour học ' +@MaTour+ N' trong CSDL!'
	ELSE
		BEGIN
			INSERT INTO Tour VALUES(@MaTour, @TongSoNgay)
			PRINT N'Thêm Tour thành công.'
		END
--goi thuc hien thu tuc usp_ThemTour ---
EXEC usp_ThemTour 'T001', 3
EXEC usp_ThemTour 'T002', 4
EXEC usp_ThemTour 'T003', 5
EXEC usp_ThemTour 'T004', 7
----------------------------------------
SELECT * FROM Tour