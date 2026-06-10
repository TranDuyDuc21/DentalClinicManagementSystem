package com.mycompany.dentalclinicmanagementsystem.service;

import com.mycompany.dentalclinicmanagementsystem.dao.RoleDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.UserDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Role;
import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.util.PasswordUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EmployeeService {

    private final UserDAO userDAO;
    private final RoleDAO roleDAO;

    public EmployeeService() {
        this.userDAO = new UserDAO();
        this.roleDAO = new RoleDAO();
    }

    public Map<String, Object> getEmployeesList(String search, Integer roleId, Boolean status, int page, int limit) {
        if (page < 1) page = 1;
        int offset = (page - 1) * limit;

        List<User> employees = userDAO.getEmployees(search, roleId, status, offset, limit);
        int totalEmployees = userDAO.getTotalEmployees(search, roleId, status);
        int totalPages = (int) Math.ceil((double) totalEmployees / limit);
        List<Role> roles = roleDAO.getAllRolesForEmployees();

        Map<String, Object> result = new HashMap<>();
        result.put("employees", employees);
        result.put("roles", roles);
        result.put("pageNumber", page);
        result.put("totalPages", totalPages);

        return result;
    }

    public List<Role> getAllRolesForEmployees() {
        return roleDAO.getAllRolesForEmployees();
    }

    public String createEmployee(String username, String email, String password, String fullName, String phoneNumber, int roleId, boolean isActive) {
        if (userDAO.isUsernameExists(username)) {
            return "Tên đăng nhập đã tồn tại.";
        }
        if (userDAO.isEmailExists(email)) {
            return "Email đã tồn tại.";
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
        return success ? "SUCCESS" : "Có lỗi xảy ra khi thêm nhân viên.";
    }

    public User getEmployeeById(int id) {
        return userDAO.getEmployeeById(id);
    }

    public boolean updateEmployee(int id, String fullName, String phoneNumber, int roleId, boolean isActive, String password) {
        User employee = new User();
        employee.setUserId(id);
        employee.setFullName(fullName);
        employee.setPhoneNumber(phoneNumber);
        employee.setRoleId(roleId);
        employee.setActive(isActive);
        
        if (password != null && !password.trim().isEmpty()) {
            employee.setPasswordHash(PasswordUtil.hashPassword(password));
        }

        return userDAO.updateEmployee(employee);
    }

    public boolean toggleEmployeeStatus(int id, boolean status) {
        return userDAO.toggleEmployeeStatus(id, status);
    }
}
