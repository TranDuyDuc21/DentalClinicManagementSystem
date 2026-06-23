package com.mycompany.dentalclinicmanagementsystem.controller.service;

import com.mycompany.dentalclinicmanagementsystem.model.Service;
import com.mycompany.dentalclinicmanagementsystem.service.ClinicService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/service-detail")
public class ServiceDetailServlet extends HttpServlet {

    private ClinicService clinicService;

    @Override
    public void init() throws ServletException {
        clinicService = new ClinicService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/services");
            return;
        }

        try {
            int serviceId = Integer.parseInt(idStr);
            Service service = clinicService.getServiceById(serviceId);

            if (service == null || !service.isActive()) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy dịch vụ hoặc dịch vụ đã ngừng hoạt động.");
                response.sendRedirect(request.getContextPath() + "/services");
                return;
            }

            request.setAttribute("service", service);
            request.getRequestDispatcher("/WEB-INF/views/service/service-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/services");
        }
    }
}
