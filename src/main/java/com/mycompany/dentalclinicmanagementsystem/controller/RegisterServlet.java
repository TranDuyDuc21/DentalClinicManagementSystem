package com.mycompany.dentalclinicmanagementsystem.controller;

import com.mycompany.dentalclinicmanagementsystem.dao.UserDAO;
import com.mycompany.dentalclinicmanagementsystem.model.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to register.jsp
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get parameters
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Create a User object to pre-fill the form in case of error
        User user = new User();
        user.setFullName(fullName);
        user.setUsername(username);
        user.setEmail(email);
        user.setPhoneNumber(phoneNumber);

        // 2. Server-side Validation
        if (fullName == null || fullName.trim().isEmpty() ||
            username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phoneNumber == null || phoneNumber.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            forwardWithError(request, response, user, "Vui lòng điền đầy đủ các trường bắt buộc.");
            return;
        }

        if (!password.equals(confirmPassword)) {
            forwardWithError(request, response, user, "Mật khẩu xác nhận không khớp.");
            return;
        }

        if (password.length() < 6) {
            forwardWithError(request, response, user, "Mật khẩu phải có ít nhất 6 ký tự.");
            return;
        }

        if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            forwardWithError(request, response, user, "Định dạng email không hợp lệ.");
            return;
        }

        // 3. Check for duplicates in Database
        if (userDAO.isUsernameExists(username)) {
            forwardWithError(request, response, user, "Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.");
            return;
        }

        if (userDAO.isEmailExists(email)) {
            forwardWithError(request, response, user, "Email này đã được sử dụng. Vui lòng chọn email khác.");
            return;
        }

        // 4. Hash password and save to Database
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(10));
        user.setPasswordHash(passwordHash);

        boolean isSuccess = userDAO.registerUser(user);

        if (isSuccess) {
            request.getSession().setAttribute("successMessage", "Đăng ký thành công! Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            forwardWithError(request, response, user, "Đã xảy ra lỗi hệ thống khi đăng ký. Vui lòng thử lại sau.");
        }
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, User user, String errorMessage) 
            throws ServletException, IOException {
        request.setAttribute("user", user); // Retain form data
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }
}
