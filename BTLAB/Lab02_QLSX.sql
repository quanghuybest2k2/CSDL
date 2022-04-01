------------------------------------------------
/* Học phần: Cơ sở dữ liệu
   Ngày: 15/04/2020
   Người thực hiện: Tạ Thị Thu Phượng
   Mã số sinh viên:
   Lab02: Quản lý sản xuất
*/
------------------------------------------------
--lệnh tạo CSDL
CREATE DATABASE Lab02_QuanLySanXuat
go
--lenh su dyng CSDL
use Lab02_QuanLySanXuat
--lenh tao cac bang
create table ToSanXuat
(MaTSX	char(4) primary key, -- khai bao MaTSX là khóa chính
TenTSX	nvarchar(20) not null unique
)
go
create table CongNhan
(
MaCN char(5) primary key,
Ho	nvarchar(20) not null,
Ten nvarchar(10)	not null,
Phai nvarchar(3),
Ngaysinh	datetime,
MaTSX	char(4)	references ToSanXuat(MaTSX) -- khai bao MaTSX là khóa ngoại tham chiếu đến khóa chính MaTSX của quan hệ ToSanXuat 
)
go
create table SanPham
(MaSP	char(5) primary key,
TenSP	nvarchar(30) not null,
DVT		nvarchar(10),
TienCong	int check(TienCong > 0)-- kiểm tra TienCong >0 
)
go
create table ThanhPham
(
MaCN char(5) references CongNhan(MaCN),
MaSP char(5) references SanPham(MaSP),
Ngay datetime,
SoLuong	int check(SoLuong > 0)-- kiểm tra số lượng >0 
primary key(MaCN, MaSP, Ngay) --khai báo khóa chính gồm nhiều thuộc tính
)
-----Lệnh xem dữ liệu chứa trong băng------
select * from ToSanXuat
select * from CongNhan
select * from SanPham
select * from ThanhPham
----NHẬP DỮ LIỆU CHO CÁC BẢNG-------
insert into ToSanXuat values('TS01',N'Tổ 1')
insert into ToSanXuat values('TS02',N'Tổ 2')
--xem bảng ToSanXuat
select * from ToSanXuat
--Nhap bang CongNhan
set dateformat dmy --Khai báo định dạng ngày tháng 
go
insert into CongNhan values('CN001',N'Nguyễn Trường',N'An',N'Nam','12/05/1981','TS01')
insert into CongNhan values('CN002',N'Lê Thị Hồng',N'Gấm',N'Nữ','04/06/1980','TS01')
insert into CongNhan values('CN003',N'Nguyễn Công',N'Thành',N'Nam','04/05/1981','TS02')
insert into CongNhan values('CN004',N'Võ Hữu',N'Hạnh',N'Nam','15/02/1980','TS02')
insert into CongNhan values('CN005',N'Lý Thanh',N'Hân',N'Nữ','03/12/1981','TS01')

--xem bang nhanvien
select * from CongNhan

--Nhap bang SanPham
insert into SanPham values('SP001',N'Nồi đất',N'cái',10000)
insert into SanPham values('SP002',N'Chén',N'cái',2000)
insert into SanPham values('SP003',N'Bình gốm nhỏ',N'cái',20000)
insert into SanPham values('SP004',N'Bình gốm lớn',N'cái',25000)

--xem bảng SanPham
select * from SanPham

