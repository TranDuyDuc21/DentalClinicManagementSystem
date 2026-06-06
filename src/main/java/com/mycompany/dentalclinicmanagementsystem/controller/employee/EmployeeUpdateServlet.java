package com.mycompany.dentalclinicmanagementsystem.controller.employee;

import com.mycompany.dentalclinicmanagementsystem.dao.RoleDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.UserDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Role;
import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/employees/update")
public class EmployeeUpdateServlet extends HttpServlet {

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

        if (loggedUser == null || !"Admin".equals(loggedUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        User employee = userDAO.getEmployeeById(id);
        
        if (employee == null) {
            session.setAttribute("errorMessage", "Không tìm thấy nhân viên.");
            response.sendRedirect(request.getContextPath() + "/employees");
            return;
        }

        List<Role> roles = roleDAO.getAllRolesForEmployees();
        request.setAttribute("employee", employee);
        request.setAttribute("roles", roles);
        request.getRequestDispatcher("/WEB-INF/views/employee/employee-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null || !"Admin".equals(loggedUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        boolean isActive = "on".equals(request.getParameter("isActive"));
        String password = request.getParameter("password");

        User employee = new User();
        employee.setUserId(id);
        employee.setFullName(fullName);
        employee.setPhoneNumber(phoneNumber);
        employee.setRoleId(roleId);
        employee.setActive(isActive);
        
        if (password != null && !password.trim().isEmpty()) {
            employee.setPasswordHash(PasswordUtil.hashPassword(password));
        }

        boolean success = userDAO.updateEmployee(employee);

        if (success) {
            session.setAttribute("successMessage", "Cập nhật nhân viên thành công.");
        } else {
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật nhân viên.");
        }
        response.sendRedirect(request.getContextPath() + "/employees");
    }
}
