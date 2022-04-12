/*Người thực hiện: Đoàn Quang Huy
Lớp: CTK44B
Ngày 29/03/2022
*/

CREATE DATABASE Lab04_QLDatBao;

USE Lab04_QLDatBao;

CREATE TABLE BAO_TCHI
(
	MaBaoTC CHAR(4) PRIMARY KEY NOT NULL,
	Ten NVARCHAR(50),
	DinhKy NVARCHAR(50),
	SoLuong INT,
	GiaBan INT
)

CREATE TABLE PHATHANH
(
	MaBaoTC CHAR(4) REFERENCES dbo.BAO_TCHI(MaBaoTC),
	SoBaoTC INT,
	NgayPH DATE
	PRIMARY KEY(MaBaoTC, SoBaoTC)
)

CREATE TABLE KHACHHANG
(
	MaKH CHAR(4) PRIMARY KEY NOT NULL,
	TenKH NVARCHAR(10),
	DiaChi NVARCHAR(10)
)

CREATE TABLE DATBAO
(
	MaKH CHAR(4) REFERENCES dbo.KHACHHANG(MaKH),
	MaBaoTC CHAR(4) REFERENCES dbo.BAO_TCHI(MaBaoTC),
	SLMua INT,
	NgayDM DATE
	PRIMARY KEY(MaKH, MaBaoTC)
)

INSERT INTO dbo.BAO_TCHI VALUES
('TT01', N'Tuổi trẻ', N'Nhật báo', 1000, 1500),
('KT01', N'Kiến thức ngày nay', N'Bán nguyệt san', 3000, 6000),
('TN01', N'Thanh niên', N'Nhật báo', 1000,2000),
('PN01', N'Phụ nữ', N'Tuần báo', 2000, 4000),
('PN02', N'Phụ nữ', N'Nhật báo', 1000, 2000)

SELECT * FROM dbo.BAO_TCHI

INSERT INTO PHATHANH VALUES
('TT01', 123, '2005-12-15'),
('KT01', 70, '2005-12-15'),
('TT01', 124, '2005-12-16'),
('TN01', 256, '2005-12-17'),
('PN01', 45, '2005-12-23'),
('PN02', 111, '2005-12-18'),
('PN02', 112, '2005-12-19'),
('TT01', 125, '2005-12-17'),
('PN01', 46, '2005-12-30')

SELECT CONVERT(CHAR(10), NgayPH,103) FROM dbo.PHATHANH
SELECT * FROM dbo.PHATHANH

INSERT INTO KHACHHANG VALUES
('KH01', N'LAN', N'2 NCT'),
('KH02', N'NAM', N'32 THĐ'),
('KH03', N'NGỌC', N'16 LHP ')

SELECT * FROM dbo.KHACHHANG

INSERT INTO DATBAO VALUES
('KH01', 'TT01', 100, '2000-01-12'),
('KH02', 'TN01', 150, '2001-05-01'),
('KH01', 'PN01', 200, '2001-06-25'),
('KH03', 'KT01', 50, '2002-03-17'),
('KH03', 'PN02', 200, '2003-08-26'),
('KH02', 'TT01', 250, '2004-01-15'),
('KH01', 'KT01', 300, '2004-10-14')

SELECT * FROM dbo.DATBAO

