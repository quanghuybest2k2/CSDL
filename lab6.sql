/* Học phần: cơ sở dữ liệu
   Người thực hiện: Đoàn Quang Huy
   Ngày: 19/04/2022
*/	
----------ĐỊNH NGHĨA CƠ SỞ DỮ LIỆU----------------
create database Lab06_QLHocVien_2015597
go
use Lab06_QLHocVien_2015597
go
create table CaHoc
(Ca			tinyint primary key,
GioBatDau	Datetime,
GioKetThuc	Datetime
)
go
create table GiaoVien
(MSGV		char(4) primary key,
HoGV		nvarchar(20),
TenGV		nvarchar(10),
DienThoai	varchar(11)
)
go
create table Lop
(MaLop	char(4) primary key,
TenLop	nvarchar(30),
NgayKG	Datetime,
HocPhi	int,
Ca		tinyint references CaHoc(Ca),
SoTiet	int,
SoHV	int,
MSGV	char(4) references GiaoVien(MSGV)
)
go
create table HocVien
(MSHV		char(6) primary key,
Ho			nvarchar(20),
Ten			nvarchar(10),
NgaySinh	Datetime,
Phai		nvarchar(4),
MaLop		char(4) references Lop(MaLop)
)

go
create table HocPhi
(
SoBL	char(4) primary key,
MSHV	char(6) references HocVien(MSHV),
NgayThu Datetime,
SoTien	int,
NoiDung	nvarchar(50),
NguoiThu nvarchar(30)
)
go
-------------------
select * from CaHoc
select * from GiaoVien
select * from Lop
select * from HocVien
select * from HocPhi

----------XÂY DỰNG CÁC THỦ TỤC NHẬP DỮ LIỆU (Câu 5a) -------------
CREATE PROC usp_ThemCaHoc
	@ca tinyint, @giobd Datetime, @giokt Datetime
As
	If exists(select * from CaHoc where Ca = @ca) --kiểm tra có trùng khóa chính (Ca) 
		print N'Đã có ca học ' +@ca+ N' trong CSDL!'
	Else
		begin
			insert into CaHoc values(@ca, @giobd, @giokt)
			print N'Thêm ca học thành công.'
		end
go
--goi thuc hien thu tuc usp_ThemCaHoc---
exec usp_ThemCaHoc 1,'7:30','10:45'
exec usp_ThemCaHoc 2,'13:30','16:45'
exec usp_ThemCaHoc 3,'17:30','20:45'


SELECT CONVERT(VARCHAR(8), GioBatDau, 108) 'hh:mi:ss' from CaHoc
SELECT CONVERT(VARCHAR(8), GioKetThuc, 108) 'hh:mi:ss' from CaHoc
---------------------
CREATE PROC usp_ThemGiaoVien
	@msgv char(4), @hogv nvarchar(20), @Tengv nvarchar(10),@dienthoai varchar(11)
As
	If exists(select * from GiaoVien where MSGV = @msgv) --kiểm tra có trùng khóa chính (MSGV) 
		print N'Đã có giáo viên có mã số ' +@msgv+ N' trong CSDL!'
	Else
		begin
			insert into GiaoVien values(@msgv, @hogv, @Tengv, @dienthoai)
			print N'Thêm giáo viên thành công.'
		end
go
--goi thuc hien thu tuc usp_ThemGiaoVien---
exec usp_ThemGiaoVien 'G001',N'Lê Hoàng',N'Anh', '858936'
exec usp_ThemGiaoVien 'G002',N'Nguyễn Ngọc',N'Lan', '845623'
exec usp_ThemGiaoVien 'G003',N'Trần Minh',N'Hùng', '823456'
exec usp_ThemGiaoVien 'G004',N'Võ Thanh',N'Trung', '841256'
---------------------
create PROC usp_ThemLopHoc
@malop char(4), @Tenlop nvarchar(20), 
@NgayKG datetime,@HocPhi int, @Ca tinyint, @sotiet int, @sohv int, 
@msgv char(4)
As
	If exists(select * from CaHoc where Ca = @Ca) and exists(select * from GiaoVien where MSGV=@msgv)--kiểm tra các RBTV khóa ngoại
	  Begin
		if exists(select * from Lop where MaLop = @malop) --kiểm tra có trùng khóa chính của quan hệ Lop 
			print N'Đã có lớp '+ @MaLop +' trong CSDL!'
		else	
			begin
				insert into Lop values(@malop, @Tenlop, @NgayKG, @HocPhi, @Ca, @sotiet, @sohv, @msgv)
				print N'Thêm lớp học thành công.'
			end
	  End
	Else -- Bị vi phạm ràng buộc khóa ngoại
		if not exists(select * from CaHoc where Ca = @Ca)
				print N'Không có ca học '+@Ca+' trong CSDL.'
		else	print N'Không có giáo viên '+@msgv+' trong CSDL.'
