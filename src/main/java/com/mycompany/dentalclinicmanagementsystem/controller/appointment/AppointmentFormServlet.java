package com.mycompany.dentalclinicmanagementsystem.controller.appointment;

import com.mycompany.dentalclinicmanagementsystem.dao.DoctorDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.PatientDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.ServiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Doctor;
import com.mycompany.dentalclinicmanagementsystem.model.Patient;
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

@WebServlet(name = "AppointmentFormServlet", urlPatterns = {"/appointment-form"})
public class AppointmentFormServlet extends HttpServlet {

    private final DoctorDAO doctorDAO = new DoctorDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final PatientDAO patientDAO = new PatientDAO();
    private final AppointmentService appointmentService = new AppointmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Doctor> doctors = doctorDAO.getAllActiveDoctors();
        List<Service> services = serviceDAO.getAllServices(null, "true", 0, 100);

        request.setAttribute("doctors", doctors);
        request.setAttribute("services", services);

        // Nếu là lễ tân tạo hộ, cần list danh sách bệnh nhân hoặc cho phép nhập mã
        if (!"Customer".equalsIgnoreCase(loggedUser.getRoleName())) {
            List<Patient> patients = patientDAO.getAllPatients(null, null, 0, 100);
            request.setAttribute("patients", patients);
        }

        request.getRequestDispatcher("/WEB-INF/views/appointment/appointment-form.jsp").forward(request, response);
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
            
            String datetimeStr = request.getParameter("scheduledDatetime"); // YYYY-MM-DDTHH:mm
            LocalDateTime localDateTime = LocalDateTime.parse(datetimeStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            Timestamp scheduledDatetime = Timestamp.valueOf(localDateTime);

            AppointmentService.BookingResult result;

            if ("Customer".equalsIgnoreCase(loggedUser.getRoleName())) {
                result = appointmentService.processBooking(loggedUser, doctorId, serviceId, scheduledDatetime, "Online");
            } else {
                int patientId = Integer.parseInt(request.getParameter("patientId"));
                result = appointmentService.processBookingForPatient(loggedUser.getUserId(), patientId, doctorId, serviceId, scheduledDatetime, "Walk-in");
            }

            if (result.success) {
                session.setAttribute("successMessage", result.message);
                response.sendRedirect(request.getContextPath() + "/appointments");
            } else {
                session.setAttribute("errorMessage", result.message);
                response.sendRedirect(request.getContextPath() + "/appointment-form");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/appointment-form");
        }
    }
}
