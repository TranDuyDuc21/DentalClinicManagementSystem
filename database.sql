-- =====================================================
-- DENTAL CLINIC MANAGEMENT SYSTEM - MySQL Database
-- =====================================================

CREATE DATABASE IF NOT EXISTS dental_clinic
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE dental_clinic;

-- =====================================================
-- 1. ROLES & USERS
-- =====================================================

CREATE TABLE roles (
  role_id      INT AUTO_INCREMENT PRIMARY KEY,
  role_name    ENUM('Admin','Receptionist','Doctor','Technician','Customer') NOT NULL UNIQUE,
  description  VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE permissions (
  permission_id   INT AUTO_INCREMENT PRIMARY KEY,
  permission_code VARCHAR(100) NOT NULL UNIQUE,   -- e.g. 'ORDER_TEST'
  description     VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE role_permissions (
  role_id        INT NOT NULL,
  permission_id  INT NOT NULL,
  PRIMARY KEY (role_id, permission_id),
  FOREIGN KEY (role_id)       REFERENCES roles(role_id) ON DELETE CASCADE,
  FOREIGN KEY (permission_id) REFERENCES permissions(permission_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE users (
  user_id        INT AUTO_INCREMENT PRIMARY KEY,
  role_id        INT NOT NULL,
  username       VARCHAR(50)  NOT NULL UNIQUE,
  email          VARCHAR(150) NOT NULL UNIQUE,
  password_hash  VARCHAR(255) NOT NULL,
  full_name      VARCHAR(150) NOT NULL,
  phone_number   VARCHAR(20),
  date_of_birth  DATE,
  gender         ENUM('Male','Female','Other'),
  profile_picture VARCHAR(255),
  is_active      BOOLEAN NOT NULL DEFAULT TRUE,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (role_id) REFERENCES roles(role_id),
  INDEX idx_users_role (role_id)
) ENGINE=InnoDB;

-- Password reset tokens 
CREATE TABLE password_reset_tokens (
  token_id    INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  token       VARCHAR(255) NOT NULL UNIQUE,
  expires_at  DATETIME NOT NULL,
  used        BOOLEAN NOT NULL DEFAULT FALSE,
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 2. DOCTOR PROFILE & CHAIRS
-- =====================================================

CREATE TABLE doctors (
  doctor_id    INT AUTO_INCREMENT PRIMARY KEY,
  user_id      INT NOT NULL UNIQUE,
  specialty    VARCHAR(150),
  license_no   VARCHAR(50),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE chairs (
  chair_id     INT AUTO_INCREMENT PRIMARY KEY,
  chair_code   VARCHAR(20) NOT NULL UNIQUE,        -- e.g. 'Chair 01'
  doctor_id    INT UNIQUE,                          -- fixed chair per doctor
  status       ENUM('Empty','In Use','Temporarily Vacant') NOT NULL DEFAULT 'Empty',
  is_active    BOOLEAN NOT NULL DEFAULT TRUE,
  FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =====================================================
-- 3. SERVICE CATALOG
-- =====================================================

CREATE TABLE services (
  service_id        INT AUTO_INCREMENT PRIMARY KEY,
  service_code      VARCHAR(20) NOT NULL UNIQUE,
  service_name      VARCHAR(150) NOT NULL,
  estimated_minutes INT,
  listed_price      DECIMAL(12,2) NOT NULL DEFAULT 0,
  description       TEXT,
  is_active         BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- =====================================================
-- 4. DOCTOR WORK SCHEDULE
-- =====================================================

CREATE TABLE doctor_schedules (
  schedule_id      INT AUTO_INCREMENT PRIMARY KEY,
  doctor_id        INT NOT NULL,
  work_date        DATE NOT NULL,
  shift            ENUM('Morning','Afternoon') NOT NULL,
  start_time       TIME NOT NULL,
  end_time         TIME NOT NULL,
  max_patients     INT NOT NULL DEFAULT 0,
  is_day_off       BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE,
  UNIQUE KEY uq_doctor_shift (doctor_id, work_date, shift),
  INDEX idx_schedule_date (work_date)
) ENGINE=InnoDB;

-- =====================================================
-- 5. PATIENT RECORDS
-- =====================================================

CREATE TABLE patients (
  patient_id     INT AUTO_INCREMENT PRIMARY KEY,
  patient_code   VARCHAR(20) NOT NULL UNIQUE,       -- PT-YYYY-XXXX
  user_id        INT,                         -- linked customer account (nullable for walk-ins)
  full_name      VARCHAR(150) NOT NULL,
  date_of_birth  DATE,
  gender         ENUM('Male','Female','Other'),
  phone_number   VARCHAR(20),
  email          VARCHAR(150),
  address        VARCHAR(255),
  medical_history TEXT,
  drug_allergies  TEXT,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
  INDEX idx_patient_name (full_name),
  INDEX idx_patient_phone (phone_number)
) ENGINE=InnoDB;

-- =====================================================
-- 6. APPOINTMENTS
-- =====================================================

CREATE TABLE appointments (
  appointment_id     INT AUTO_INCREMENT PRIMARY KEY,
  patient_id         INT NOT NULL,
  doctor_id          INT NOT NULL,
  service_id         INT,
  chair_id           INT,
  scheduled_datetime DATETIME NOT NULL,
  status             ENUM('New','Waiting','In Exam','Imaging/Testing','Done','Cancelled')
                       NOT NULL DEFAULT 'New',
  booking_source     ENUM('Online','Walk-in','Phone') NOT NULL DEFAULT 'Online',
  queue_number       INT,
  check_in_time      DATETIME,
  exam_start_time    DATETIME,
  exam_end_time      DATETIME,
  created_by         INT,                            -- receptionist/customer who created
  created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
  FOREIGN KEY (doctor_id)  REFERENCES doctors(doctor_id),
  FOREIGN KEY (service_id) REFERENCES services(service_id),
  FOREIGN KEY (chair_id)   REFERENCES chairs(chair_id),
  FOREIGN KEY (created_by) REFERENCES users(user_id),
  INDEX idx_appt_date (scheduled_datetime),
  INDEX idx_appt_status (status),
  INDEX idx_appt_doctor (doctor_id)
) ENGINE=InnoDB;

CREATE TABLE email_notifications (
  notification_id  INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id   INT,
  recipient_email  VARCHAR(150) NOT NULL,
  type             ENUM('Booking Confirmation','Reminder 24h','Reminder 2h',
                        'Cancellation','Reschedule') NOT NULL,
  sent_at          DATETIME,
  status           ENUM('Pending','Sent','Failed') NOT NULL DEFAULT 'Pending',
  FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 7. VISIT / EXAM RECORD
-- =====================================================

CREATE TABLE visits (
  visit_id       INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT NOT NULL UNIQUE,
  patient_id     INT NOT NULL,
  doctor_id      INT NOT NULL,
  visit_date     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  symptoms       TEXT,
  diagnosis      TEXT,
  clinical_notes TEXT,
  is_concluded   BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
  FOREIGN KEY (patient_id)     REFERENCES patients(patient_id),
  FOREIGN KEY (doctor_id)      REFERENCES doctors(doctor_id)
) ENGINE=InnoDB;

-- Tooth/gum condition by position - dental chart
CREATE TABLE dental_chart_entries (
  entry_id       INT AUTO_INCREMENT PRIMARY KEY,
  visit_id       INT NOT NULL,
  tooth_position VARCHAR(10) NOT NULL,
  `condition`    VARCHAR(150),
  note           TEXT,
  FOREIGN KEY (visit_id) REFERENCES visits(visit_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 8. MEDICATIONS & PRESCRIPTIONS
-- =====================================================

CREATE TABLE medications (
  medication_id  INT AUTO_INCREMENT PRIMARY KEY,
  name           VARCHAR(150) NOT NULL,
  unit           VARCHAR(50),
  description    VARCHAR(255),
  is_active      BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

CREATE TABLE prescriptions (
  prescription_id INT AUTO_INCREMENT PRIMARY KEY,
  visit_id        INT NOT NULL,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (visit_id) REFERENCES visits(visit_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE prescription_items (
  item_id          INT AUTO_INCREMENT PRIMARY KEY,
  prescription_id  INT NOT NULL,
  medication_id    INT,                              -- nullable for manual entry
  medication_name  VARCHAR(150),                     -- used if entered manually
  dosage           VARCHAR(100),
  duration         VARCHAR(100),
  usage_instruction TEXT,
  FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id) ON DELETE CASCADE,
  FOREIGN KEY (medication_id)   REFERENCES medications(medication_id)
) ENGINE=InnoDB;

-- =====================================================
-- 9. TREATMENT PLANS
-- =====================================================

CREATE TABLE treatment_plans (
  plan_id      INT AUTO_INCREMENT PRIMARY KEY,
  visit_id     INT NOT NULL,
  patient_id   INT NOT NULL,
  title        VARCHAR(150),
  created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (visit_id)   REFERENCES visits(visit_id),
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
) ENGINE=InnoDB;

CREATE TABLE treatment_steps (
  step_id          INT AUTO_INCREMENT PRIMARY KEY,
  plan_id          INT NOT NULL,
  step_order       INT NOT NULL,
  description      VARCHAR(255) NOT NULL,
  estimated_cost   DECIMAL(12,2) DEFAULT 0,
  next_appointment_date DATE,
  status           ENUM('Pending','Done') NOT NULL DEFAULT 'Pending',
  FOREIGN KEY (plan_id) REFERENCES treatment_plans(plan_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 10. IMAGING & LAB TESTS
-- =====================================================

CREATE TABLE test_orders (
  order_id        INT AUTO_INCREMENT PRIMARY KEY,
  visit_id        INT NOT NULL,
  doctor_id       INT NOT NULL,
  technician_id   INT,                               -- assigned technician (doctors table)
  test_type       VARCHAR(100) NOT NULL,             -- X-ray, Blood test, CT scan...
  cost            DECIMAL(12,2) DEFAULT 0,
  priority_note   VARCHAR(255),
  status          ENUM('Ordered','In Progress','Completed') NOT NULL DEFAULT 'Ordered',
  ordered_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  completed_at    DATETIME,
  technician_note TEXT,
  FOREIGN KEY (visit_id)      REFERENCES visits(visit_id) ON DELETE CASCADE,
  FOREIGN KEY (doctor_id)     REFERENCES doctors(doctor_id),
  FOREIGN KEY (technician_id) REFERENCES users(user_id)
) ENGINE=InnoDB;

CREATE TABLE test_result_files (
  file_id     INT AUTO_INCREMENT PRIMARY KEY,
  order_id    INT NOT NULL,
  file_path   VARCHAR(255) NOT NULL,
  file_type   VARCHAR(50),                           -- image, pdf...
  uploaded_by INT,
  uploaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id)    REFERENCES test_orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
) ENGINE=InnoDB;

-- =====================================================
-- 11. PAYMENT & INVOICE
-- =====================================================

CREATE TABLE invoices (
  invoice_id     INT AUTO_INCREMENT PRIMARY KEY,
  invoice_code   VARCHAR(30) NOT NULL UNIQUE,
  visit_id       INT NOT NULL,
  patient_id     INT NOT NULL,
  subtotal       DECIMAL(12,2) NOT NULL DEFAULT 0,
  discount       DECIMAL(12,2) NOT NULL DEFAULT 0,
  total_amount   DECIMAL(12,2) NOT NULL DEFAULT 0,
  status         ENUM('Unpaid','Paid','Cancelled') NOT NULL DEFAULT 'Unpaid',
  created_by     INT,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (visit_id)   REFERENCES visits(visit_id),
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
  FOREIGN KEY (created_by) REFERENCES users(user_id)
) ENGINE=InnoDB;

CREATE TABLE invoice_items (
  invoice_item_id INT AUTO_INCREMENT PRIMARY KEY,
  invoice_id      INT NOT NULL,
  service_id      INT,
  description     VARCHAR(255),
  quantity        INT NOT NULL DEFAULT 1,
  unit_price      DECIMAL(12,2) NOT NULL DEFAULT 0,
  line_total      DECIMAL(12,2) NOT NULL DEFAULT 0,
  FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id) ON DELETE CASCADE,
  FOREIGN KEY (service_id) REFERENCES services(service_id)
) ENGINE=InnoDB;

CREATE TABLE payments (
  payment_id      INT AUTO_INCREMENT PRIMARY KEY,
  invoice_id      INT NOT NULL,
  amount          DECIMAL(12,2) NOT NULL,
  payment_method  ENUM('Cash','Bank Transfer','Card','Online Gateway') NOT NULL,
  transaction_ref VARCHAR(100),                      -- gateway transaction id
  paid_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  recorded_by     INT,
  FOREIGN KEY (invoice_id)  REFERENCES invoices(invoice_id),
  FOREIGN KEY (recorded_by) REFERENCES users(user_id)
) ENGINE=InnoDB;

-- =====================================================
-- 12. REVIEWS
-- =====================================================

CREATE TABLE reviews (
  review_id    INT AUTO_INCREMENT PRIMARY KEY,
  visit_id     INT NOT NULL UNIQUE,
  patient_id   INT NOT NULL,
  doctor_id    INT NOT NULL,
  rating       TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment      TEXT,
  created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (visit_id)   REFERENCES visits(visit_id),
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
  FOREIGN KEY (doctor_id)  REFERENCES doctors(doctor_id)
) ENGINE=InnoDB;

-- =====================================================
-- SEED ROLES
-- =====================================================
INSERT INTO roles (role_name, description) VALUES
  ('Admin','Quản trị hệ thống'),
  ('Receptionist','Lễ tân'),
  ('Doctor','Bác sĩ'),
  ('Technician','Kỹ thuật viên'),
  ('Customer','Khách hàng / Bệnh nhân');

-- =====================================================
-- Mật khẩu : 123456
-- =====================================================
INSERT INTO users (role_id, username, email, password_hash, full_name, phone_number, is_active) VALUES
  (1, 'admin_test', 'admin@dental.com', '123456', 'Quản Trị Viên', '0901234567', TRUE),
  (2, 'reception_test', 'reception@dental.com', '123456', 'Nhân Viên Lễ Tân', '0901234568', TRUE),
  (3, 'doctor_test', 'doctor@dental.com', '123456', 'Bác Sĩ Trưởng Khoa', '0901234569', TRUE),
  (4, 'tech_test', 'tech@dental.com', '123456', 'Kỹ Thuật Viên', '0901234570', TRUE),
  (5, 'customer_test', 'customer@dental.com', '123456', 'Khách Hàng Vip', '0901234571', TRUE),
  (2, 'reception_01', 'rec01@dental.com', '123456', 'Lễ Tân 01', '0900000001', TRUE),
  (2, 'reception_02', 'rec02@dental.com', '123456', 'Lễ Tân 02', '0900000002', TRUE),
  (3, 'doctor_01', 'doc01@dental.com', '123456', 'Bác Sĩ 01', '0900000003', TRUE),
  (3, 'doctor_02', 'doc02@dental.com', '123456', 'Bác Sĩ 02', '0900000004', TRUE),
  (3, 'doctor_03', 'doc03@dental.com', '123456', 'Bác Sĩ 03', '0900000005', TRUE),
  (3, 'doctor_04', 'doc04@dental.com', '123456', 'Bác Sĩ 04', '0900000006', TRUE),
  (4, 'tech_01', 'tech01@dental.com', '123456', 'Kỹ Thuật Viên 01', '0900000007', TRUE),
  (4, 'tech_02', 'tech02@dental.com', '123456', 'Kỹ Thuật Viên 02', '0900000008', TRUE),
  (4, 'tech_03', 'tech03@dental.com', '123456', 'Kỹ Thuật Viên 03', '0900000009', TRUE),
  (4, 'tech_04', 'tech04@dental.com', '123456', 'Kỹ Thuật Viên 04', '0900000010', TRUE);

-- =====================================================
-- SEED PATIENTS
-- =====================================================
INSERT INTO patients (patient_code, user_id, full_name, date_of_birth, gender, phone_number, email, address, medical_history, drug_allergies) VALUES
  ('PT-2026-0001', 5, 'Khách Hàng Vip', '1990-05-15', 'Male', '0901234571', 'customer@dental.com', '123 Nguyễn Văn Cừ, Quận 5, TP.HCM', 'Không có bệnh lý nền', 'Không'),
  ('PT-2026-0002', NULL, 'Nguyễn Thị Thu Hương', '1985-08-22', 'Female', '0987654321', 'huongnt@email.com', '456 Lê Lợi, Quận 1, TP.HCM', 'Huyết áp thấp', 'Dị ứng thuốc tê nhẹ'),
  ('PT-2026-0003', NULL, 'Trần Văn Nam', '2000-11-10', 'Male', '0912345678', 'namtran@email.com', '789 Xa Lộ Hà Nội, TP. Thủ Đức', 'Tiểu đường tuýp 2', 'Penicillin');

-- Thêm User Mẹ để test tính năng Family Account
INSERT INTO users (role_id, username, email, password_hash, full_name, phone_number, is_active) 
VALUES (5, 'lethime', 'lethime@family.com', '123456', 'Lê Thị Mẹ', '0999888777', TRUE);
SET @motherUserId = LAST_INSERT_ID();

-- Thêm 3 hồ sơ bệnh nhân (1 mẹ, 2 con) dùng chung số điện thoại của mẹ, và chung user_id của mẹ
INSERT INTO patients (patient_code, user_id, full_name, date_of_birth, gender, phone_number, email, address, medical_history, drug_allergies) VALUES
  ('PT-2026-F001', @motherUserId, 'Lê Thị Mẹ', '1988-01-01', 'Female', '0999888777', 'lethime@family.com', 'Khu dân cư ABC, Quận 7', 'Không', 'Không'),
  ('PT-2026-F002', @motherUserId, 'Bé Nguyễn Văn Tèo', '2018-05-05', 'Male', '0999888777', NULL, 'Khu dân cư ABC, Quận 7', 'Không', 'Không'),
  ('PT-2026-F003', @motherUserId, 'Bé Nguyễn Thị Tí', '2020-08-08', 'Female', '0999888777', NULL, 'Khu dân cư ABC, Quận 7', 'Không', 'Không');


-- =====================================================
-- SEED SERVICES
-- =====================================================
INSERT INTO services (service_code, service_name, estimated_minutes, listed_price, description, is_active) VALUES
  ('SV-001', 'Khám Tổng Quát & Tư Vấn', 30, 0.00, 'Khám, chụp X-quang cơ bản và tư vấn phác đồ điều trị ban đầu.', TRUE),
  ('SV-002', 'Cạo Vôi Răng & Đánh Bóng', 45, 300000.00, 'Làm sạch mảng bám, cao răng và đánh bóng bề mặt răng.', TRUE),
  ('SV-003', 'Tẩy Trắng Răng Laser', 60, 2500000.00, 'Tẩy trắng răng công nghệ Laser tiên tiến, không ê buốt.', TRUE),
  ('SV-004', 'Nhổ Răng Khôn (Mọc thẳng)', 45, 1000000.00, 'Nhổ răng khôn hàm trên/dưới mọc thẳng, không tiểu phẫu.', TRUE),
  ('SV-005', 'Trám Răng Thẩm Mỹ', 30, 400000.00, 'Trám composite thẩm mỹ cao cho răng sâu, sứt mẻ nhẹ.', TRUE),
  ('SV-006', 'Bọc Răng Sứ Cercon', 120, 5000000.00, 'Bọc răng sứ toàn sứ Cercon nhập khẩu Đức, bảo hành 10 năm.', TRUE),
  ('SV-007', 'Niềng Răng Mắc Cài Kim Loại', 60, 30000000.00, 'Chỉnh nha bằng mắc cài kim loại tiêu chuẩn.', FALSE),
  ('SV-008', 'Cắm Ghép Implant', 90, 15000000.00, 'Cấy ghép chân răng nhân tạo Implant cao cấp từ Hàn Quốc.', TRUE),
  ('SV-009', 'Lấy Tủy Răng Sữa', 30, 200000.00, 'Điều trị nội nha lấy tủy răng sữa cho trẻ em.', TRUE),
  ('SV-010', 'Nhổ Răng Sữa', 15, 100000.00, 'Nhổ răng sữa sắp rụng, bôi tê nhẹ nhàng không đau.', TRUE),
  ('SV-011', 'Lấy Tủy Răng Vĩnh Viễn', 60, 1000000.00, 'Điều trị tủy răng người lớn bằng máy Protaper.', TRUE),
  ('SV-012', 'Phẫu Thuật Cắt Lợi', 45, 2000000.00, 'Tiểu phẫu cắt lợi trùm, điều trị cười hở lợi thẩm mỹ.', TRUE),
  ('SV-013', 'Bọc Răng Sứ Zirconia', 120, 3500000.00, 'Bọc sứ toàn sứ Zirconia chính hãng.', TRUE),
  ('SV-014', 'Khám & Tư Vấn Chỉnh Nha', 30, 150000.00, 'Lấy dấu răng, chụp phim và lên phác đồ niềng răng.', TRUE),
  ('SV-015', 'Tẩy Trắng Răng Tại Nhà', 15, 1200000.00, 'Làm máng tẩy trắng và cung cấp thuốc tẩy trắng tự dùng tại nhà.', TRUE);

-- =====================================================
-- SEED INVOICES & PAYMENTS
-- =====================================================

-- 1. Create a dummy visit (requires appointments which requires a patient and doctor)
-- Assuming patients 1, 2, 3 and doctors exist.
-- Let's check doctors in database.sql: we have 'doctor_test' user (user_id=3)
-- Insert a doctor profile if not exists
INSERT IGNORE INTO doctors (user_id, specialty, license_no) VALUES (3, 'Nha khoa tổng quát', 'NKK-12345');

-- Create an appointment
INSERT INTO appointments (patient_id, doctor_id, service_id, scheduled_datetime, status, booking_source, created_by)
VALUES (1, 1, 4, '2026-06-07 09:00:00', 'Done', 'Online', 2);

-- Create a visit based on the appointment
INSERT INTO visits (appointment_id, patient_id, doctor_id, visit_date, symptoms, diagnosis, clinical_notes, is_concluded)
VALUES (LAST_INSERT_ID(), 1, 1, '2026-06-07 09:30:00', 'Đau răng khôn', 'Sâu răng khôn số 8', 'Cần nhổ', TRUE);

SET @visitId = LAST_INSERT_ID();

-- Add Test Orders and Treatment Steps for Visit 1 so they auto-load
INSERT INTO test_orders (visit_id, doctor_id, test_type, cost, status)
VALUES (@visitId, 1, 'Chụp X-Quang Toàn Hàm', 150000.00, 'Ordered');

INSERT INTO treatment_plans (patient_id, visit_id, title)
VALUES (1, @visitId, 'Kế hoạch nhổ răng khôn');

SET @planId1 = LAST_INSERT_ID();

INSERT INTO treatment_steps (plan_id, description, step_order, status, estimated_cost)
VALUES (@planId1, 'Vệ sinh khoang miệng và bôi tê', 1, 'Done', 100000.00);

INSERT INTO treatment_steps (plan_id, description, step_order, status, estimated_cost)
VALUES (@planId1, 'Tiểu phẫu nhổ răng khôn', 2, 'Done', 500000.00);

-- 3. Create a paid invoice
INSERT INTO appointments (patient_id, doctor_id, service_id, scheduled_datetime, status, booking_source, created_by)
VALUES (2, 1, 3, '2026-06-05 14:00:00', 'Done', 'Walk-in', 2);

INSERT INTO visits (appointment_id, patient_id, doctor_id, visit_date, symptoms, diagnosis, clinical_notes, is_concluded)
VALUES (LAST_INSERT_ID(), 2, 1, '2026-06-05 14:30:00', 'Muốn tẩy trắng', 'Răng ố vàng nhẹ', 'Tẩy trắng Laser', TRUE);

SET @visitId2 = LAST_INSERT_ID();

INSERT INTO invoices (invoice_code, visit_id, patient_id, subtotal, discount, total_amount, status, created_by)
VALUES ('INV-20260605-002', @visitId2, 2, 2500000.00, 0.00, 2500000.00, 'Paid', 2);

SET @invId2 = LAST_INSERT_ID();

INSERT INTO invoice_items (invoice_id, service_id, description, quantity, unit_price, line_total)
VALUES (@invId2, 3, 'Tẩy Trắng Răng Laser', 1, 2500000.00, 2500000.00);

-- Add a payment for the paid invoice
INSERT INTO payments (invoice_id, amount, payment_method, transaction_ref, paid_at, recorded_by)
VALUES (@invId2, 2500000.00, 'Bank Transfer', 'VCB123456789', '2026-06-05 15:30:00', 2);

-- 4. Create an unpaid invoice
INSERT INTO appointments (patient_id, doctor_id, service_id, scheduled_datetime, status, booking_source, created_by)
VALUES (3, 1, 6, '2026-06-06 10:00:00', 'Done', 'Phone', 2);

INSERT INTO visits (appointment_id, patient_id, doctor_id, visit_date, symptoms, diagnosis, clinical_notes, is_concluded)
VALUES (LAST_INSERT_ID(), 3, 1, '2026-06-06 10:15:00', 'Răng sứt mẻ', 'Mẻ răng cửa', 'Bọc sứ', TRUE);

SET @visitId3 = LAST_INSERT_ID();