go
--goi thuc hien thu tuc usp_ThemLopHoc---
set dateformat dmy
go
exec usp_ThemLopHoc 'A075',N'Access 2-4-6','18/12/2008', 150000,3,60,3,'G003'
exec usp_ThemLopHoc 'E114',N'Excel 3-5-7','02/01/2008', 120000,1,45,3,'G003'
exec usp_ThemLopHoc 'A115',N'Excel 2-4-6','22/01/2008', 120000,3,45,0,'G001'
exec usp_ThemLopHoc 'W123',N'Word 2-4-6','18/02/2008', 100000,3,30,1,'G001'
exec usp_ThemLopHoc 'W124',N'Word 3-5-7','01/03/2008', 100000,1,30,0,'G002'
----------------------
create PROC usp_ThemHocVien
@MSHV char(6), @Ho nvarchar(20), @Ten nvarchar(20),
@NgaySinh Datetime, @Phai	nvarchar(4),@MaLop char(4)
As
	If exists(select * from Lop where MaLop = @MaLop) --kiểm tra có RBTV khóa ngoại
	  Begin
		if exists(select * from HocVien where MSHV = @MSHV) --kiểm tra có trùng khóa chính (MAHV) 
			print N'Đã có mã số học viên này trong CSDL!'
		else
			begin
				insert into HocVien values(@MSHV,@Ho, @Ten,@NgaySinh,@Phai,@MaLop)
				print N'Thêm học viên thành công.'
			end
	  End
	Else
		print N'Lớp '+ @MaLop + N' không tồn tại trong CSDL nên không thể thêm học viên vào lớp này!'
		
go
----goi thuc hien thu tuc usp_ThemHocVien-------
set dateformat dmy
go
exec usp_ThemHocVien 'A07501',N'Lê Văn', N'Minh', '10/06/1988',N'Nam', 'A075'
exec usp_ThemHocVien 'A07502',N'Nguyễn Thị', N'Mai', '20/04/1988',N'Nữ', 'A075'
exec usp_ThemHocVien 'A07503',N'Lê Ngọc', N'Tuấn', '10/06/1984',N'Nam', 'A075'
exec usp_ThemHocVien 'E11401',N'Vương Tuấn', N'Vũ', '25/03/1979',N'Nam', 'E114'
exec usp_ThemHocVien 'E11402',N'Lý Ngọc', N'Hân', '01/12/1985',N'Nữ', 'E114'
exec usp_ThemHocVien 'E11403',N'Trần Mai', N'Linh', '04/06/1980',N'Nữ', 'E114'
exec usp_ThemHocVien 'W12301',N'Nguyễn Ngọc', N'Tuyết', '12/05/1986',N'Nữ', 'W123'
----------------------------
create PROC usp_ThemHocPhi
@SoBL char(4),
@MSHV char(6),
@NgayThu Datetime,
@SoTien	int,
@NoiDung nvarchar(50),
@NguoiThu nvarchar(30)
As
	If exists(select * from HocVien where MSHV = @MSHV) --kiểm tra có RBTV khóa ngoại
	  Begin
		if exists(select * from HocPhi where SoBL = @SoBL) --kiểm tra có trùng khóa(SoBL) 
			print N'Đã có số biên lai học phí này trong CSDL!'
		else
		 begin
			insert into HocPhi values(@SoBL,@MSHV,@NgayThu, @SoTien, @NoiDung,@NguoiThu)
			print N'Thêm biên lai học phí thành công.'
		 end
	  End
	Else
		print N'Học viên '+ @MSHV + N' không tồn tại trong CSDL nên không thể thêm biên lai học phí của học viên này!'