--nhap bang ThanhPham
set dateformat dmy --Khai báo định dạng ngày tháng 
go
insert into ThanhPham values('CN001','SP001','01/02/2007',10)
insert into ThanhPham values('CN002','SP001','01/02/2007',5)
insert into ThanhPham values('CN003','SP002','10/01/2007',50)
insert into ThanhPham values('CN004','SP003','12/01/2007',10)
insert into ThanhPham values('CN005','SP002','12/01/2007',100)
insert into ThanhPham values('CN002','SP004','13/02/2007',10)
insert into ThanhPham values('CN001','SP003','14/02/2007',15)
insert into ThanhPham values('CN003','SP001','15/01/2007',20)
insert into ThanhPham values('CN003','SP004','14/02/2007',15)
insert into ThanhPham values('CN004','SP002','30/01/2007',100)
insert into ThanhPham values('CN005','SP003','01/02/2007',50)
insert into ThanhPham values('CN001','SP001','20/02/2007',30)
--xem bảng ThanhPham
select * from ThanhPham
------------II. TRUY VẤN DỮ LIỆU-------------
--1) Liệt kê các công nhân theo tổ sản xuất gồm các thông tin: TenTSX, HoTen, NgaySinh, Phai (xếp thứ tự tăng dần của tên tổ sản xuất, Tên của công nhân).
select	TenTSX, Ho+' '+Ten As HoTen, Convert(char(10), NgaySinh, 103) AS Ngaysinh, Phai
from	ToSanXuat A, CongNhan B
where	A.MaTSX = B.MaTSX
order by TenTSX, Ten, Ho
--2) Liệt kê các thành phẩm mà công nhân ‘Nguyễn Trường An’ đã làm được gồm các thông tin: TenSP, Ngay, SoLuong, ThanhTien (xếp theo thứ tự tăng dần của ngày). 
select	TenSP,  Convert(char(10), Ngay, 103) As Ngay, Soluong, SoLuong*TienCong As ThanhTien
from	CongNhan A, ThanhPham B, SanPham C
where	A.MaCN = B.MaCN and b.MaSP = C.MaSP and Ho=N'Nguyễn Trường' and Ten = N'An'
order by Ngay

--3) Liệt kê các nhân viên không sản xuất sản phẩm ‘Bình gốm lớn’ (phép hiệu).
select	*
from	CongNhan A
where	MaCN not in (	select	B.MaCN
						from	ThanhPham B, SanPham C
						where	B.MaSP = C.MaSP and TenSP = N'Bình gốm lớn')

--4) Liệt kê thông tin các công nhân có sản xuất cả ‘Nồi đất’ và ‘Bình gốm nhỏ’ (phép giao).
Select	distinct A.MaCN, Ho+' '+ Ten As HoTen, MaTSX
from	CongNhan A, ThanhPham B, SanPham C
where	A.MaCN = B.MaCN and B.MaSP = C.MaSP and TenSP = N'Nồi đất'
		and A.MaCN IN (select	D.MaCN
						from	ThanhPham D, SanPham E
						where	D.MaSP = E.MaSP and TenSP = N'Bình gốm nhỏ')
---
Select	distinct A.MaCN, Ho+' '+ Ten As HoTen, MaTSX
from	CongNhan A, ThanhPham B, SanPham C
where	A.MaCN = B.MaCN and B.MaSP = C.MaSP and TenSP = N'Bình gốm nhỏ'
		and A.MaCN IN (select	D.MaCN
						from	ThanhPham D, SanPham E
						where	D.MaSP = E.MaSP and TenSP = N'Nồi đất')




--5) Thống kê Số luợng công nhân theo từng tổ sản xuất (truy vấn gom nhóm)
select	B.MaTSX, TenTSX, COUNT(MaCN) As SoCN
from	CongNhan B, ToSanXuat A
where	B.MaTSX = A.MaTSX
Group By	B.MaTSX, TenTSX

--6) Tổng số lượng thành phẩm theo từng loại mà mỗi nhân viên làm được (Ho, Ten, TenSP, TongSLThanhPham, TongThanhTien).
Select	A.MaCN,Ho +' '+Ten As HoTen, TenSP, Sum(SoLuong) as TongSLThanhPham, SUM(SoLuong*TienCong) as TongThanhTien
From	CongNhan A, ThanhPham B, SanPham C
Where	A.MaCN = B.MaCN and B.MaSP = C.MaSP
Group By A.MaCN, Ho, Ten, TenSp
order by A.MaCN

--7) Tổng số tiền công đã trả cho công nhân trong tháng 1 năm 2007

Select	Sum(SoLuong*TienCong) As TongTienCongThang1_2007
from	ThanhPham A, SanPham B
where	A.MaSP = B.MaSP and MONTH(Ngay) = 1 and YEAR(Ngay) = 2007

