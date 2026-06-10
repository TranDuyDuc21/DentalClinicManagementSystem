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

@WebServlet("/employees/update")
public class EmployeeUpdateServlet extends HttpServlet {

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

        int id = Integer.parseInt(request.getParameter("id"));
        User employee = employeeService.getEmployeeById(id);
        
        if (employee == null) {
            session.setAttribute("errorMessage", "Không tìm thấy nhân viên.");
            response.sendRedirect(request.getContextPath() + "/employees");
            return;
        }

        List<Role> roles = employeeService.getAllRolesForEmployees();
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

        boolean success = employeeService.updateEmployee(id, fullName, phoneNumber, roleId, isActive, password);

        if (success) {
            session.setAttribute("successMessage", "Cập nhật nhân viên thành công.");
        } else {
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật nhân viên.");
        }
        response.sendRedirect(request.getContextPath() + "/employees");
    }
}
