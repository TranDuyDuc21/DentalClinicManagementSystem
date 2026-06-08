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

        AppointmentDAO dao = new AppointmentDAO();
        List<Appointment> appointments = dao.getAllAppointments(status, searchStr);

        request.setAttribute("appointments", appointments);
        request.setAttribute("currentStatus", status != null ? status : "All");
        
        request.getRequestDispatcher("/WEB-INF/views/appointment/appointment-list.jsp").forward(request, response);
    }
}
