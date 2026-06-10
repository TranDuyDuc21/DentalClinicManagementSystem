package com.mycompany.dentalclinicmanagementsystem.controller.employee;

import com.mycompany.dentalclinicmanagementsystem.dao.RoleDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.UserDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Role;
import com.mycompany.dentalclinicmanagementsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/employees")
public class EmployeeListServlet extends HttpServlet {

    private UserDAO userDAO;
    private RoleDAO roleDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        roleDAO = new RoleDAO();
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
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int limit = 10;
        int offset = (page - 1) * limit;

        List<User> employees = userDAO.getEmployees(search, roleId, status, offset, limit);
        int totalEmployees = userDAO.getTotalEmployees(search, roleId, status);
        int totalPages = (int) Math.ceil((double) totalEmployees / limit);

        List<Role> roles = roleDAO.getAllRolesForEmployees();
        
        request.setAttribute("employees", employees);
        request.setAttribute("roles", roles);
        request.setAttribute("pageNumber", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/WEB-INF/views/employee/employee-list.jsp").forward(request, response);
    }
}