go
----goi thuc hien thu tuc usp_ThemHocPhi-------
set dateformat dmy
go
exec usp_ThemHocPhi '0001','A07501','16/12/2008',150000,'HP Access 2-4-6', N'Lan'
exec usp_ThemHocPhi '0002', 'A07502','16/12/2008',100000,'HP Access 2-4-6', N'Lan'
exec usp_ThemHocPhi '0003', 'A07503','18/12/2008',150000,'HP Access 2-4-6', N'Vân'
exec usp_ThemHocPhi '0002', 'A07504','15/01/2009',50000,'HP Access 2-4-6', N'Vân'
exec usp_ThemHocPhi '0004','E11401','02/01/2008',120000,'HP Excel 3-5-7', N'Vân'
exec usp_ThemHocPhi '0005','E11402','02/01/2008',120000,'HP Excel 3-5-7', N'Vân'
exec usp_ThemHocPhi '0006','E11403','02/01/2008',80000,'HP Excel 3-5-7', N'Vân'
exec usp_ThemHocPhi '0007','W12301','18/02/2008',100000,'HP Word 2-4-6', N'Lan'


------------------XÂY DỰNG CÁC THỦ TỤC SỬA DỮ LIỆU----------
--b.Cập nhật thông tin của một học viên cho trước

CREATE PROC usp_UpdateHocVien @mshv CHAR(6),@ho nvarchar(20),@ten nvarchar(20),@ns datetime,@phai nvarchar(4),@malop CHAR(4)
AS
	IF EXISTS (SELECT * FROM dbo.HocVien WHERE MSHV=@mshv) AND EXISTS (SELECT * FROM dbo.Lop WHERE MaLop=@malop)
		BEGIN
		    UPDATE dbo.HocVien SET Ho=@ho,Ten=@ten,NgaySinh=@ns,Phai=@phai,MaLop=@malop WHERE MSHV=@mshv
			PRINT N'Cập nhật dữ liệu của học viên '+@mshv+N' thành công'
			SELECT * FROM dbo.HocVien WHERE MSHV=@mshv
		END
	ELSE 
		BEGIN
			IF NOT EXISTS(SELECT * FROM dbo.HocVien WHERE MSHV=@mshv)
				PRINT N'Không tìm thấy thông tin của học viên có mã số '+@mshv+N' trong CSDL'
			ELSE
				PRINT N'Không tồn tại lớp' +@malop+N'Trong CSDL'
		END
go
set dateformat dmy
---------------------------
--DROP PROC dbo.usp_UpdateHocVien
exec usp_UpdateHocVien 'A07501',N'Lê Văn', N'Minh','06/10/1998','Nam','A075'
exec usp_UpdateHocVien 'A07502',N'Nguyễn Thị', N'Mai','20/04/1998',N'Nữ','A075'
exec usp_UpdateHocVien 'A07503',N'Lê Ngọc', N'Tuấn','10/06/1994',N'Nam','A075'
exec usp_UpdateHocVien 'E11401',N'Vương Tuấn', N'Vũ', '25/03/1999',N'Nam', 'E114'
exec usp_UpdateHocVien 'E11402',N'Lý Ngọc', N'Hân', '01/12/1995',N'Nữ', 'E114'
exec usp_UpdateHocVien 'E11403',N'Trần Mai', N'Linh', '04/06/1990',N'Nữ', 'E114'
exec usp_UpdateHocVien 'W12301',N'Nguyễn Ngọc', N'Tuyết', '12/05/1996',N'Nữ', 'W123'

SELECT * FROM dbo.HocVien
--c.Xóa một học viên cho trước
CREATE PROC usp_DeleteHocVien @mshv CHAR(6)
AS
	IF EXISTS(SELECT * FROM dbo.HocVien WHERE MSHV=@mshv)
		BEGIN
			DELETE FROM dbo.HocPhi WHERE MSHV=@mshv
		    DELETE FROM dbo.HocVien WHERE MSHV=@mshv
			PRINT N'Đã xóa thành công học viên '+@mshv+N' ra khỏi CSDL'
		END
	ELSE 
		PRINT N'Không tồn tại học viên '+@mshv+N' Trong CSDL'
	
