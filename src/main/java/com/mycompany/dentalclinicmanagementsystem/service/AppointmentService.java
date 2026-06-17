package com.mycompany.dentalclinicmanagementsystem.service;

import com.mycompany.dentalclinicmanagementsystem.dao.AppointmentDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.DoctorDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.PatientDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Appointment;
import com.mycompany.dentalclinicmanagementsystem.model.Doctor;
import com.mycompany.dentalclinicmanagementsystem.model.Patient;
import com.mycompany.dentalclinicmanagementsystem.model.User;

import java.sql.Timestamp;
import java.util.List;

public class AppointmentService {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final PatientDAO patientDAO = new PatientDAO();
    private final DoctorDAO doctorDAO = new DoctorDAO();
    private final EmailService emailService = new EmailService();
    private final com.mycompany.dentalclinicmanagementsystem.dao.EmployeeScheduleDAO employeeScheduleDAO = new com.mycompany.dentalclinicmanagementsystem.dao.EmployeeScheduleDAO();

    public static class BookingResult {
        public boolean success;
        public String message;
        public BookingResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }

    private BookingResult checkScheduleAvailability(int doctorId, Timestamp scheduledDatetime) {
        Doctor doc = doctorDAO.getDoctorById(doctorId);
        if (doc == null) {
            return new BookingResult(false, "Không tìm thấy thông tin Bác sĩ.");
        }
        int userId = doc.getUserId();

        java.time.LocalDateTime localDateTime = scheduledDatetime.toLocalDateTime();
        java.sql.Date workDate = java.sql.Date.valueOf(localDateTime.toLocalDate());
        java.sql.Time apptTime = java.sql.Time.valueOf(localDateTime.toLocalTime());
        
        java.util.List<com.mycompany.dentalclinicmanagementsystem.model.EmployeeSchedule> schedules = employeeScheduleDAO.getAllSchedules(userId, workDate, workDate, 0, 100);
        if (schedules.isEmpty()) {
            return new BookingResult(false, "Bác sĩ chưa có lịch làm việc vào ngày này.");
        }
        
        for (com.mycompany.dentalclinicmanagementsystem.model.EmployeeSchedule es : schedules) {
            if (es.isDayOff()) {
                // If the only schedule or any schedule marks the day off, and we match its shift or just generally. 
                // Usually if they have a schedule and it's day off, they are off.
                // To be precise, if they are off for the whole day, we might have 1 record.
                return new BookingResult(false, "Bác sĩ đã đăng ký nghỉ vào ngày này.");
            }
            
            if ((apptTime.after(es.getStartTime()) || apptTime.equals(es.getStartTime())) &&
                (apptTime.before(es.getEndTime()) || apptTime.equals(es.getEndTime()))) {
                return new BookingResult(true, "Available");
            }
        }
        
        return new BookingResult(false, "Giờ hẹn không nằm trong ca làm việc của bác sĩ.");
    }

    public BookingResult processBooking(User user, int doctorId, Integer serviceId, Timestamp scheduledDatetime, String bookingSource) {
        // 1. Resolve Patient
        int patientId;
        if (user.getRoleName() != null && user.getRoleName().equalsIgnoreCase("Customer")) {
            Patient p = patientDAO.getPatientByUserId(user.getUserId());
            if (p == null) {
                // Tự động khởi tạo Patient từ User
                boolean created = patientDAO.createPatientFromUser(user);
                if (!created) {
                    return new BookingResult(false, "Không thể khởi tạo hồ sơ bệnh nhân từ tài khoản của bạn.");
                }
                p = patientDAO.getPatientByUserId(user.getUserId());
            }
            patientId = p.getPatientId();
        } else {
            // Đối với Receptionist tạo cho khách vãng lai, lúc này user là receptionist, 
            // patientId phải lấy từ form (sẽ xử lý ở hàm khác hoặc truyền trực tiếp vào).
            // Tạm thời trả lỗi nếu gọi hàm này không đúng cách.
            return new BookingResult(false, "Tài khoản nhân viên không thể đặt lịch bằng hàm này, hãy dùng form dành cho nhân viên.");
        }

        // 1.5 Kiểm tra lịch làm việc của bác sĩ
        BookingResult scheduleCheck = checkScheduleAvailability(doctorId, scheduledDatetime);
        if (!scheduleCheck.success) {
            return scheduleCheck;
        }

        // 2. Kiểm tra trùng lịch
        if (appointmentDAO.checkConflict(doctorId, scheduledDatetime)) {
            return new BookingResult(false, "Bác sĩ đã có lịch hẹn hoặc bị trùng vào khoảng thời gian này.");
        }

        // 3. Tạo Appointment
        Appointment appt = new Appointment();
        appt.setPatientId(patientId);
        appt.setDoctorId(doctorId);
        appt.setServiceId(serviceId);
        appt.setScheduledDatetime(scheduledDatetime);
        appt.setBookingSource(bookingSource);
        appt.setCreatedBy(user.getUserId()); // Customer self-book

        boolean isAdded = appointmentDAO.addAppointment(appt);
        if (isAdded) {
            // 4. Gửi email thông báo (bất đồng bộ hoặc giả lập)
            emailService.sendAppointmentConfirmation(user.getEmail(), user.getFullName(), scheduledDatetime.toString());
            return new BookingResult(true, "Đặt lịch hẹn thành công!");
        }

        return new BookingResult(false, "Đã xảy ra lỗi khi tạo lịch hẹn. Vui lòng thử lại.");
    }
    
