-- 1. Tạo bảng Huấn Luyện Viên trước (vì Package tham chiếu đến bảng này)
CREATE TABLE TRAINER (
    Ma_HLV VARCHAR(20) PRIMARY KEY,
    Ho_ten NVARCHAR(100) NOT NULL,
    Chuyen_mon NVARCHAR(100),
    Dien_thoai VARCHAR(15)
);

-- 2. Tạo bảng Hội Viên
CREATE TABLE MEMBER (
    Ma_HV VARCHAR(20) PRIMARY KEY,
    Ho_ten NVARCHAR(100) NOT NULL,
    SDT VARCHAR(15),
    Ngay_dang_ky DATE DEFAULT GETDATE() 
);

-- 3. Tạo bảng Gói Tập (Có khóa ngoại trỏ về Trainer)
CREATE TABLE PACKAGE (
    Ma_goi VARCHAR(20) PRIMARY KEY,
    Ten_goi NVARCHAR(100) NOT NULL,
    Gia DECIMAL(18, 0),       -- Dùng Decimal để lưu tiền tệ chính xác
    Thoi_han INT,             -- Đơn vị: ngày
    Ma_HLV VARCHAR(20),
    
    -- Tạo khóa ngoại liên kết với TRAINER
    CONSTRAINT FK_Package_Trainer FOREIGN KEY (Ma_HLV) 
    REFERENCES TRAINER(Ma_HLV)
);

-- 4. Tạo bảng Đăng Ký (Bảng trung gian n-n)
CREATE TABLE REGISTRATION (
    Ma_HV VARCHAR(20),
    Ma_goi VARCHAR(20),
    Ngay_bat_dau DATE NOT NULL,
    Ngay_ket_thuc DATE,
    Trang_thai NVARCHAR(50), -- Ví dụ: 'Active', 'Expired', 'Cancelled'
    
    -- Khóa chính phức hợp: Để đảm bảo một người có thể đăng ký nhiều gói, 
    -- và có thể đăng ký lại gói cũ vào ngày khác.
    PRIMARY KEY (Ma_HV, Ma_goi, Ngay_bat_dau),
    
    -- Khóa ngoại liên kết với MEMBER
    CONSTRAINT FK_Reg_Member FOREIGN KEY (Ma_HV) 
    REFERENCES MEMBER(Ma_HV),
    
    -- Khóa ngoại liên kết với PACKAGE
    CONSTRAINT FK_Reg_Package FOREIGN KEY (Ma_goi) 
    REFERENCES PACKAGE(Ma_goi)
);