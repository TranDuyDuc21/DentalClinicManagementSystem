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

@WebServlet("/employees/create")
public class EmployeeCreateServlet extends HttpServlet {

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

        List<Role> roles = roleDAO.getAllRolesForEmployees();
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

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        boolean isActive = "on".equals(request.getParameter("isActive"));

        if (userDAO.isUsernameExists(username)) {
            session.setAttribute("errorMessage", "Tên đăng nhập đã tồn tại.");
            response.sendRedirect(request.getContextPath() + "/employees/create");
            return;
        }
        if (userDAO.isEmailExists(email)) {
            session.setAttribute("errorMessage", "Email đã tồn tại.");
            response.sendRedirect(request.getContextPath() + "/employees/create");
            return;
        }

        User employee = new User();
        employee.setUsername(username);
        employee.setEmail(email);
        employee.setPasswordHash(PasswordUtil.hashPassword(password));
        employee.setFullName(fullName);
        employee.setPhoneNumber(phoneNumber);
        employee.setRoleId(roleId);
        employee.setActive(isActive);

        boolean success = userDAO.createEmployee(employee);

        if (success) {
            session.setAttribute("successMessage", "Thêm nhân viên thành công.");
            response.sendRedirect(request.getContextPath() + "/employees");
        } else {
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi thêm nhân viên.");
            response.sendRedirect(request.getContextPath() + "/employees/create");
        }
    }
}
