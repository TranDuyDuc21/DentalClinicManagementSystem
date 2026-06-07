package com.mycompany.dentalclinicmanagementsystem.dao;

import com.mycompany.dentalclinicmanagementsystem.model.Service;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public List<Service> getAllServices(String search, String status, int offset, int limit) {
        List<Service> services = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM services WHERE 1=1 ");

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND service_name LIKE ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND is_active = ? ");
        }
        
        sql.append("ORDER BY service_name ASC LIMIT ? OFFSET ?");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + search.trim() + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setBoolean(paramIndex++, Boolean.parseBoolean(status));
            }
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex++, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    services.add(mapResultSetToService(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return services;
    }

    public int getTotalServices(String search, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM services WHERE 1=1 ");
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND service_name LIKE ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND is_active = ? ");
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + search.trim() + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setBoolean(paramIndex++, Boolean.parseBoolean(status));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Service getServiceById(int id) {
        String sql = "SELECT * FROM services WHERE service_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToService(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createService(Service service) {
        String sql = "INSERT INTO services (service_name, estimated_minutes, listed_price, description, is_active) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, service.getServiceName());
            if (service.getEstimatedMinutes() != null) {
                ps.setInt(2, service.getEstimatedMinutes());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setBigDecimal(3, service.getListedPrice());
            ps.setString(4, service.getDescription());
            ps.setBoolean(5, service.isActive());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateService(Service service) {
        String sql = "UPDATE services SET service_name=?, estimated_minutes=?, listed_price=?, description=?, is_active=? WHERE service_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, service.getServiceName());
            if (service.getEstimatedMinutes() != null) {
                ps.setInt(2, service.getEstimatedMinutes());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setBigDecimal(3, service.getListedPrice());
            ps.setString(4, service.getDescription());
            ps.setBoolean(5, service.isActive());
            ps.setInt(6, service.getServiceId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleServiceStatus(int id, boolean newStatus) {
        String sql = "UPDATE services SET is_active = ? WHERE service_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setBoolean(1, newStatus);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Service mapResultSetToService(ResultSet rs) throws SQLException {
        Service s = new Service();
        s.setServiceId(rs.getInt("service_id"));
        s.setServiceName(rs.getString("service_name"));
        s.setEstimatedMinutes(rs.getObject("estimated_minutes") != null ? rs.getInt("estimated_minutes") : null);
        s.setListedPrice(rs.getBigDecimal("listed_price"));
        s.setDescription(rs.getString("description"));
        s.setActive(rs.getBoolean("is_active"));
        return s;
    }
}
