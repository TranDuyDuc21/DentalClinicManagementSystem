package com.mycompany.dentalclinicmanagementsystem.controller;

import com.mycompany.dentalclinicmanagementsystem.dao.DoctorDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.ServiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Doctor;
import com.mycompany.dentalclinicmanagementsystem.model.Service;
import com.mycompany.dentalclinicmanagementsystem.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final DoctorDAO doctorDAO = new DoctorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Service> services = serviceDAO.getAllServices(null, "true", 0, 10); // Display top 10 services
        List<Doctor> doctors = doctorDAO.getAllActiveDoctors(); // Display active doctors

        request.setAttribute("services", services);
        request.setAttribute("doctors", doctors);

        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String serviceId = request.getParameter("serviceId");
        String doctorId = request.getParameter("doctorId");

        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        String targetUrl = "/appointment-form";
        boolean hasParams = false;

        if (serviceId != null && !serviceId.isEmpty()) {
            targetUrl += "?serviceId=" + serviceId;
            hasParams = true;
        }

        if (doctorId != null && !doctorId.isEmpty()) {
            targetUrl += (hasParams ? "&" : "?") + "doctorId=" + doctorId;
        }

        if (loggedUser == null) {
            String redirectParam = URLEncoder.encode(targetUrl, "UTF-8");
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + redirectParam);
        } else {
            response.sendRedirect(request.getContextPath() + targetUrl);
        }
    }
}
