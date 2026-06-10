package com.mycompany.dentalclinicmanagementsystem.controller.employee;

import com.mycompany.dentalclinicmanagementsystem.model.Role;
import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.service.EmployeeService;

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

    private EmployeeService employeeService;

    @Override
    public void init() throws ServletException {
        employeeService = new EmployeeService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null || !"Admin".equals(loggedUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Role> roles = employeeService.getAllRolesForEmployees();
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

        String result = employeeService.createEmployee(username, email, password, fullName, phoneNumber, roleId, isActive);

        if ("SUCCESS".equals(result)) {
            session.setAttribute("successMessage", "Thêm nhân viên thành công.");
            response.sendRedirect(request.getContextPath() + "/employees");
        } else {
            session.setAttribute("errorMessage", result);
            response.sendRedirect(request.getContextPath() + "/employees/create");
        }
    }
}