----------- Truy vấn cơ sở dữ liệu
-- Câu 1) Cho biết các tờ báo, tạp chí (MABAOTC, TEN, GIABAN) có định kỳ phát hành hàng tuần (Tuần báo).
SELECT MaBaoTC, Ten, GiaBan
FROM dbo.BAO_TCHI
WHERE DinhKy = N'Tuần báo'
-- Câu 2) Cho biết thông tin về các tờ báo thuộc loại báo phụ nữ (mã báo tạp chí bắt đầu bằng PN).
SELECT *
FROM dbo.BAO_TCHI
WHERE MaBaoTC LIKE 'PN%'
-- Câu 3) Cho biết tên các khách hàng có đặt mua báo phụ nữ (mã báo tạp chí bắt đầu bằng PN), không liệt kê khách hàng trùng.
SELECT kh.TenKH AS KhachHangMuaBaoPN
FROM dbo.BAO_TCHI b, dbo.KHACHHANG kh, dbo.DATBAO db
WHERE db.MaKH = kh.MaKH AND db.MaBaoTC = b.MaBaoTC AND b.MaBaoTC LIKE 'PN%'
-- Câu 4) Cho biết tên các khách hàng có đặt mua tất cả các báo phụ nữ (mã báo tạp chí bắt đầu bằng PN).
SELECT kh.MaKH AS MaKH, kh.TenKH, kh.DiaChi 
FROM DatBao db, KhachHang kh WHERE kh.MaKH = db.MaKH and db.MaBaoTC LIKE 'PN%'
GROUP BY kh.MaKH, kh.TenKH, kh.DiaChi
HAVING COUNT(DISTINCT db.MaBaoTC) = (
SELECT COUNT(*)
FROM dbo.BAO_TCHI
WHERE MaBaoTC LIKE 'PN%');
-- Câu 5) Cho biết các khách hàng không đặt mua báo thanh niên.
SELECT *
FROM dbo.KHACHHANG
WHERE MaKH NOT IN ( SELECT MaKH
					FROM dbo.BAO_TCHI b, dbo.DATBAO db
					WHERE db.MaBaoTC = b.MaBaoTC AND b.Ten = N'Thanh niên')
					--
SELECT *
FROM KhachHang
WHERE MaKH NOT IN(
SELECT dbo.DATBAO.MaKH
FROM DatBao
WHERE dbo.DATBAO.MaBaoTC LIKE 'TN%')
-- Câu 6) Cho biết số tờ báo mà mỗi khách hàng đã đặt mua.
SELECT kh.MaKH, kh.TenKH, kh.DiaChi AS ThongTinKhachHang, SUM(db.SLMua) AS SoLuongMua
FROM dbo.KHACHHANG kh, dbo.DATBAO db
WHERE kh.MaKH = db.MaKH
GROUP BY kh.MaKH, kh.TenKH, kh.DiaChi
-- Câu 7) Cho biết số khách hàng đặt mua báo trong năm 2004.
SELECT COUNT(DISTINCT MaKH) AS SoKhachHang
FROM dbo.DATBAO
WHERE YEAR(NgayDM) = 2004
-- Câu 8) Cho biết thông tin đặt mua báo của các khách hàng (TenKH, Ten, DinhKy, SLMua, SoTien), trong đó SoTien = SLMua x DonGia
SELECT kh.TenKH, b.Ten, b.DinhKy, db.SLMua, db.SLMua * b.GiaBan AS SoTien
FROM dbo.BAO_TCHI b, dbo.KHACHHANG kh, dbo.DATBAO db
WHERE db.MaKH = kh.MaKH AND db.MaBaoTC = b.MaBaoTC
GROUP BY kh.TenKH, b.Ten, b.DinhKy, db.SLMua, db.SLMua * b.GiaBan
---
SELECT dbo.KHACHHANG.MaKH AS MaKH, dbo.KHACHHANG.TenKH AS TenKH, KhachHang.diaChi, dbo.BAO_TCHI.Ten AS TenBao, dbo.BAO_TCHI.DinhKy, SUM(soLuong) AS TongSoLuongMua, SUM(SLMua * giaBan) AS ThanhTien
FROM dbo.KHACHHANG
JOIN dbo.DATBAO ON dbo.KHACHHANG.MaKH = dbo.DATBAO.MaKH
JOIN dbo.BAO_TCHI ON dbo.BAO_TCHI.MaBaoTC = dbo.DATBAO.MaBaoTC
GROUP BY dbo.KHACHHANG.MaKH, dbo.KHACHHANG.TenKH, dbo.KHACHHANG.DiaChi, dbo.BAO_TCHI.MaBaoTC, dbo.BAO_TCHI.Ten, dbo.BAO_TCHI.DinhKy;
-- câu 9) Cho biết các tờ báo, tạp chí (Ten, DinhKy) và tổng số lượng đặt mua của các khách hàng đối với tờ báo, tạp chí đó.
SELECT b.Ten, b.DinhKy, SUM(db.SLMua) AS TongSoLuongMua
FROM dbo.BAO_TCHI b, dbo.DATBAO db
WHERE db.MaBaoTC = b.MaBaoTC
GROUP BY b.MaBaoTC, b.Ten, b.DinhKy
-- Câu 10) Cho biết tên các tờ báo dành cho học sinh, sinh viên (mã báo tạp chí bắt đầu bằng HS).
SELECT *
FROM dbo.BAO_TCHI
WHERE MaBaoTC LIKE 'HS%'
-- Câu 11) Cho biết những tờ báo không có người đặt mua.
SELECT *
FROM dbo.BAO_TCHI
WHERE dbo.BAO_TCHI.MaBaoTC NOT IN ( SELECT MaBaoTC FROM dbo.DATBAO)
-- Câu 12) Cho biết tên, định kỳ của những tờ báo có nhiều người đặt mua nhất.
SELECT b.Ten, b.DinhKy, SUM(db.SLMua) AS TongSoLuongMua
FROM dbo.BAO_TCHI b, dbo.DATBAO db
WHERE db.MaBaoTC = b.MaBaoTC
GROUP BY b.MaBaoTC, b.Ten, b.DinhKy
HAVING SUM(db.SLMua) >= ALL( SELECT SUM(SLMua)
								FROM dbo.DATBAO db, dbo.BAO_TCHI b
								WHERE db.MaBaoTC = b.MaBaoTC
								GROUP BY b.MaBaoTC, b.DinhKy)
