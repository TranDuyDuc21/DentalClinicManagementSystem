package com.mycompany.dentalclinicmanagementsystem.dao;

import com.mycompany.dentalclinicmanagementsystem.model.EmployeeSchedule;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EmployeeScheduleDAO {

    public List<EmployeeSchedule> getAllSchedules(Integer userId, Date startDate, Date endDate) {
        List<EmployeeSchedule> list = new ArrayList<>();
        String sql = "SELECT es.*, u.full_name as employeeName, r.role_name " +
                     "FROM employee_schedules es " +
                     "JOIN users u ON es.user_id = u.user_id " +
                     "JOIN roles r ON u.role_id = r.role_id " +
                     "WHERE 1=1 ";

        if (userId != null) {
            sql += " AND es.user_id = ? ";
        }
        if (startDate != null) {
            sql += " AND es.work_date >= ? ";
        }
        if (endDate != null) {
            sql += " AND es.work_date <= ? ";
        }
        
        sql += " ORDER BY es.work_date ASC, es.start_time ASC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            int paramIndex = 1;
            if (userId != null) ps.setInt(paramIndex++, userId);
            if (startDate != null) ps.setDate(paramIndex++, startDate);
            if (endDate != null) ps.setDate(paramIndex++, endDate);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToSchedule(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public EmployeeSchedule getScheduleByEmployeeAndDateAndShift(int userId, Date workDate, String shift) {
        String sql = "SELECT es.*, u.full_name as employeeName, r.role_name " +
                     "FROM employee_schedules es " +
                     "JOIN users u ON es.user_id = u.user_id " +
                     "JOIN roles r ON u.role_id = r.role_id " +
                     "WHERE es.user_id = ? AND es.work_date = ? AND es.shift = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setDate(2, workDate);
            ps.setString(3, shift);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSchedule(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addSchedule(EmployeeSchedule es) {
        String sql = "INSERT INTO employee_schedules (user_id, work_date, shift, start_time, end_time, max_patients, is_day_off) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, es.getUserId());
            ps.setDate(2, es.getWorkDate());
            ps.setString(3, es.getShift());
            ps.setTime(4, es.getStartTime());
            ps.setTime(5, es.getEndTime());
            ps.setInt(6, es.getMaxPatients());
            ps.setBoolean(7, es.isDayOff());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateSchedule(EmployeeSchedule es) {
        String sql = "UPDATE employee_schedules SET start_time=?, end_time=?, max_patients=?, is_day_off=? " +
                     "WHERE schedule_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTime(1, es.getStartTime());
            ps.setTime(2, es.getEndTime());
            ps.setInt(3, es.getMaxPatients());
            ps.setBoolean(4, es.isDayOff());
            ps.setInt(5, es.getScheduleId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteSchedule(int scheduleId) {
        String sql = "DELETE FROM employee_schedules WHERE schedule_id=?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private EmployeeSchedule mapResultSetToSchedule(ResultSet rs) throws SQLException {
        EmployeeSchedule es = new EmployeeSchedule();
        es.setScheduleId(rs.getInt("schedule_id"));
        es.setUserId(rs.getInt("user_id"));
        es.setWorkDate(rs.getDate("work_date"));
        es.setShift(rs.getString("shift"));
        es.setStartTime(rs.getTime("start_time"));
        es.setEndTime(rs.getTime("end_time"));
        es.setMaxPatients(rs.getInt("max_patients"));
        es.setDayOff(rs.getBoolean("is_day_off"));
        es.setEmployeeName(rs.getString("employeeName"));
        es.setRoleName(rs.getString("role_name"));
        return es;
    }
}
