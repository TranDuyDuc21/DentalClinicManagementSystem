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

        if (loggedUser == null || !"Admin".equals(loggedUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String search = request.getParameter("search");
        String status = request.getParameter("status");
        
        int page = 1;
        int limit = 10;
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

        request.getRequestDispatcher("/WEB-INF/views/service/service-list.jsp").forward(request, response);
    }
}
