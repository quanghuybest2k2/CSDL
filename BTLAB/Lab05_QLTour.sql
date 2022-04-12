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
	print N'Đã có Tour ' +@MaTour+ N' trong CSDL!'
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
SELECT * FROM	Tour

-- Thu thi them thanh pho
CREATE PROC usp_ThemThanhPho
	@MaTP char(2), @TenTP NVARCHAR(50)
As
	IF EXISTS(SELECT * FROM ThanhPho WHERE MaTP = @MaTP) -- kiểm tra xem có trùng khóa không
	print N'Đã có thành phố ' +@MaTP+ N' trong CSDL!'
	ELSE
		BEGIN
			INSERT INTO ThanhPho VALUES(@MaTP, @TenTP)
			PRINT N'Thêm thành phố thành công.'
		END
--goi thuc hien thu tuc usp_ThemTour ---
EXEC usp_ThemThanhPho '01', N'Đà Lạt'
EXEC usp_ThemThanhPho '02', N'Nha Trang'
EXEC usp_ThemThanhPho '03', N'Phan Thiết'
EXEC usp_ThemThanhPho '04', N'Huế'
EXEC usp_ThemThanhPho '05', N'Đà Nẵng'

----------------------------------------
SELECT * FROM ThanhPho
-- Thu thi them Tour_TP
CREATE PROC usp_ThemTourTP
	@MaTour char(4), @MaTP CHAR(2), @SoNgay INT
As
	 If exists(select * from ThanhPho where MaTP = @MaTP) --kiểm tra có RBTV khóa ngoại
	  Begin
		if exists(select * from Tour_TP where MaTour = @MaTour) --kiểm tra có trùng khóa(SoBL) 
			print N'Đã có số biên lai học phí này trong CSDL!'
		else
		 begin
			insert into Tour_TP values(@MaTour, @MaTP, @SoNgay)
			print N'Thêm biên lai học phí thành công.'
		 end
	  End
	Else
		print N'Thành phố '+ @MaTP + N' không tồn tại trong CSDL nên không thể thêm Tour thành phố này!'

--goi thuc hien thu tuc usp_ThemTour ---
EXEC usp_ThemTourTP 'T001', '01', 2
EXEC usp_ThemTourTP 'T001', '03', 1
EXEC usp_ThemTourTP 'T002', '01', 2
EXEC usp_ThemTourTP 'T002', '02', 2
EXEC usp_ThemTourTP 'T003', '02', 2
EXEC usp_ThemTourTP 'T003', '01', 1
EXEC usp_ThemTourTP 'T003', '04', 2
EXEC usp_ThemTourTP 'T004', '02', 2
EXEC usp_ThemTourTP 'T004', '05', 2
EXEC usp_ThemTourTP 'T004', '04', 3

----------------------------------------
SELECT * FROM Tour_TP