--------------------------
EXEC usp_DeleteHocVien 'W12301'

SELECT * FROM dbo.HocVien
--d.Cập nhật thông tin của một lớp học cho trước
CREATE PROC usp_UpdateLop @malop CHAR(4),@tenlop varchar(30),@ngaykg datetime,@hocphi int,@ca tinyint,@sotiet int,@sohv int,@magv CHAR(4)
AS
	IF EXISTS (SELECT * FROM dbo.Lop WHERE MaLop=@malop)
		BEGIN
		    IF EXISTS (SELECT * FROM dbo.CaHoc WHERE Ca=@ca) AND EXISTS(SELECT * FROM dbo.GiaoVien WHERE MSGV=@magv)
				BEGIN
				    UPDATE dbo.Lop SET TenLop=@tenlop,NgayKG=@ngaykg,HocPhi=@hocphi,Ca=@ca,SoTiet=@sotiet,SoHV=@sohv,MSGV=@magv WHERE MaLop=@malop
					PRINT N'Đã cập nhật thành công thông tin của lớp '+@malop
				END
			ELSE
				BEGIN
				    IF NOT EXISTS(SELECT*FROM dbo.CaHoc WHERE Ca=@ca)
						PRINT N'Không tồn tại ca học trong CSDL'
					ELSE 
						PRINT N'Không tồn tại giáo viên trong CSDL'
				END
		END
	ELSE
		PRINT N'Không tồn tại lớp '+@malop+N' trong CSDL'
-------------------------

EXEC usp_UpdateLop 'W123',N'Word 4-6-8','02/18/2008', 100000,2,30,1,'G004'
--e.Xóa một lớp học cho trước nếu lớp này không có học viên
CREATE PROC usp_DeleteLop @malop CHAR(4)
AS
	IF EXISTS (SELECT * FROM dbo.Lop WHERE MaLop=@malop AND SoHV =0)
		BEGIN
			DELETE FROM dbo.HocVien WHERE MaLop=@malop
		    DELETE FROM dbo.Lop WHERE MaLop=@malop
			PRINT N'Xóa thành công lớp '+@malop
		END
	ELSE 
		BEGIN
		    IF NOT EXISTS (SELECT * FROM dbo.Lop WHERE MaLop=@malop AND SoHV=0)
				PRINT N'Không xóa được vì số học viên của lớp lớn hơn 0'
			ELSE IF NOT EXISTS (SELECT * FROM dbo.Lop WHERE MaLop=@malop)
				PRINT N'Không tồn tại mã lớp '+@malop+N' trong CSDL' 
		END

----------------------------------------
EXEC usp_DeleteLop 'W124'
--f.Lập danh sách học viên của một lớp cho trước
CREATE PROC usp_LapDSLop @malop CHAR(4)
AS
	IF EXISTS(SELECT * FROM dbo.Lop WHERE MaLop=@malop)
		BEGIN
		    SELECT *
			FROM dbo.HocVien
			WHERE MaLop = @malop
		END
	ELSE
		PRINT N'Không tồn tại lớp '+@malop

--------------------------
EXEC usp_LapDSLop 'A075'
--g.Lập danh sách học viên chưa đóng đủ học phí của một lớp cho trước
CREATE PROC usp_DSHVChuaDuHP @malop CHAR(4)
AS 
	IF EXISTS (SELECT * FROM dbo.Lop WHERE MaLop=@malop)
		BEGIN
		    SELECT hv.MSHV,hv.Ho,hv.Ten,hv.MaLop
			FROM dbo.HocPhi hp,dbo.HocVien hv,dbo.Lop l
			WHERE l.MaLop=hv.MaLop AND HV.MaLop=@malop AND l.MaLop=@malop AND HP.MSHV=HV.MSHV AND l.HocPhi-HP.SoTien>0
		END
	ELSE
		BEGIN
		    IF NOT EXISTS(SELECT * FROM dbo.Lop WHERE MaLop=@malop)
				PRINT N'Không tồn tại lớp trong database!'
		END

