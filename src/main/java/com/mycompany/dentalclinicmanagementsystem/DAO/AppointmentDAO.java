package com.mycompany.dentalclinicmanagementsystem.dao;

import com.mycompany.dentalclinicmanagementsystem.model.Appointment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO extends DBContext {

    public List<Appointment> getAllAppointments(String status, String searchStr, int offset, int limit) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, " +
                     "p.full_name as patientName, p.phone_number as patientPhone, " +
                     "u.full_name as doctorName, " +
                     "s.service_name as serviceName, " +
                     "v.visit_id as visitId, " +
                     "inv.invoice_id as invoiceId, inv.status as invoiceStatus " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.patient_id " +
                     "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "LEFT JOIN services s ON a.service_id = s.service_id " +
                     "LEFT JOIN visits v ON a.appointment_id = v.appointment_id " +
                     "LEFT JOIN invoices inv ON v.visit_id = inv.visit_id AND inv.status != 'Cancelled' " +
                     "WHERE 1=1 ";

        if (status != null && !status.isEmpty()) {
            sql += " AND a.status = ? ";
        }

        if (searchStr != null && !searchStr.isEmpty()) {
            sql += " AND (p.full_name LIKE ? OR p.phone_number LIKE ? OR u.full_name LIKE ?) ";
        }

        sql += " ORDER BY a.scheduled_datetime DESC ";
        sql += " LIMIT ? OFFSET ?";

        try (Connection connection = DBContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
             
            int paramIndex = 1;
            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            if (searchStr != null && !searchStr.isEmpty()) {
                String likeSearch = "%" + searchStr + "%";
                ps.setString(paramIndex++, likeSearch);
                ps.setString(paramIndex++, likeSearch);
                ps.setString(paramIndex++, likeSearch);
            }
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex++, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment a = new Appointment();
                    a.setAppointmentId(rs.getInt("appointment_id"));
                    a.setPatientId(rs.getInt("patient_id"));
                    a.setDoctorId(rs.getInt("doctor_id"));
                    a.setServiceId(rs.getObject("service_id") != null ? rs.getInt("service_id") : null);
                    a.setChairId(rs.getObject("chair_id") != null ? rs.getInt("chair_id") : null);
                    a.setScheduledDatetime(rs.getTimestamp("scheduled_datetime"));
                    a.setStatus(rs.getString("status"));
                    a.setBookingSource(rs.getString("booking_source"));
                    a.setQueueNumber(rs.getObject("queue_number") != null ? rs.getInt("queue_number") : null);
                    a.setCheckInTime(rs.getTimestamp("check_in_time"));
                    a.setExamStartTime(rs.getTimestamp("exam_start_time"));
                    a.setExamEndTime(rs.getTimestamp("exam_end_time"));
                    a.setCreatedBy(rs.getObject("created_by") != null ? rs.getInt("created_by") : null);
                    a.setCreatedAt(rs.getTimestamp("created_at"));
                    a.setUpdatedAt(rs.getTimestamp("updated_at"));

                    a.setPatientName(rs.getString("patientName"));
                    a.setPatientPhone(rs.getString("patientPhone"));
                    a.setDoctorName(rs.getString("doctorName"));
                    a.setServiceName(rs.getString("serviceName"));
                    a.setVisitId(rs.getObject("visitId") != null ? rs.getInt("visitId") : null);
                    a.setInvoiceId(rs.getObject("invoiceId") != null ? rs.getInt("invoiceId") : null);
                    a.setInvoiceStatus(rs.getString("invoiceStatus"));

                    list.add(a);
                }
            }
        } catch (SQLException e) {
            System.out.println("getAllAppointments error: " + e.getMessage());
        }
        return list;
    }

    public int getTotalAppointments(String status, String searchStr) {
        String sql = "SELECT COUNT(*) " +
                     "FROM appointments a " +
                     "JOIN patients p ON a.patient_id = p.patient_id " +
                     "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "WHERE 1=1 ";

        if (status != null && !status.isEmpty()) {
            sql += " AND a.status = ? ";
        }

        if (searchStr != null && !searchStr.isEmpty()) {
            sql += " AND (p.full_name LIKE ? OR p.phone_number LIKE ? OR u.full_name LIKE ?) ";
        }

        try (Connection connection = DBContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
             
            int paramIndex = 1;
            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            if (searchStr != null && !searchStr.isEmpty()) {
                String likeSearch = "%" + searchStr + "%";
                ps.setString(paramIndex++, likeSearch);
                ps.setString(paramIndex++, likeSearch);
                ps.setString(paramIndex++, likeSearch);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("getTotalAppointments error: " + e.getMessage());
        }
        return 0;
    }
}
