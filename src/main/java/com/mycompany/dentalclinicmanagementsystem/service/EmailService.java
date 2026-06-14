package com.mycompany.dentalclinicmanagementsystem.service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {

    // THAY ĐỔI EMAIL VÀ PASSWORD Ở ĐÂY
    private static final String SMTP_EMAIL = "kamilalee255@gmail.com"; 
    private static final String SMTP_PASSWORD = "mdpj sobq tufd kmgm"; 

    public static boolean sendPasswordResetOtp(String toEmail, String otp) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_EMAIL, SMTP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_EMAIL, "Dental Clinic System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Yêu cầu đặt lại mật khẩu - Mã OTP");

            String htmlContent = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px;'>"
                    + "<h2 style='color: #0ea5e9; text-align: center;'>Dental Clinic</h2>"
                    + "<p>Xin chào,</p>"
                    + "<p>Chúng tôi đã nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>"
                    + "<p>Mã OTP của bạn là: <strong style='font-size: 24px; color: #ef4444; letter-spacing: 2px;'>" + otp + "</strong></p>"
                    + "<p>Mã này sẽ hết hạn sau 15 phút. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>"
                    + "<br>"
                    + "<p>Trân trọng,<br>Ban quản trị Dental Clinic</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("OTP sent successfully to " + toEmail);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Failed to send email to " + toEmail);
            return false;
        }
    }

    public boolean sendAppointmentConfirmation(String toEmail, String patientName, String datetimeStr) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_EMAIL, SMTP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_EMAIL, "Dental Clinic System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Xác nhận đặt lịch hẹn - Dental Clinic");

            String htmlContent = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px;'>"
                    + "<h2 style='color: #0ea5e9; text-align: center;'>Dental Clinic</h2>"
                    + "<p>Xin chào <strong>" + patientName + "</strong>,</p>"
                    + "<p>Lịch hẹn khám nha khoa của bạn đã được hệ thống ghi nhận thành công.</p>"
                    + "<p>Thời gian dự kiến: <strong style='color: #ef4444;'>" + datetimeStr + "</strong></p>"
                    + "<p>Vui lòng đến trước 10 phút để quầy lễ tân sắp xếp. Nếu bạn muốn hủy hoặc dời lịch, vui lòng thực hiện trên hệ thống hoặc liên hệ với chúng tôi.</p>"
                    + "<br>"
                    + "<p>Trân trọng,<br>Ban quản trị Dental Clinic</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Appointment confirmation sent successfully to " + toEmail);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Failed to send appointment confirmation to " + toEmail);
            return false;
        }
    }
}