EXEC usp_DSHVChuaDuHP 'A075'
------------------XÂY DỰNG CÁC THỦ TỤC XÓA DỮ LIỆU----------


-------------------------------------------------------------------------------
--------------------HÀM SINH MÃ & CÁCH SỬ DỤNG----------------
/*1. Viết hàm sinh mã cho giáo viên mới theo quy tắc lấy mã lớn nhất hiện có 
sau đó tăng thêm 1 đơn vị*/
create function SinhMaGV() returns char(4)
As
Begin
	declare @MaxMaGV char(4)
	declare @NewMaGV varchar(4)
	declare @stt	int
	declare @i	int	
	declare @sokyso	int

	if exists(select * from GiaoVien)---Nếu bảng giáo viên có dữ liệu
	 begin
		--Lấy mã giáo viên lớn nhất hiện có
		select @MaxMaGV = max(MSGV) 
		from GiaoVien
		--Trích phần ký số của mã lớn nhất và chuyển thành số 
		set @stt=convert(int, right(@MaxMaGV,3)) + 1 --Số thứ tự của giáo viên mới
	 end
	else--Nếu bảng giáo viên đang rỗng (nghĩa là chưa có giáo viên nào được lưu trữ trong CSDL.
	 set @stt= 1 -- Số thứ tự của giáo viên trong trường hợp chưa có gv nào trong CSDL
	
	--Kiểm tra và bổ sung chữ số 0 để đủ 3 ký số trong mã gv.
	set @sokyso = len(convert(varchar(3), @stt))
	set @NewMaGV='G'
	set @i = 0
	while @i < 3 -@sokyso
		begin
			set @NewMaGV = @NewMaGV + '0'
			set @i = @i + 1
		end	
	set @NewMaGV = @NewMaGV + convert(varchar(3), @stt)

return @NewMaGV	
End
--Thử hàm sinh mã
print dbo.SinhMaGV()
----2. Thủ  tục thêm giáo viên với mã giáo viên được sinh tự động----
CREATE PROC usp_ThemGiaoVien2
@hogv nvarchar(20), @tengv nvarchar(10), @dthoai varchar(10)
As
	declare @Magv char(4)
	
 if not exists(select * from GiaoVien 
				where HoGV = @hogv and TenGV = @tengv and DienThoai = @dthoai)
	Begin
		
		--sinh mã cho giáo viên mới
		set @Magv = dbo.SinhMaGV()
		insert into GiaoVien values(@Magv, @hogv, @tengv,@dthoai)
		print N'Đã thêm giáo viên thành công'
	End
else
	print N'Đã có giáo viên ' + @hogv +' ' + @tengv + ' trong CSDL'
Go
---Sử dụng thủ tục thêm giáo viên
exec usp_ThemGiaoVien2 N'Trần Ngọc Bảo', N'Hân', '0123456789'
exec usp_ThemGiaoVien2 N'Vũ Minh', N'Triết', '0123456788'
select * from GiaoVien




------------------CÀI ĐẶT RÀNG BUỘC TOÀN VẸN----------------
/*4a) Giờ kết thúc của một ca học không được trước giờ bắt đầu ca học đó 
(RBTV liên thuộc tính)*/
Create trigger tr_CaHoc_ins_upd_GioBD_GioKT
On CaHoc  for insert, update
As
if  update(GioBatDau) or update (GioKetThuc)
	     if exists(select * from inserted i where i.GioKetThuc<i.GioBatDau)	
	      begin
	    	     raiserror (N'Giờ kết thúc ca học không thể nhỏ hơn giờ bắt đầu',15,1)
		     rollback tran
	      end
go	
-----thử nghiệm hoạt động của trigger tr_CaHoc_ins_upd_GioBD_GioKT----
insert into CaHoc values(4,'17:00','15:30')
Update CaHoc set GioKetThuc = '5:45' where ca = 1
/* 4b): Số học viên của 1 lớp không quá 30 và đúng bằng số học viên thuộc lớp đó. 
(RBTV do thuộc tính tổng hợp)*/
create trigger trg_Lop_ins_upd
on Lop for insert,update
AS
if Update(MaLop) or Update(SoHV)
Begin
	if exists(select * from inserted i where i.SOHV>30) 
	begin
		raiserror (N'Số học viên của một lớp không quá 30',15,1)--Thông báo lỗi cho người dùng
		rollback tran --hủy bỏ thao tác thêm lớp học
	end
	if exists (select * from inserted l 
	              where l.SOHV <> (select count(MSHV) 
									from HocVien 
									where HocVien.Malop = l.Malop))
	begin
		raiserror (N'Số học viên của một lớp không bằng số lượng học viên tại lớp đó',15,1)--Thông báo lỗi cho người dùng
		rollback tran --hủy bỏ thao tác thêm lớp học
	end
End
	
Go
-- Thử nghiệm 
select * from Lop
--
Set dateformat dmy
go
insert into Lop values('P001',N'Photoshop','1/11/2018',250000,1,100,0,'G004')
update Lop set SoHV = 5 where MaLop = 'P001'
/*4b): Hãy Cài đặt trigger cho bảng HocVien*/
--Tự làm

/*4b) Hãy thực hiện yêu cầu 4b bằng cách xây dựng các thủ tục thêm, xóa, sửa học viên kèm 
cập nhật SoHV trong bảng Lop*/  
--Tự làm

/*4c)Tổng số tiền thu của một học viên không vượt quá học phí của lớp mà học viên đó đăng ký học*/
--Tự làm

/*5b --> 5g: tự làm*/

--6a) Hàm tính tổng số học phí đã thu được của một lớp khi biết mã lớp. 
create function fn_TongHocPhi1Lop(@malop char(4)) returns int
As
Begin
	declare @TongTien int
	if exists (select * from Lop where MaLop = @MaLop) ---Nếu tồn tại lớp @malop trong CSDL
		Begin
		--Tính tổng số học phí thu được trên 1 lớp
		select @TongTien = sum(SoTien)
		from	HocPhi A, HocVien B	
		where	A.MSHV = B.MSHV and B.Malop = @malop
		End	
	 	
