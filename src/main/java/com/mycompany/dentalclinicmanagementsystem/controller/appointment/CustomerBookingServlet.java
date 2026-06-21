package com.mycompany.dentalclinicmanagementsystem.controller.appointment;

import com.mycompany.dentalclinicmanagementsystem.dao.DoctorDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.ServiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Appointment;
import com.mycompany.dentalclinicmanagementsystem.model.Doctor;
import com.mycompany.dentalclinicmanagementsystem.model.Service;
import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.service.AppointmentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/booking")
public class CustomerBookingServlet extends HttpServlet {

    private final DoctorDAO doctorDAO = new DoctorDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final AppointmentService appointmentService = new AppointmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");



        String serviceIdStr = request.getParameter("serviceId");
        if (serviceIdStr != null && !serviceIdStr.isEmpty()) {
            try {
                Service service = serviceDAO.getServiceById(Integer.parseInt(serviceIdStr));
                request.setAttribute("selectedService", service);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }

        List<Doctor> doctors = doctorDAO.getAllActiveDoctors();
        List<Service> services = serviceDAO.getAllServices(null, "true", 0, 100);

        request.setAttribute("doctors", doctors);
        request.setAttribute("services", services);

        request.getRequestDispatcher("/WEB-INF/views/appointment/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String serviceIdStr = request.getParameter("serviceId");
            Integer serviceId = (serviceIdStr != null && !serviceIdStr.isEmpty()) ? Integer.parseInt(serviceIdStr) : null;
            
            String dateStr = request.getParameter("bookingDate"); // YYYY-MM-DD
            String timeStr = request.getParameter("bookingTime"); // HH:mm
            
            if (dateStr == null || timeStr == null || dateStr.isEmpty() || timeStr.isEmpty()) {
                throw new Exception("Vui lòng chọn đầy đủ ngày và giờ khám.");
            }

            String datetimeStr = dateStr + "T" + timeStr;
            LocalDateTime localDateTime = LocalDateTime.parse(datetimeStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            Timestamp scheduledDatetime = Timestamp.valueOf(localDateTime);

            AppointmentService.BookingResult result = appointmentService.processBooking(loggedUser, doctorId, serviceId, scheduledDatetime, "Online");

            if (result.success) {
                session.setAttribute("successMessage", "Đặt lịch thành công! Cảm ơn bạn đã tin tưởng dịch vụ của chúng tôi.");
                
                // Simulate sending email
                Appointment appt = new Appointment();
                appt.setScheduledDatetime(scheduledDatetime);
                com.mycompany.dentalclinicmanagementsystem.util.EmailService.sendAppointmentConfirmation(loggedUser.getEmail(), loggedUser.getFullName(), appt);
                
                response.sendRedirect(request.getContextPath() + "/appointments");
            } else {
                session.setAttribute("errorMessage", result.message);
                response.sendRedirect(request.getContextPath() + "/booking?serviceId=" + (serviceId != null ? serviceId : ""));
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/booking");
        }
    }
}
