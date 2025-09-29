-- Database: HRManagement

-- DROP DATABASE IF EXISTS "HRManagement";

CREATE DATABASE "HRManagement"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Vietnamese_Vietnam.1252'
    LC_CTYPE = 'Vietnamese_Vietnam.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- 1. NHANVIEN
CREATE TABLE NhanVien (
    MaNV SERIAL PRIMARY KEY,
    HoTen VARCHAR(100) NOT NULL,
    NgaySinh DATE,
    SoCCCD VARCHAR(20) UNIQUE,
    DienThoai VARCHAR(15),
    MaPB INT,
    MaCV INT,
    NgayVaoLam DATE
);

-- 2. CHUCVU
CREATE TABLE ChucVu (
    MaCV SERIAL PRIMARY KEY,
    TenCV VARCHAR(100) NOT NULL,
    PhuCap NUMERIC(18,2),
    LuongCB NUMERIC(18,2)
);

-- 3. CHAMCONG
CREATE TABLE ChamCong (
    MaCC SERIAL PRIMARY KEY,
    MaNV INT NOT NULL,
    Ngay DATE NOT NULL,
    GioCC TIMESTAMP,
    MaDD INT,
    TrangThai VARCHAR(50)
);

-- 4. LUONG
CREATE TABLE Luong (
    MaLuong SERIAL PRIMARY KEY,
    MaNV INT NOT NULL,
    Thang INT NOT NULL,
    Nam INT NOT NULL,
    TongNgayCong INT,
    LuongThucNhan NUMERIC(18,2)
);

-- 5. PHONGBAN
CREATE TABLE PhongBan (
    MaPB SERIAL PRIMARY KEY,
    TenPB VARCHAR(100) NOT NULL,
    MoTa VARCHAR(200)
);

-- 6. DON TU
CREATE TABLE DonTu (
    MaDon SERIAL PRIMARY KEY,
    MaNV INT NOT NULL,
    MaLoaiDon INT,
    NgayBatDau TIMESTAMP,
    NgayKetThuc TIMESTAMP,
    LyDo VARCHAR(200),
    TrangThai VARCHAR(20),
    NgayGui DATE,
    NguoiDuyet VARCHAR(100)
);

-- 7. DIA DIEM LAM VIEC
CREATE TABLE DiaDiemLamViec (
    MaDD SERIAL PRIMARY KEY,
    TenDiaDiem VARCHAR(100),
    DiaChi VARCHAR(200),
    ToaDoX DOUBLE PRECISION,
    ToaDoY DOUBLE PRECISION,
    BanKinh INT
);

-- 8. CONG DUYET
CREATE TABLE CongDuyet (
    MaCD SERIAL PRIMARY KEY,
    MaNV INT NOT NULL,
    Ngay DATE,
    GioVao TIMESTAMP,
    GioRa TIMESTAMP,
    TongGio NUMERIC(5,2),
    NguoiDuyet VARCHAR(100),
    GhiChu VARCHAR(200)
);

-- 9. TAIKHOAN
CREATE TABLE TaiKhoan (
    MaTK SERIAL PRIMARY KEY,
    MaNV INT,
    TenDangNhap VARCHAR(50) UNIQUE NOT NULL,
    MatKhau VARCHAR(256) NOT NULL,
    VaiTro VARCHAR(50),
    TrangThai VARCHAR(20)
);

-- 10. DAO TAO
CREATE TABLE DaoTao (
    MaDT SERIAL PRIMARY KEY,
    TenKhoaHoc VARCHAR(100) NOT NULL,
    ChungChi VARCHAR(100),
    HinhThuc VARCHAR(100),
    LoaiDaoTao VARCHAR(100),
    MoTa VARCHAR(100)
);

-- 11. KET QUA DAO TAO
CREATE TABLE KetQuaDaoTao (
    MaKQ SERIAL PRIMARY KEY,
    MaNV INT NOT NULL,
    MaDT INT NOT NULL,
    TrangThai VARCHAR(50),
    NgayHoanThanh DATE,
    ChungChi VARCHAR(200)
);

