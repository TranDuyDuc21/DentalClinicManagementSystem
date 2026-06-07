package com.mycompany.dentalclinicmanagementsystem.controller.service;

import com.mycompany.dentalclinicmanagementsystem.dao.ServiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/services/toggle")
public class ServiceToggleServlet extends HttpServlet {

    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        serviceDAO = new ServiceDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null || !"Admin".equals(loggedUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean status = Boolean.parseBoolean(request.getParameter("status"));

            if (serviceDAO.toggleServiceStatus(id, status)) {
                session.setAttribute("successMessage", status ? "Đã kích hoạt dịch vụ thành công." : "Đã tạm ngưng dịch vụ thành công.");
            } else {
                session.setAttribute("errorMessage", "Đã xảy ra lỗi khi thay đổi trạng thái dịch vụ.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Yêu cầu không hợp lệ.");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/services");
    }
}
