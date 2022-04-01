use Lab01_QuanLyNhanVien
CREATE TABLE ChiNhanh
  (
     MSCN    CHAR(2) PRIMARY KEY NOT NULL,
     TenCN NVARCHAR(50) UNIQUE
  );
CREATE TABLE NhanVien
(
     MANV        CHAR(4) PRIMARY KEY NOT NULL,
     Ho          nvarchar(50),
     Ten         nvarchar(50),
     NgaySinh    date,
     NgayVaoLam  date,
     MSCN char(2),
     FOREIGN KEY (MSCN) REFERENCES chinhanh(MSCN) ON DELETE CASCADE
);
create table KyNang
(
	MSKN CHAR(02) PRIMARY KEY NOT NULL,
	TenKN NVARCHAR(50) UNIQUE
)

create table NhanVienKyNang
(
	MANV CHAR(04) PRIMARY KEY NOT NULL,
	MSKN CHAR(02) ,
	MucDo Tinyint CHECK(MucDo >= 1 AND MucDo <= 9),
	FOREIGN KEY(MSKN) REFERENCES KyNang(MSKN),
	FOREIGN KEY (MANV) REFERENCES NhanVien(MANV)
)

--- Nhân viên phải đủ 18 tuổi: check(year(GETDATE()) - year(NgaySinh) >= 18);
--- Thêm bộ vào chi nhánh
insert into ChiNhanh values ('01',N'Quận 1')
insert into ChiNhanh values ('02',N'Quận 5')
insert into ChiNhanh values ('03',N'Bình Thạnh')
--test ChiNhanh
select * from ChiNhanh  order by MSCN
-- Thêm bộ nhân viên

INSERT INTO NhanVien VALUES ('0001', N'Lê Văn', N'Minh', '1960-06-10', '02/05/1986', '01');
INSERT INTO NhanVien VALUES ('0002', N'Nguyễn Thị', N'Mai', '1970-04-20', '2001-07-04', '01');
INSERT INTO NhanVien VALUES ('0003', N'Lê Anh', N'Tuấn', '1975-06-25', '1982-09-01', '02');
INSERT INTO NhanVien VALUES ('0004', N'Vương Tuấn', N'Vũ', '1960-03-25', '1986-01-12', '02');
INSERT INTO NhanVien VALUES ('0005', N'Lý Anh', N'Hân', '1980-12-01', '2004-05-15', '02');
INSERT INTO NhanVien VALUES ('0006', N'Phan Lê', N'Tuấn', '1976-06-04', '2002-10-25', '03');
INSERT INTO NhanVien VALUES ('0007', N'Lê Tuấn', N'Tú', '1975-08-15', '2000-08-15', '03');
--test NhanVien
select * from NhanVien  order by MANV