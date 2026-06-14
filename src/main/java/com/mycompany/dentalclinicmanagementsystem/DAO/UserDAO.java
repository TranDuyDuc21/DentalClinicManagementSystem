package com.mycompany.dentalclinicmanagementsystem.dao;

import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.dao.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

    public boolean isUsernameExists(String username) {
        String sql = "SELECT 1 FROM users WHERE username = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error checking username existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailExists(String email) {
        String sql = "SELECT 1 FROM users WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error checking email existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean isFieldExists(String field, String value, Integer excludeUserId) {
        if (!field.equals("username") && !field.equals("email") && !field.equals("phone_number")) {
            return false;
        }
        
        StringBuilder sql = new StringBuilder("SELECT 1 FROM users WHERE ").append(field).append(" = ?");
        if (excludeUserId != null) {
            sql.append(" AND user_id != ?");
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setString(1, value);
            if (excludeUserId != null) {
                ps.setInt(2, excludeUserId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Error checking field existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (role_id, username, email, password_hash, full_name, phone_number, is_active) " +
                     "VALUES ((SELECT role_id FROM roles WHERE role_name = 'Customer'), ?, ?, ?, ?, ?, TRUE)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getPhoneNumber());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error registering user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAllEmployees() {
        List<User> employees = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name FROM users u JOIN roles r ON u.role_id = r.role_id WHERE r.role_name != 'Customer' ORDER BY u.created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                employees.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return employees;
    }

    public List<User> getEmployees(String searchKeyword, Integer roleId, Boolean status, int offset, int limit) {
        List<User> employees = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT u.*, r.role_name FROM users u JOIN roles r ON u.role_id = r.role_id WHERE r.role_name != 'Customer'");
        
        List<Object> parameters = new ArrayList<>();
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR u.phone_number LIKE ? OR u.email LIKE ? OR u.username LIKE ?)");
            String keyword = "%" + searchKeyword.trim() + "%";
            parameters.add(keyword);
            parameters.add(keyword);
            parameters.add(keyword);
            parameters.add(keyword);
        }
        
        if (roleId != null) {
            sql.append(" AND u.role_id = ?");
            parameters.add(roleId);
        }
        
        if (status != null) {
            sql.append(" AND u.is_active = ?");
            parameters.add(status);
        }
        
        sql.append(" ORDER BY u.created_at DESC");
        sql.append(" LIMIT ? OFFSET ?");
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }
            ps.setInt(parameters.size() + 1, limit);
            ps.setInt(parameters.size() + 2, offset);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    employees.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return employees;
    }

    public int getTotalEmployees(String searchKeyword, Integer roleId, Boolean status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users u JOIN roles r ON u.role_id = r.role_id WHERE r.role_name != 'Customer'");
        List<Object> parameters = new ArrayList<>();
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR u.phone_number LIKE ? OR u.email LIKE ? OR u.username LIKE ?)");
            String keyword = "%" + searchKeyword.trim() + "%";
            parameters.add(keyword);
            parameters.add(keyword);
            parameters.add(keyword);
            parameters.add(keyword);
        }
        
        if (roleId != null) {
            sql.append(" AND u.role_id = ?");
            parameters.add(roleId);
        }
        
        if (status != null) {
            sql.append(" AND u.is_active = ?");
            parameters.add(status);
        }
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public User getEmployeeById(int id) {
        String sql = "SELECT u.*, r.role_name FROM users u JOIN roles r ON u.role_id = r.role_id WHERE u.user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createEmployee(User user) {
        String sql = "INSERT INTO users (role_id, username, email, password_hash, full_name, phone_number, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean success = false;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, user.getRoleId());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPasswordHash());
            ps.setString(5, user.getFullName());
            ps.setString(6, user.getPhoneNumber());
            ps.setBoolean(7, user.isActive());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                success = true;
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int userId = rs.getInt(1);
                    // Check if role is Doctor, insert into doctors table
                    if (isRoleDoctor(conn, user.getRoleId())) {
                        try (PreparedStatement psDoc = conn.prepareStatement("INSERT INTO doctors (user_id) VALUES (?)")) {
                            psDoc.setInt(1, userId);
                            psDoc.executeUpdate();
                        }
                    }
                }
            }
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (ps != null) try { ps.close(); } catch (SQLException e) {}
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) {}
            }
        }
        return success;
    }

    public boolean updateEmployee(User user) {
        String sql = "UPDATE users SET role_id=?, full_name=?, phone_number=?, is_active=?";
        boolean updatePassword = (user.getPasswordHash() != null && !user.getPasswordHash().isEmpty());
        if (updatePassword) {
            sql += ", password_hash=?";
        }
        sql += " WHERE user_id=?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user.getRoleId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getPhoneNumber());
            ps.setBoolean(4, user.isActive());
            
            int paramIndex = 5;
            if (updatePassword) {
                ps.setString(paramIndex++, user.getPasswordHash());
            }
            ps.setInt(paramIndex, user.getUserId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleEmployeeStatus(int id, boolean isActive) {
        String sql = "UPDATE users SET is_active=? WHERE user_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean isRoleDoctor(Connection conn, int roleId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("SELECT role_name FROM roles WHERE role_id=?")) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && "Doctor".equals(rs.getString("role_name"))) {
                    return true;
                }
            }
        }
        return false;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
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
        return user;
    }

    public boolean updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE users SET password_hash = ? WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error updating password: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
