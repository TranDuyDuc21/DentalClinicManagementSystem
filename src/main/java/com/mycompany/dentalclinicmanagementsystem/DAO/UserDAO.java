package com.mycompany.dentalclinicmanagementsystem.dao;

import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.DAO.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public User getUserByUsernameOrEmail(String identifier) {
        User user = null;
        String sql = "SELECT u.*, r.role_name FROM users u " +
                     "JOIN roles r ON u.role_id = r.role_id " +
                     "WHERE (u.username = ? OR u.email = ?) AND u.is_active = TRUE";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, identifier);
            ps.setString(2, identifier);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setRoleId(rs.getInt("role_id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setFullName(rs.getString("full_name"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setDateOfBirth(rs.getDate("date_of_birth"));
                    user.setGender(rs.getString("gender"));
                    user.setProfilePicture(rs.getString("profile_picture"));
                    user.setActive(rs.getBoolean("is_active"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setUpdatedAt(rs.getTimestamp("updated_at"));
                    user.setRoleName(rs.getString("role_name"));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error fetching user by username/email: " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }
}
