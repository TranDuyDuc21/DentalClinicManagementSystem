package com.mycompany.dentalclinicmanagementsystem.controller.appointment;

import com.mycompany.dentalclinicmanagementsystem.dao.AppointmentDAO;
import com.mycompany.dentalclinicmanagementsystem.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AppointmentActionServlet", urlPatterns = {"/appointment-action"})
public class AppointmentActionServlet extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String action = request.getParameter("action"); // cancel, check-in, done, in-exam

            if ("reschedule".equals(action)) {
                String newDate = request.getParameter("newDate"); // YYYY-MM-DD
                String newTime = request.getParameter("newTime"); // HH:mm:ss or HH:mm
                
                if (newDate != null && newTime != null) {
                    String dtStr = newDate + "T" + newTime;
                    if (newTime.length() == 5) dtStr += ":00"; // Ensure seconds are present for parsing
                    java.sql.Timestamp newTimestamp = java.sql.Timestamp.valueOf(java.time.LocalDateTime.parse(dtStr, java.time.format.DateTimeFormatter.ISO_LOCAL_DATE_TIME));
                    
                    boolean updated = appointmentDAO.rescheduleAppointment(appointmentId, newTimestamp);
                    if (updated) {
                        session.setAttribute("successMessage", "Đã đổi lịch hẹn thành công sang ngày " + newDate + " lúc " + newTime + ".");
                        response.sendRedirect(request.getContextPath() + "/appointments");
                        return;
                    } else {
                        session.setAttribute("errorMessage", "Không thể đổi lịch. Giờ này có thể đã được đặt hoặc bác sĩ không có ca làm việc.");
                    }
                } else {
                    session.setAttribute("errorMessage", "Vui lòng chọn ngày và giờ hợp lệ.");
                }
            } else {
                String newStatus = null;
                if ("cancel".equals(action)) newStatus = "Cancelled";
                else if ("check-in".equals(action)) newStatus = "Waiting";
                else if ("in-exam".equals(action)) newStatus = "In Exam";
                else if ("done".equals(action)) newStatus = "Done";

                if (newStatus != null) {
                    boolean updated = appointmentDAO.updateAppointmentStatus(appointmentId, newStatus);
                    if (updated) {
                        session.setAttribute("successMessage", "Đã cập nhật trạng thái lịch hẹn thành công.");
                    } else {
                        session.setAttribute("errorMessage", "Không thể cập nhật trạng thái. Vui lòng thử lại.");
                    }
                }
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
        }

        String referer = request.getHeader("Referer");
        if (referer != null) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/appointments");
        }
    }
}
