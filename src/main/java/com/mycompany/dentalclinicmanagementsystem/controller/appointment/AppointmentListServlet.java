package com.mycompany.dentalclinicmanagementsystem.controller.appointment;

import com.mycompany.dentalclinicmanagementsystem.dao.AppointmentDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Appointment;

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
        String searchStr = request.getParameter("search");
        String status = request.getParameter("status");
        
        if ("All".equalsIgnoreCase(status)) {
            status = null;
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

        AppointmentDAO dao = new AppointmentDAO();
        List<Appointment> appointments = dao.getAllAppointments(status, searchStr, offset, limit);
        int totalAppointments = dao.getTotalAppointments(status, searchStr);
        int totalPages = (int) Math.ceil((double) totalAppointments / limit);

        request.setAttribute("appointments", appointments);
        request.setAttribute("pageNumber", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentStatus", status != null ? status : "All");
        
        request.getRequestDispatcher("/WEB-INF/views/appointment/appointment-list.jsp").forward(request, response);
    }
}
