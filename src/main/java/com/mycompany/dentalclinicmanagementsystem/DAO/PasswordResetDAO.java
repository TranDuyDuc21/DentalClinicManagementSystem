package com.mycompany.dentalclinicmanagementsystem.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PasswordResetDAO {

    public boolean createToken(int userId, String token, int expiryMinutes) {
        String sql = "INSERT INTO password_reset_tokens (user_id, token, expires_at) " +
                     "VALUES (?, ?, DATE_ADD(NOW(), INTERVAL ? MINUTE))";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setInt(3, expiryMinutes);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error creating password reset token: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public Integer verifyTokenAndGetUserId(String email, String token) {
        String sql = "SELECT t.user_id FROM password_reset_tokens t " +
                     "JOIN users u ON t.user_id = u.user_id " +
                     "WHERE u.email = ? AND t.token = ? AND t.used = FALSE AND t.expires_at > NOW()";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error verifying token: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean markTokenAsUsed(String token) {
        String sql = "UPDATE password_reset_tokens SET used = TRUE WHERE token = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error marking token as used: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
