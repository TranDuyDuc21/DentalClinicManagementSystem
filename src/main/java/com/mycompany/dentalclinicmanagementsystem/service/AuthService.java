package com.mycompany.dentalclinicmanagementsystem.service;

import com.mycompany.dentalclinicmanagementsystem.dao.UserDAO;
import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.util.PasswordUtil;
import org.mindrot.jbcrypt.BCrypt;

public class AuthService {

    private UserDAO userDAO;

    public AuthService() {
        this.userDAO = new UserDAO();
    }

    public User login(String identifier, String password) throws Exception {
        if (identifier == null || identifier.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            throw new Exception("Tên đăng nhập hoặc mật khẩu không được để trống.");
        }

        User user = userDAO.getUserByUsernameOrEmail(identifier);

        if (user != null && PasswordUtil.checkPassword(password, user.getPasswordHash())) {
            return user;
        } else {
            throw new Exception("Tên đăng nhập/email hoặc mật khẩu không đúng.");
        }
    }

    public void register(User user, String password, String confirmPassword) throws Exception {
        // 1. Server-side Validation
        if (user.getFullName() == null || user.getFullName().trim().isEmpty() ||
            user.getUsername() == null || user.getUsername().trim().isEmpty() ||
            user.getEmail() == null || user.getEmail().trim().isEmpty() ||
            user.getPhoneNumber() == null || user.getPhoneNumber().trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            throw new Exception("Vui lòng điền đầy đủ các trường bắt buộc.");
        }

        if (!password.equals(confirmPassword)) {
            throw new Exception("Mật khẩu xác nhận không khớp.");
        }

        if (password.length() < 6) {
            throw new Exception("Mật khẩu phải có ít nhất 6 ký tự.");
        }

        if (!user.getEmail().matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            throw new Exception("Định dạng email không hợp lệ.");
        }

        // 2. Check for duplicates in Database
        if (userDAO.isUsernameExists(user.getUsername())) {
            throw new Exception("Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.");
        }

        if (userDAO.isEmailExists(user.getEmail())) {
            throw new Exception("Email này đã được sử dụng. Vui lòng chọn email khác.");
        }

        // 3. Hash password and save to Database
        String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt(10));
        user.setPasswordHash(passwordHash);

        boolean isSuccess = userDAO.registerUser(user);
        if (!isSuccess) {
            throw new Exception("Đã xảy ra lỗi hệ thống khi đăng ký. Vui lòng thử lại sau.");
        }
    }

    public String getRedirectUrl(User user) {
        if ("Customer".equals(user.getRoleName())) {
            return "/home";
        } else {
            return "/dashboard";
        }
    }
}
