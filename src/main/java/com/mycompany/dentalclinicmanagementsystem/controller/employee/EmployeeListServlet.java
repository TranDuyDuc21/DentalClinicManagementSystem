package com.mycompany.dentalclinicmanagementsystem.controller.employee;

import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.service.EmployeeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

@WebServlet("/employees")
public class EmployeeListServlet extends HttpServlet {

    private EmployeeService employeeService;

    @Override
    public void init() throws ServletException {
        employeeService = new EmployeeService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        // Check if admin
        if (loggedUser == null || !"Admin".equals(loggedUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String search = request.getParameter("search");
        String roleIdStr = request.getParameter("roleId");
        String statusStr = request.getParameter("status");

        Integer roleId = (roleIdStr != null && !roleIdStr.isEmpty()) ? Integer.parseInt(roleIdStr) : null;
        Boolean status = (statusStr != null && !statusStr.isEmpty()) ? Boolean.parseBoolean(statusStr) : null;

        String pageStr = request.getParameter("page");
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int limit = 10;

        Map<String, Object> result = employeeService.getEmployeesList(search, roleId, status, page, limit);
        
        request.setAttribute("employees", result.get("employees"));
        request.setAttribute("roles", result.get("roles"));
        request.setAttribute("pageNumber", result.get("pageNumber"));
        request.setAttribute("totalPages", result.get("totalPages"));
        
        request.getRequestDispatcher("/WEB-INF/views/employee/employee-list.jsp").forward(request, response);
    }
}
