package com.mycompany.dentalclinicmanagementsystem.service;

import com.mycompany.dentalclinicmanagementsystem.dao.UserDAO;
import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.util.PasswordUtil;

public class UserService {
    private final UserDAO userDAO = new UserDAO();

    public enum ProfileStatus {
        SUCCESS, ERROR_VALIDATION, ERROR_SYSTEM
    }

    public static class ProfileResult {
        public ProfileStatus status;
        public String message;

        public ProfileResult(ProfileStatus status, String message) {
            this.status = status;
            this.message = message;
        }
    }

    public ProfileResult processUpdateProfile(User user) {
        if (user.getFullName() == null || user.getFullName().trim().isEmpty() ||
            user.getPhoneNumber() == null || user.getPhoneNumber().trim().isEmpty()) {
            return new ProfileResult(ProfileStatus.ERROR_VALIDATION, "Họ tên và số điện thoại không được để trống.");
        }

        // Validate phone number format (basic)
        if (!user.getPhoneNumber().matches("^[0-9]{10,11}$")) {
            return new ProfileResult(ProfileStatus.ERROR_VALIDATION, "Số điện thoại không hợp lệ (10-11 chữ số).");
        }

        // Check if phone number is used by someone else
        if (userDAO.isFieldExists("phone_number", user.getPhoneNumber(), user.getUserId())) {
            return new ProfileResult(ProfileStatus.ERROR_VALIDATION, "Số điện thoại này đã được sử dụng bởi người khác.");
        }

        boolean updated = userDAO.updateProfile(user);
        if (updated) {
            return new ProfileResult(ProfileStatus.SUCCESS, "Cập nhật thông tin thành công.");
        }
        
        return new ProfileResult(ProfileStatus.ERROR_SYSTEM, "Đã xảy ra lỗi khi cập nhật thông tin. Vui lòng thử lại.");
    }

    public ProfileResult processUpdateAvatar(int userId, String avatarPath) {
        if (avatarPath == null || avatarPath.trim().isEmpty()) {
            return new ProfileResult(ProfileStatus.ERROR_VALIDATION, "Đường dẫn ảnh không hợp lệ.");
        }

        boolean updated = userDAO.updateAvatar(userId, avatarPath);
        if (updated) {
            return new ProfileResult(ProfileStatus.SUCCESS, "Cập nhật ảnh đại diện thành công.");
        }
        
        return new ProfileResult(ProfileStatus.ERROR_SYSTEM, "Đã xảy ra lỗi khi cập nhật ảnh đại diện.");
    }

    public ProfileResult processChangePassword(int userId, String oldPassword, String newPassword, String confirmPassword) {
        if (oldPassword == null || newPassword == null || confirmPassword == null ||
            oldPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            return new ProfileResult(ProfileStatus.ERROR_VALIDATION, "Vui lòng điền đầy đủ các trường mật khẩu.");
        }

        if (!newPassword.equals(confirmPassword)) {
            return new ProfileResult(ProfileStatus.ERROR_VALIDATION, "Mật khẩu xác nhận không khớp.");
        }

        if (newPassword.length() < 6) {
            return new ProfileResult(ProfileStatus.ERROR_VALIDATION, "Mật khẩu mới phải chứa ít nhất 6 ký tự.");
        }

        // Lấy thông tin user hiện tại để lấy mã băm mật khẩu cũ
        User currentUser = userDAO.getUserById(userId);
        if (currentUser == null) {
            return new ProfileResult(ProfileStatus.ERROR_SYSTEM, "Không tìm thấy thông tin người dùng.");
        }

        // Kiểm tra mật khẩu cũ
        if (!PasswordUtil.checkPassword(oldPassword, currentUser.getPasswordHash())) {
            return new ProfileResult(ProfileStatus.ERROR_VALIDATION, "Mật khẩu hiện tại không chính xác.");
        }

        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        boolean updated = userDAO.updatePassword(userId, hashedPassword);
        if (updated) {
            return new ProfileResult(ProfileStatus.SUCCESS, "Đổi mật khẩu thành công.");
        }

        return new ProfileResult(ProfileStatus.ERROR_SYSTEM, "Đã xảy ra lỗi khi đổi mật khẩu.");
    }
}