-- 12. KE HOACH DAO TAO
CREATE TABLE KeHoachDaoTao (
    MaKHDT SERIAL PRIMARY KEY,
    MaDT INT NOT NULL,
    ThoiGianBatDau TIMESTAMP,
    ThoiGianKetThuc TIMESTAMP,
    DiaDiem VARCHAR(200),
    DonViDaoTao VARCHAR(200),
    GhiChu VARCHAR(200)
);

-- 13. DANG KY DAO TAO
CREATE TABLE DangKyDaoTao (
    MaDKDT SERIAL PRIMARY KEY,
    MaKHDT INT NOT NULL,
    MaNV INT NOT NULL,
    TrangThai VARCHAR(50)
);

-- 14. LOAI DON
CREATE TABLE LoaiDon (
    MaLoaiDon SERIAL PRIMARY KEY,
    TenLoaiDon VARCHAR(100) NOT NULL,
    MoTa VARCHAR(50)
);

-- 15. LICH SU DUYET DON
CREATE TABLE LichSuDuyetDon (
    MaDuyetDon SERIAL PRIMARY KEY,
    MaDon INT NOT NULL,
    NguoiDuyet VARCHAR(50),
    NgayDuyet TIMESTAMP,
    TrangThai VARCHAR(50),
    GhiChu VARCHAR(200)
);

-- Nhân viên -> Phòng ban, Chức vụ
ALTER TABLE NhanVien
    ADD CONSTRAINT fk_nv_pb FOREIGN KEY (MaPB) REFERENCES PhongBan(MaPB),
    ADD CONSTRAINT fk_nv_cv FOREIGN KEY (MaCV) REFERENCES ChucVu(MaCV);

-- Chấm công -> Nhân viên, Địa điểm
ALTER TABLE ChamCong
    ADD CONSTRAINT fk_cc_nv FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    ADD CONSTRAINT fk_cc_dd FOREIGN KEY (MaDD) REFERENCES DiaDiemLamViec(MaDD);

-- Lương -> Nhân viên
ALTER TABLE Luong
    ADD CONSTRAINT fk_luong_nv FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV);

-- Đơn từ -> Nhân viên, Loại đơn
ALTER TABLE DonTu
    ADD CONSTRAINT fk_don_nv FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    ADD CONSTRAINT fk_don_loaidon FOREIGN KEY (MaLoaiDon) REFERENCES LoaiDon(MaLoaiDon);

-- Công duyệt -> Nhân viên
ALTER TABLE CongDuyet
    ADD CONSTRAINT fk_cd_nv FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV);

-- Tài khoản -> Nhân viên
ALTER TABLE TaiKhoan
    ADD CONSTRAINT fk_tk_nv FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV);

-- Kết quả đào tạo -> Nhân viên, Đào tạo
ALTER TABLE KetQuaDaoTao
    ADD CONSTRAINT fk_kq_nv FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    ADD CONSTRAINT fk_kq_dt FOREIGN KEY (MaDT) REFERENCES DaoTao(MaDT);

-- Kế hoạch đào tạo -> Đào tạo
ALTER TABLE KeHoachDaoTao
    ADD CONSTRAINT fk_khdt_dt FOREIGN KEY (MaDT) REFERENCES DaoTao(MaDT);

-- Đăng ký đào tạo -> Nhân viên, Kế hoạch đào tạo
ALTER TABLE DangKyDaoTao
    ADD CONSTRAINT fk_dkdt_nv FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    ADD CONSTRAINT fk_dkdt_khdt FOREIGN KEY (MaKHDT) REFERENCES KeHoachDaoTao(MaKHDT);

-- Lịch sử duyệt đơn -> Đơn từ
ALTER TABLE LichSuDuyetDon
    ADD CONSTRAINT fk_lsdd_don FOREIGN KEY (MaDon) REFERENCES DonTu(MaDon);