-- Câu 13) Cho biết khách hàng đặt mua nhiều báo, tạp chí nhất.
SELECT kh.MaKH, kh.TenKH, kh.DiaChi, SUM(db.SLMua) AS TongSoLuongMua
FROM dbo.KHACHHANG kh, dbo.DATBAO db
WHERE db.MaKH = kh.MaKH
GROUP BY kh.MaKH, kh.TenKH, kh.DiaChi
HAVING SUM(db.SLMua) >= ALL( SELECT SUM(SLMua)
								FROM dbo.DATBAO GROUP BY dbo.DATBAO.MaKH)

---
SELECT kh.MaKH, kh.TenKH, kh.DiaChi, SUM(SLMua) AS TongSoLuongMua
FROM dbo.KHACHHANG kh
JOIN DatBao db ON kh.MaKH = db.MaKH
GROUP BY kh.MaKH, kh.TenKH, kh.DiaChi
HAVING SUM(db.SLMua) >= ALL(
SELECT SUM(SLMua)
FROM DatBao
GROUP BY dbo.DATBAO.MaKH
);
-- Câu 14) Cho biết các tờ báo phát hành định kỳ một tháng 2 lần.
SELECT *
FROM dbo.BAO_TCHI
WHERE DinhKy = N'Bán Nguyệt San'
------ sai
--SELECT ph.MaBaoTC, b.Ten, b.DinhKy
--FROM dbo.PHATHANH ph, dbo.BAO_TCHI b
--WHERE b.MaBaoTC = ph.MaBaoTC
--GROUP BY ph.MaBaoTC, b.Ten, b.DinhKy
--HAVING COUNT(ph.MaBaoTC) = 2
-- Câu 15) Cho biết các tờ báo, tạp chi có từ 3 khách hàng đặt mua trở lên.
SELECT b.MaBaoTC AS MaBaoTapChi, b.Ten, b.DinhKy, COUNT(DISTINCT db.MaKH) AS SoLuongMua
FROM dbo.DATBAO db
JOIN dbo.BAO_TCHI b ON b.MaBaoTC = db.MaBaoTC
GROUP BY b.MaBaoTC, b.Ten, b.DinhKy
HAVING COUNT(DISTINCT db.MaKH) >= 3
--- Hàm và thủ tục
--Viết các hàm sau
-- a) Tính tổng số tiền mua báo/tạp chí của một khách hàng cho trước.
SELECT kh.MaKH, kh.TenKH, SUM(db.SLMua * b.GiaBan) AS TongSoLuongMua
FROM dbo.KHACHHANG kh, dbo.DATBAO db, dbo.BAO_TCHI b
WHERE db.MaKH = kh.MaKH AND b.MaBaoTC = db.MaBaoTC
GROUP BY kh.MaKH, kh.TenKH
----

