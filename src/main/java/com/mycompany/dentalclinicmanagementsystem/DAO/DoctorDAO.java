package com.mycompany.dentalclinicmanagementsystem.dao;

import com.mycompany.dentalclinicmanagementsystem.model.Doctor;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO {

    public Integer getDoctorIdByUserId(int userId) {
        String sql = "SELECT doctor_id FROM doctors WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("doctor_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting doctorId: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<Doctor> getAllActiveDoctors() {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT d.doctor_id, d.user_id, d.specialty, d.license_no, " +
                     "u.full_name, u.email, u.phone_number, u.profile_picture " +
                     "FROM doctors d " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "WHERE u.is_active = TRUE";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Doctor doc = new Doctor();
                doc.setDoctorId(rs.getInt("doctor_id"));
                doc.setUserId(rs.getInt("user_id"));
                doc.setSpecialty(rs.getString("specialty"));
                doc.setLicenseNo(rs.getString("license_no"));
                doc.setFullName(rs.getString("full_name"));
                doc.setEmail(rs.getString("email"));
                doc.setPhoneNumber(rs.getString("phone_number"));
                doc.setProfilePicture(rs.getString("profile_picture"));
                doctors.add(doc);
            }

        } catch (SQLException e) {
            System.err.println("Error fetching active doctors: " + e.getMessage());
            e.printStackTrace();
        }
        return doctors;
    }

    public Doctor getDoctorById(int doctorId) {
        String sql = "SELECT d.doctor_id, d.user_id, d.specialty, d.license_no, " +
                     "u.full_name, u.email, u.phone_number, u.profile_picture " +
                     "FROM doctors d " +
                     "JOIN users u ON d.user_id = u.user_id " +
                     "WHERE d.doctor_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Doctor doc = new Doctor();
                    doc.setDoctorId(rs.getInt("doctor_id"));
                    doc.setUserId(rs.getInt("user_id"));
                    doc.setSpecialty(rs.getString("specialty"));
                    doc.setLicenseNo(rs.getString("license_no"));
                    doc.setFullName(rs.getString("full_name"));
                    doc.setEmail(rs.getString("email"));
                    doc.setPhoneNumber(rs.getString("phone_number"));
                    doc.setProfilePicture(rs.getString("profile_picture"));
                    return doc;
                }
            }

        } catch (SQLException e) {
            System.err.println("Error fetching doctor by id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