--8) Cho biết sản phẩm được sản xuất nhiều nhất trong tháng 2/2007 (Bài toán max)
Select	A.MaSP, TenSP, sum(soluong) as TongSL
From	ThanhPham A, SanPham B	
where	A.MaSP = B.MaSP and MONTH(Ngay) = 2 and YEAR(Ngay) = 2007
Group By	A.MaSP, TenSP
Having	sum(soluong) >=all (Select	Sum(c.SoLuong)
							From	ThanhPham c
							where	MONTH(Ngay) = 2 and YEAR(Ngay) = 2007
							Group By	C.MaSP
							)

--9) Cho biết công nhân sản xuất được nhiều ‘Chén’ nhất. (Bài toán max)
Select		A.MaCN, Ho, Ten, MaTSX, sum(Soluong)
from		CongNhan A, ThanhPham B, SanPham C
where		A.MaCN = B.MaCN and B.MaSP = C.MaSP and TenSP = N'Chén'
Group By	A.MaCN, Ho, Ten, MaTSX
Having	sum(soluong) >=all (Select	Sum(D.SoLuong)
							From	ThanhPham D, SanPham E
							where	D.MaSP = E.MaSP and TenSp =N'Chén'
							Group By	D.MaCN
							)

--10) Tiền công tháng 2/2007 của công nhân có mã số ‘CN002’ 
Select	Sum(SoLuong*TienCong) As TongTienCongThang2
from	ThanhPham A, SanPham B
where	A.MaSP = B.MaSP and MONTH(Ngay) = 2 and YEAR(Ngay) = 2007 and MaCN = 'CN002'

--11) Liệt kê các công nhân có sản xuất từ 3 loại sản phẩm trở lên.
Select		A.MaCN, Ho, Ten, count(distinct MaSP)
From		CongNhan A, ThanhPham B
Where		A.MaCN = B.MaCN
Group By	A.MaCN, Ho, Ten
Having		count(distinct MaSP)>=3

--12) Cập nhật giá tiền công của các loại bình gốm thêm 1000.
Update Sanpham 
set TienCong = TienCong+1000 
where TenSP like N'Bình gốm%'
--select * from SanPham

--13) Thêm bộ <’CN006’, ‘Lê Thị’, ‘Lan’, ‘Nữ’,’TS02’ > vào bảng CongNhan.
--Cách 1:
Insert into CongNhan(MaCN, Ho, Ten, Phai, MaTSX) values('CN006', N'Lê Thị', N'Lan', N'Nữ','TS02')
--Cách 2:
Insert into CongNhan values('CN006', N'Lê Thị', N'Lan', N'Nữ',NULL,'TS02')
--select * from CongNhan
--delete from CongNhan where MaCN = 'CN006'

--III.	Thủ tục & Hàm
--A.	Viết các hàm sau:
--a.	Tính tổng số công nhân của một tổ sản xuất cho trước
--b.	Tính tổng sản lượng sản xuất trong một tháng của một loại sản phẩm cho trước.
--c.	Tính tổng tiền công tháng của một công nhân cho trước.
--d.	Tính tổng thu nhập trong năm của một tổ sản xuất cho trước.
--e.	Tính tổng sản lượng sản xuất của một loại sản phẩm trong một khoảng thời gian cho trước.
--B.	Viết các thủ tục sau:
--a.	In danh sách các công nhân của một tổ sản xuất cho trước.
--b.	In bảng chấm công sản xuất trong tháng của một công nhân cho trước (bao gồm Tên sản phẩm, đơn vị tính, số lượng sản xuất trong tháng, đơn  giá, thành tiền).
------------------------
--Liệt kê các nhân viên không sản xuất sản phẩm ‘Bình gốm lớn’
--sai
select	distinct A.*
from	CongNhan A, ThanhPham B, SanPham C
where	A.MaCN = B.MaCN and B.MaSP = C.MaSP and TenSP <> N'Bình gốm lớn'
-- Liệt kê thông tin các công nhân có sản xuất cả ‘Nồi đất’ và ‘Bình gốm nhỏ’ 
--sai
select	distinct A.*
from	CongNhan A, ThanhPham B, SanPham C
where	A.MaCN = B.MaCN and B.MaSP = C.MaSP and TenSP = N'Bình gốm nhỏ' and TenSP = N'Nồi đất'
--------------------------TẠO THỦ TỤC THÊM DỮ LIỆU VÀO CÁC BẢNG---------------
select * from ToSanXuat
select * from CongNhan
select * from SanPham
Select * from ThanhPham
--------------------
delete  from ToSanXuat
delete  from CongNhan
delete  from SanPham
delete  from ThanhPham

