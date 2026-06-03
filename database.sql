-- =====================================================
-- DENTAL CLINIC MANAGEMENT SYSTEM - MySQL Database
-- =====================================================

CREATE DATABASE IF NOT EXISTS dental_clinic
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE dental_clinic;

-- =====================================================
-- 1. ROLES & USERS (UC02-UC05, UC30, UC43)
-- =====================================================

CREATE TABLE roles (
  role_id      INT AUTO_INCREMENT PRIMARY KEY,
  role_name    ENUM('Admin','Receptionist','Doctor','Technician','Customer') NOT NULL UNIQUE,
  description  VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE permissions (
  permission_id   INT AUTO_INCREMENT PRIMARY KEY,
  permission_code VARCHAR(100) NOT NULL UNIQUE,   -- e.g. 'UC14_ORDER_TEST'
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

-- Password reset tokens (UC04)
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
-- 2. DOCTOR PROFILE & CHAIRS (UC46)
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
-- 3. SERVICE CATALOG (UC31)
-- =====================================================

CREATE TABLE services (
  service_id        INT AUTO_INCREMENT PRIMARY KEY,
  service_name      VARCHAR(150) NOT NULL,
  estimated_minutes INT,
  listed_price      DECIMAL(12,2) NOT NULL DEFAULT 0,
  description       TEXT,
  is_active         BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB;

-- =====================================================
-- 4. DOCTOR WORK SCHEDULE (UC27-UC29)
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
-- 5. PATIENT RECORDS (UC17-UC20)
-- =====================================================

CREATE TABLE patients (
  patient_id     INT AUTO_INCREMENT PRIMARY KEY,
  patient_code   VARCHAR(20) NOT NULL UNIQUE,       -- PT-YYYY-XXXX
  user_id        INT UNIQUE,                         -- linked customer account (nullable for walk-ins)
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
-- 6. APPOINTMENTS (UC06-UC13, UC16)
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

-- Email notifications/reminders log (UC08, UC11)
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
-- 7. VISIT / EXAM RECORD (UC16, UC19-UC23)
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

-- Tooth/gum condition by position - dental chart (UC19)
CREATE TABLE dental_chart_entries (
  entry_id      INT AUTO_INCREMENT PRIMARY KEY,
  visit_id      INT NOT NULL,
  tooth_position VARCHAR(10) NOT NULL,              -- e.g. FDI '11','48'
  condition     VARCHAR(150),
  note          TEXT,
  FOREIGN KEY (visit_id) REFERENCES visits(visit_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 8. MEDICATIONS & PRESCRIPTIONS (UC21)
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
-- 9. TREATMENT PLANS (UC22)
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
-- 10. IMAGING & LAB TESTS (UC14, UC15, UC24-UC26)
-- =====================================================

CREATE TABLE test_orders (
  order_id        INT AUTO_INCREMENT PRIMARY KEY,
  visit_id        INT NOT NULL,
  doctor_id       INT NOT NULL,
  technician_id   INT,                               -- assigned technician (doctors table)
  test_type       VARCHAR(100) NOT NULL,             -- X-ray, Blood test, CT scan...
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
-- 11. PAYMENT & INVOICE (UC32-UC37)
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
-- 12. REVIEWS (UC45)
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