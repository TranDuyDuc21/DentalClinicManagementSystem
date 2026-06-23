package com.mycompany.dentalclinicmanagementsystem.controller.service;

import com.mycompany.dentalclinicmanagementsystem.service.ClinicService;
import com.mycompany.dentalclinicmanagementsystem.model.Service;
import com.mycompany.dentalclinicmanagementsystem.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/services")
public class ServiceListServlet extends HttpServlet {

    private ClinicService clinicService;

    @Override
    public void init() throws ServletException {
        clinicService = new ClinicService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        boolean isCustomerOrGuest = (loggedUser == null || "Customer".equals(loggedUser.getRoleName()));

        String search = request.getParameter("search");
        String status = request.getParameter("status");
        
        // For customers, only show active services
        if (isCustomerOrGuest) {
            status = "true";
        }
        
        int page = 1;
        int limit = isCustomerOrGuest ? 9 : 10; // 9 cards per page for nice 3x3 grid
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        int offset = (page - 1) * limit;
        int totalRecords = clinicService.getTotalServices(search, status);
        int totalPages = (int) Math.ceil((double) totalRecords / limit);

        List<Service> services = clinicService.getAllServices(search, status, offset, limit);

        request.setAttribute("services", services);
        request.setAttribute("pageNumber", page);
        request.setAttribute("totalPages", totalPages);

        if (isCustomerOrGuest) {
            request.getRequestDispatcher("/WEB-INF/views/service/service-list-customer.jsp").forward(request, response);
        } else {
            // For other roles, if they are not Admin, they shouldn't access the management list, but let's assume Receptionist can view
            request.getRequestDispatcher("/WEB-INF/views/service/service-list.jsp").forward(request, response);
        }
    }
}
