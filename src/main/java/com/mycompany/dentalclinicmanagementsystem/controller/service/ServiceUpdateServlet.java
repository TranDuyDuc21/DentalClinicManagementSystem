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
import java.math.BigDecimal;

@WebServlet("/services/update")
public class ServiceUpdateServlet extends HttpServlet {

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

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Service service = clinicService.getServiceById(id);
            if (service != null) {
                request.setAttribute("service", service);
                request.getRequestDispatcher("/WEB-INF/views/service/service-form.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage", "Không tìm thấy dịch vụ.");
                response.sendRedirect(request.getContextPath() + "/services");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/services");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null || !"Admin".equals(loggedUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int serviceId = -1;
        try {
            serviceId = Integer.parseInt(request.getParameter("serviceId"));
            String serviceCode = request.getParameter("serviceCode");
            String serviceName = request.getParameter("serviceName");
            String estimatedMinutesStr = request.getParameter("estimatedMinutes");
            String listedPriceStr = request.getParameter("listedPrice");
            String description = request.getParameter("description");
            boolean isActive = "true".equals(request.getParameter("isActive"));

            Service service = new Service();
            service.setServiceId(serviceId);
            service.setServiceCode(serviceCode);
            service.setServiceName(serviceName);
            if (estimatedMinutesStr != null && !estimatedMinutesStr.trim().isEmpty()) {
                service.setEstimatedMinutes(Integer.parseInt(estimatedMinutesStr));
            }
            if (listedPriceStr != null && !listedPriceStr.trim().isEmpty()) {
                service.setListedPrice(new BigDecimal(listedPriceStr));
            } else {
                service.setListedPrice(BigDecimal.ZERO);
            }
            service.setDescription(description);
            service.setActive(isActive);

            clinicService.updateService(service);
            session.setAttribute("successMessage", "Cập nhật dịch vụ thành công.");
            response.sendRedirect(request.getContextPath() + "/services");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", e.getMessage());
            if (serviceId != -1) {
                response.sendRedirect(request.getContextPath() + "/services/update?id=" + serviceId);
            } else {
                response.sendRedirect(request.getContextPath() + "/services");
            }
        }
    }
}