--1. Thủ tục thêm tổ sản suất
create proc usp_Them_TSX @MaTSX char(4), @TenTSX nvarchar(20)
as
	if exists(select * from ToSanXuat where MaTSX = @MaTSX) --Kiểm tra có bị trùng khóa chính
		print N'Tổ sản xuất'+ @MaTSX +N' đã có trong CSDL'
	else
		begin
			insert into ToSanXuat values(@MaTSX, @TenTSX)
			print N'Đã thêm tổ sản xuất thành công!'
		end
go
--sử dụng thủ tục usp_Them_TSX để đưa dữ liệu vào quan hệ
exec usp_Them_TSX 'TS01',N'Tổ 1'
exec usp_Them_TSX 'TS02',N'Tổ 2'
--2. Thủ tục thêm công nhân
create proc usp_Them_CongNhan 
				@MaCN char(5), @Ho nvarchar(20), @Ten nvarchar(10), @Phai nvarchar(3), 
				@NS Datetime, @MaTSX char(4)
as
	if exists(select * from CongNhan where MaCN = @MaCN)--kiểm tra có trùng khóa chính (MaCN)
		print N'Bị trùng '+ @MaCN +N' trong CSDL'
	Else
		Begin
			if exists(select * from ToSanXuat where MaTSX = @MaTSX)--kiểm tra ràng buộc khóa ngoại
				begin
					insert into CongNhan values(@MaCN, @Ho, @Ten, @Phai,@NS, @MaTSX)
					print N'Đã thêm công nhân mới thành công.'
				end
			else
				print N'Không tồn tại tổ sản xuất '+@MaTSX+ N' trong CSDL nên không thêm được công nhân vào tổ này.'
				
		end
go
--gọi thủ tục thêm công nhân
set dateformat dmy
go
exec usp_Them_CongNhan 'CN001',N'Nguyễn Trường',N'An',N'Nam','12/05/1981','TS01'
exec usp_Them_CongNhan 'CN002',N'Lê Thị Hồng',N'Gấm',N'Nữ','04/06/1980','TS01'
exec usp_Them_CongNhan 'CN003',N'Nguyễn Công',N'Thành',N'Nam','04/05/1981','TS02'
exec usp_Them_CongNhan 'CN004',N'Võ Hữu',N'Hạnh',N'Nam','15/02/1980','TS02'
exec usp_Them_CongNhan 'CN005',N'Lý Thanh',N'Hân',N'Nữ','03/12/1981','TS01'
-------------------------HÀM--------------------------------
--a. Tính tổng số công nhân của một tổ sản xuất cho trước
create function DemSoCN(@MaTSX char(4))
returns int
As
Begin
	declare @socn int
	
	select @socn = count(MaCN)
	from CongNhan
	where MaTSX = @MaTSX
	return @socn
end
--goi su dung hàm
select dbo.DemSoCN('TS01') as N'Số công nhân'
print N'số công nhân của tổ 1 là: '+ convert(varchar(10),dbo.DemSoCN('TS01'))
--hàm lập danh sách các công nhân của một tổ sản xuất cho trước
create function DanhSacToSX(@MaTSX char(4))
returns table
As
	return(select * from CongNhan where MaTSX = @MaTSX)
go
--gọi sử dụng hàm
select * from dbo.DanhSacToSX('TS02')