return @TongTien
End
--- thu nghiem ham-------
print dbo.fn_TongHocPhi1Lop('A075')
--6b) Hàm tính tổng số học phí thu được trong một khoảng thời gian cho trước. 
create function fn_TongHocPhi(@bd datetime,@kt datetime) returns int
As
Begin
	declare @TongTien int
	--Tính tổng số học phí thu được trong khoảng thời gian từ bắt đầu đến kết thúc
	select @TongTien = sum(SoTien)
	from	HocPhi 	
	where	NgayThu between @bd and @kt
return @TongTien
End
--- thu nghiem ham-------
set dateformat dmy
print dbo.fn_TongHocPhi('1/1/2008','15/1/2008')
--6c) Cho biết một học viên cho trước đã nộp đủ học phí hay chưa. 
CREATE FUNCTION nopHocPhi(@mshv CHAR(6))
RETURNS nvarchar(100)
AS
BEGIN
	IF EXISTS(SELECT * FROM HocPhi WHERE MSHV=@mshv)
		begin
			DECLARE @count INT=0;
		    SELECT @count=COUNT(*)
			FROM dbo.HocVien hv, dbo.HocPhi hp,dbo.Lop l
			WHERE  hv.MSHV=hp.MSHV AND hp.MSHV=@mshv AND hv.MSHV=@mshv AND l.HocPhi-hp.SoTien>0 AND l.MaLop=hv.MaLop

			IF (@count>0)
				RETURN N'Học viên chưa nộp đủ học phí'
			ELSE
				RETURN N'Học viên đã nộp đủ học phí'
		END
    ELSE
		RETURN N'Không tồn tại học viên'

		RETURN N'Không xác định'
END

SELECT dbo.nopHocPhi('A07501')
--6d) Hàm sinh mã số học viên theo quy tắc mã số học viên gồm mã lớp của học viên kết hợp với số thứ tự của học viên trong lớp đó. 