    // Dành cho Receptionist đặt hộ
    public BookingResult processBookingForPatient(int createdByUserId, int patientId, int doctorId, Integer serviceId, Timestamp scheduledDatetime, String bookingSource) {
        // Kiểm tra lịch làm việc của bác sĩ
        BookingResult scheduleCheck = checkScheduleAvailability(doctorId, scheduledDatetime);
        if (!scheduleCheck.success) {
            return scheduleCheck;
        }

        if (appointmentDAO.checkConflict(doctorId, scheduledDatetime)) {
            return new BookingResult(false, "Bác sĩ đã có lịch hẹn hoặc bị trùng vào khoảng thời gian này.");
        }

        Appointment appt = new Appointment();
        appt.setPatientId(patientId);
        appt.setDoctorId(doctorId);
        appt.setServiceId(serviceId);
        appt.setScheduledDatetime(scheduledDatetime);
        appt.setBookingSource(bookingSource);
        appt.setCreatedBy(createdByUserId);

        boolean isAdded = appointmentDAO.addAppointment(appt);
        if (isAdded) {
            return new BookingResult(true, "Đặt lịch hẹn cho khách thành công!");
        }
        return new BookingResult(false, "Lỗi khi tạo lịch hẹn.");
    }

    public List<Appointment> getAppointmentsForUser(User user, String status, String searchStr, int offset, int limit) {
        String role = user.getRoleName();
        if ("Customer".equalsIgnoreCase(role)) {
            Patient p = patientDAO.getPatientByUserId(user.getUserId());
            if (p == null) return java.util.Collections.emptyList();
            return appointmentDAO.getAllAppointmentsByRole(null, p.getPatientId(), status, searchStr, offset, limit);
        } else if ("Doctor".equalsIgnoreCase(role)) {
            Integer doctorId = doctorDAO.getDoctorIdByUserId(user.getUserId());
            if (doctorId == null) return java.util.Collections.emptyList();
            return appointmentDAO.getAllAppointmentsByRole(doctorId, null, status, searchStr, offset, limit);
        } else {
            // Receptionist, Admin, Technician
            return appointmentDAO.getAllAppointmentsByRole(null, null, status, searchStr, offset, limit);
        }
    }

    public int getTotalAppointmentsForUser(User user, String status, String searchStr) {
        String role = user.getRoleName();
        if ("Customer".equalsIgnoreCase(role)) {
            Patient p = patientDAO.getPatientByUserId(user.getUserId());
            if (p == null) return 0;
            return appointmentDAO.getTotalAppointmentsByRole(null, p.getPatientId(), status, searchStr);
        } else if ("Doctor".equalsIgnoreCase(role)) {
            Integer doctorId = doctorDAO.getDoctorIdByUserId(user.getUserId());
            if (doctorId == null) return 0;
            return appointmentDAO.getTotalAppointmentsByRole(doctorId, null, status, searchStr);
        } else {
            return appointmentDAO.getTotalAppointmentsByRole(null, null, status, searchStr);
        }
    }
}