CREATE function TongTienMua(@makh char(4)) returns int
As
Begin
	declare @TongTien int
	if exists (select * FROM dbo.KHACHHANG where MaKH = @makh) ---Nếu tồn tại lớp @malop trong CSDL
		Begin
		--Tính tổng số học phí thu được trên 1 lớp
		select @TongTien = SUM(db.SLMua * b.GiaBan)
		from	dbo.KHACHHANG kh, dbo.DATBAO db, dbo.BAO_TCHI b
		where	db.MaKH = kh.MaKH AND b.MaBaoTC = db.MaBaoTC AND db.MaKH=@maKH
		GROUP BY kh.MaKH
		
		END	
		RETURN @TongTien
END
PRINT N'Kết quả: ' + CONVERT(CHAR(10),dbo.TongTienMua('KH02'))


-- b) Tính tổng số tiền thu được của một tờ báo/tạp chí cho trước

-- Viết các thủ tục sau
-- a) In danh mục báo, tạp chí phải giao cho một khách hàng cho trước.

-- b) In danh sách khách hàng đặt mua báo/tạp chí cho trước.


-----

--HÀM
--a.Tính tổng số tiền mua báo/tạp chí của một khách hàng cho trước
CREATE FUNCTION tongTienMuaBao(@maKH CHAR(5))
RETURNS INT
AS
BEGIN
    DECLARE @tongTien INT
	SELECT @tongTien=SUM(db.SLMua*bc.GiaBan)
	FROM dbo.DATBAO db,dbo.BAO_TCHI bc
	WHERE @maKH=db.MaKH AND db.MaBaoTC=bc.MaBaoTC
	RETURN @tongTien
END

PRINT  dbo.tongTienMuaBao('KH01')

--b.Tính tổng số tiền thu được của một tờ báo/tạp chí cho trước.
CREATE FUNCTION tongTienBaoTapChi(@maBao CHAR(5))
RETURNS int
AS
 BEGIN
     DECLARE @tongTien INT
	 SELECT @tongTien = SUM(db.SLMua*bc.GiaBan)
	 FROM dbo.BAO_TCHI bc, dbo.DATBAO db
	 WHERE @maBao=db.MaBaoTC AND db.MaBaoTC=bc.MaBaoTC
	 RETURN @tongTien
 END

 PRINT dbo.tongTienBaoTapChi('TT01')

 --THỦ TỤC
 --a.In danh mục báo, tạp chí phải giao cho một khách hàng cho trước
 CREATE PROC usp_DanhMucBTC @maKH CHAR(5)
 AS
	IF EXISTS (SELECT * FROM dbo.KHACHHANG WHERE MaKH=@maKH)
	BEGIN
	     SELECT db.MaKH,kh.TenKH,kh.DiaChi,db.MaBaoTC,db.SLMua
		 FROM dbo.DATBAO db,dbo.KHACHHANG kh
		 WHERE db.MaKH=kh.MaKH AND db.MaKH=@maKH
	END
	ELSE
	PRINT(N'Mã khách hàng không tồn tại')
	go
EXEC usp_DanhMucBTC 'KH01'

--b.In danh sách khách hàng đặt mua báo/tạp chí cho trước.
CREATE PROC usp_DanhSachKHMua @maBao CHAR(5)
AS 
	IF EXISTS (SELECT * FROM dbo.BAO_TCHI WHERE MaBaoTC = @maBao)
	BEGIN
	    SELECT kh.MaKH,kh.TenKH,db.SLMua,kh.DiaChi,db.NgayDM
		FROM dbo.KHACHHANG kh, dbo.DATBAO db
		WHERE db.MaKH=kh.MaKH AND db.MaBaoTC=@maBao
	END
	ELSE 
	PRINT(N'Không tồn tại mã báo/tạp chí')
	GO
    
	EXEC usp_DanhSachKHMua 'TT01'
