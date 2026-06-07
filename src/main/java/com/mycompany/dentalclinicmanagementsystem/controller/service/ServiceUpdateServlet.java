package com.mycompany.dentalclinicmanagementsystem.controller.service;

import com.mycompany.dentalclinicmanagementsystem.dao.ServiceDAO;
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

@WebServlet("/admin/services/update")
public class ServiceUpdateServlet extends HttpServlet {

    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        serviceDAO = new ServiceDAO();
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
            Service service = serviceDAO.getServiceById(id);
            if (service != null) {
                request.setAttribute("service", service);
                request.getRequestDispatcher("/WEB-INF/views/service/service-form.jsp").forward(request, response);
            } else {
                session.setAttribute("errorMessage", "Không tìm thấy dịch vụ.");
                response.sendRedirect(request.getContextPath() + "/admin/services");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/services");
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
            String serviceName = request.getParameter("serviceName");
            String estimatedMinutesStr = request.getParameter("estimatedMinutes");
            String listedPriceStr = request.getParameter("listedPrice");
            String description = request.getParameter("description");
            boolean isActive = "true".equals(request.getParameter("isActive"));

            Service service = new Service();
            service.setServiceId(serviceId);
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

            if (serviceDAO.updateService(service)) {
                session.setAttribute("successMessage", "Cập nhật dịch vụ thành công.");
                response.sendRedirect(request.getContextPath() + "/admin/services");
            } else {
                session.setAttribute("errorMessage", "Đã xảy ra lỗi khi cập nhật dịch vụ.");
                response.sendRedirect(request.getContextPath() + "/admin/services/update?id=" + serviceId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ.");
            if (serviceId != -1) {
                response.sendRedirect(request.getContextPath() + "/admin/services/update?id=" + serviceId);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/services");
            }
        }
    }
}
