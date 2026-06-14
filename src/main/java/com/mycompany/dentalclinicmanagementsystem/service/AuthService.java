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


    private final com.mycompany.dentalclinicmanagementsystem.dao.PasswordResetDAO passwordResetDAO = 
        new com.mycompany.dentalclinicmanagementsystem.dao.PasswordResetDAO();

    public enum ResetStatus {
        SUCCESS, ERROR_VALIDATION, ERROR_NOT_FOUND, ERROR_SYSTEM, ERROR_MAX_ATTEMPTS
    }

    public static class ResetResult {
        public ResetStatus status;
        public String message;
        public Integer dataId; 
        
        public ResetResult(ResetStatus status, String message) {
            this.status = status;
            this.message = message;
        }
        
        public ResetResult(ResetStatus status, String message, Integer dataId) {
            this.status = status;
            this.message = message;
            this.dataId = dataId;
        }
    }

    public ResetResult processForgotPassword(String email) {
        if (email == null || email.trim().isEmpty()) {
            return new ResetResult(ResetStatus.ERROR_VALIDATION, "Vui lòng nhập địa chỉ email.");
        }

        User user = userDAO.getUserByUsernameOrEmail(email.trim());
        if (user == null) {
            return new ResetResult(ResetStatus.ERROR_NOT_FOUND, "Không tìm thấy tài khoản với email này.");
        }

        String otp = String.format("%06d", new java.util.Random().nextInt(999999));
        
        boolean tokenCreated = passwordResetDAO.createToken(user.getUserId(), otp, 15);
        if (!tokenCreated) {
            return new ResetResult(ResetStatus.ERROR_SYSTEM, "Đã xảy ra lỗi khi tạo mã OTP. Vui lòng thử lại sau.");
        }

        boolean emailSent = EmailService.sendPasswordResetOtp(user.getEmail(), otp);
        if (!emailSent) {
            return new ResetResult(ResetStatus.ERROR_SYSTEM, "Không thể gửi email OTP. Vui lòng kiểm tra lại cấu hình hệ thống.");
        }

        return new ResetResult(ResetStatus.SUCCESS, user.getEmail());
    }

    public ResetResult processVerifyOtp(String email, String otp, int attempts) {
        if (attempts >= 5) {
            return new ResetResult(ResetStatus.ERROR_MAX_ATTEMPTS, "Bạn đã nhập sai mã quá nhiều lần. Vui lòng yêu cầu gửi lại mã mới.");
        }

        if (otp == null || otp.trim().isEmpty()) {
            return new ResetResult(ResetStatus.ERROR_VALIDATION, "Vui lòng nhập mã OTP.");
        }

        Integer userId = passwordResetDAO.verifyTokenAndGetUserId(email, otp.trim());
        if (userId == null) {
            attempts++;
            if (attempts >= 5) {
                return new ResetResult(ResetStatus.ERROR_MAX_ATTEMPTS, "Bạn đã nhập sai mã quá 5 lần. Hệ thống đã hủy yêu cầu của bạn.", attempts);
            }
            return new ResetResult(ResetStatus.ERROR_VALIDATION, "Mã OTP không chính xác hoặc đã hết hạn. Bạn còn " + (5 - attempts) + " lần thử.", attempts);
        }

        return new ResetResult(ResetStatus.SUCCESS, "Xác thực thành công", userId);
    }

    public ResetResult processResetPassword(Integer userId, String verifiedOtp, String newPassword, String confirmPassword) {
        if (newPassword == null || confirmPassword == null || 
            newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            return new ResetResult(ResetStatus.ERROR_VALIDATION, "Vui lòng điền đầy đủ các trường.");
        }

        if (!newPassword.equals(confirmPassword)) {
            return new ResetResult(ResetStatus.ERROR_VALIDATION, "Mật khẩu nhập lại không khớp.");
        }

        if (newPassword.length() < 6) {
            return new ResetResult(ResetStatus.ERROR_VALIDATION, "Mật khẩu phải chứa ít nhất 6 ký tự.");
        }

        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        boolean updated = userDAO.updatePassword(userId, hashedPassword);
        
        if (updated) {
            passwordResetDAO.markTokenAsUsed(verifiedOtp);
            return new ResetResult(ResetStatus.SUCCESS, "Mật khẩu của bạn đã được đặt lại thành công. Vui lòng đăng nhập.");
        }
        
        return new ResetResult(ResetStatus.ERROR_SYSTEM, "Đã xảy ra lỗi khi cập nhật mật khẩu. Vui lòng thử lại.");
    }
}
