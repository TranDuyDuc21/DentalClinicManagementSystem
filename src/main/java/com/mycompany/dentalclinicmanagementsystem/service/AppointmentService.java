package com.mycompany.dentalclinicmanagementsystem.service;

import com.mycompany.dentalclinicmanagementsystem.dao.AppointmentDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.DoctorDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.PatientDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Appointment;
import com.mycompany.dentalclinicmanagementsystem.model.Patient;
import com.mycompany.dentalclinicmanagementsystem.model.User;

import java.sql.Timestamp;
import java.util.List;

public class AppointmentService {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final PatientDAO patientDAO = new PatientDAO();
    private final DoctorDAO doctorDAO = new DoctorDAO();
    private final EmailService emailService = new EmailService();

    public static class BookingResult {
        public boolean success;
        public String message;
        public BookingResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
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
