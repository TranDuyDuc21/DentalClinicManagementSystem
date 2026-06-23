package com.mycompany.dentalclinicmanagementsystem.util;

import com.mycompany.dentalclinicmanagementsystem.model.Appointment;

public class EmailService {
    
    /**
     * Simulates sending an email confirmation for an appointment.
     * In a real application, this would use JavaMail API or a third-party service like SendGrid.
     */
    public static void sendAppointmentConfirmation(String toEmail, String patientName, Appointment appt) {
        System.out.println("==========================================================");
        System.out.println("MOCK EMAIL SENT");
        System.out.println("To: " + toEmail);
        System.out.println("Subject: Xác nhận lịch khám tại Dental Clinic");
        System.out.println("Body:");
        System.out.println("Kính chào " + patientName + ",");
        System.out.println("Chúng tôi xin xác nhận lịch khám của bạn đã được đặt thành công.");
        System.out.println("Thời gian: " + appt.getScheduledDatetime());
        System.out.println("Vui lòng đến trước giờ khám 10 phút.");
        System.out.println("Trân trọng,");
        System.out.println("Dental Clinic Management");
        System.out.println("==========================================================");
    }
}
