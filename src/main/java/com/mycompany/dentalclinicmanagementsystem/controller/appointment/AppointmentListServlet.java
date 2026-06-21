package com.mycompany.dentalclinicmanagementsystem.controller.appointment;

import com.mycompany.dentalclinicmanagementsystem.dao.AppointmentDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Appointment;
import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.service.AppointmentService;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AppointmentListServlet", urlPatterns = {"/appointments"})
public class AppointmentListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String searchStr = request.getParameter("search");
        String status = request.getParameter("status");
        String filterDate = request.getParameter("filterDate");
        String doctorIdStr = request.getParameter("doctorId");
        
        if ("All".equalsIgnoreCase(status)) {
            status = null;
        }
        
        Integer doctorIdFilter = null;
        if (doctorIdStr != null && !doctorIdStr.isEmpty()) {
            try {
                doctorIdFilter = Integer.parseInt(doctorIdStr);
            } catch (NumberFormatException e) {}
        }

        String pageStr = request.getParameter("page");
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int limit = 10;
        int offset = (page - 1) * limit;

        AppointmentService service = new AppointmentService();
        List<Appointment> appointments = service.getAppointmentsForUser(loggedUser, status, searchStr, doctorIdFilter, filterDate, offset, limit);
        int totalAppointments = service.getTotalAppointmentsForUser(loggedUser, status, searchStr, doctorIdFilter, filterDate);
        int totalPages = (int) Math.ceil((double) totalAppointments / limit);

        com.mycompany.dentalclinicmanagementsystem.dao.DoctorDAO doctorDAO = new com.mycompany.dentalclinicmanagementsystem.dao.DoctorDAO();
        request.setAttribute("doctors", doctorDAO.getAllActiveDoctors());

        request.setAttribute("appointments", appointments);
        request.setAttribute("pageNumber", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentStatus", status != null ? status : "All");
        
        if ("Customer".equalsIgnoreCase(loggedUser.getRoleName())) {
            request.getRequestDispatcher("/WEB-INF/views/appointment/appointment-list-customer.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/views/appointment/appointment-list.jsp").forward(request, response);
        }
    }
}
