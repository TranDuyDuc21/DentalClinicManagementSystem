package com.mycompany.dentalclinicmanagementsystem.dao;

import com.mycompany.dentalclinicmanagementsystem.model.Patient;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class PatientDAO {

    public String generatePatientCode() {
        String year = String.valueOf(java.time.Year.now().getValue());
        String codePrefix = "PT-" + year + "-";
        String sql = "SELECT patient_code FROM patients WHERE patient_code LIKE ? ORDER BY patient_code DESC LIMIT 1";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, codePrefix + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String lastCode = rs.getString("patient_code");
                    String sequenceStr = lastCode.substring(lastCode.lastIndexOf("-") + 1);
                    int sequence = Integer.parseInt(sequenceStr);
                    return codePrefix + String.format("%04d", sequence + 1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error generating patient code: " + e.getMessage());
            e.printStackTrace();
        }
        return codePrefix + "0001";
    }

    public boolean createPatient(Patient patient) {
        String sql = "INSERT INTO patients (patient_code, full_name, date_of_birth, gender, phone_number, email, address, medical_history, drug_allergies) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, patient.getPatientCode());
            ps.setString(2, patient.getFullName());
            ps.setDate(3, patient.getDateOfBirth());
            ps.setString(4, patient.getGender());
            ps.setString(5, patient.getPhoneNumber());
            ps.setString(6, patient.getEmail());
            ps.setString(7, patient.getAddress());
            ps.setString(8, patient.getMedicalHistory());
            ps.setString(9, patient.getDrugAllergies());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        patient.setPatientId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error creating patient: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public java.util.List<Patient> getAllPatients(String search, String gender) {
        java.util.List<Patient> patients = new java.util.ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM patients WHERE 1=1 ");
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (full_name LIKE ? OR patient_code LIKE ? OR phone_number LIKE ?) ");
        }
        if (gender != null && !gender.trim().isEmpty()) {
            sql.append("AND gender = ? ");
        }
        
        sql.append("ORDER BY created_at DESC");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            int paramIndex = 1;
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            if (gender != null && !gender.trim().isEmpty()) {
                ps.setString(paramIndex++, gender.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Patient p = new Patient();
                    p.setPatientId(rs.getInt("patient_id"));
                    p.setPatientCode(rs.getString("patient_code"));
                    p.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
                    p.setFullName(rs.getString("full_name"));
                    p.setDateOfBirth(rs.getDate("date_of_birth"));
                    p.setGender(rs.getString("gender"));
                    p.setPhoneNumber(rs.getString("phone_number"));
                    p.setEmail(rs.getString("email"));
                    p.setAddress(rs.getString("address"));
                    p.setMedicalHistory(rs.getString("medical_history"));
                    p.setDrugAllergies(rs.getString("drug_allergies"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    patients.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }

    public Patient getPatientByPhone(String phone) {
        String sql = "SELECT * FROM patients WHERE phone_number = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Patient p = new Patient();
                    p.setPatientId(rs.getInt("patient_id"));
                    p.setPatientCode(rs.getString("patient_code"));
                    p.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
                    p.setFullName(rs.getString("full_name"));
                    p.setDateOfBirth(rs.getDate("date_of_birth"));
                    p.setGender(rs.getString("gender"));
                    p.setPhoneNumber(rs.getString("phone_number"));
                    p.setEmail(rs.getString("email"));
                    p.setAddress(rs.getString("address"));
                    p.setMedicalHistory(rs.getString("medical_history"));
                    p.setDrugAllergies(rs.getString("drug_allergies"));
                    p.setCreatedAt(rs.getTimestamp("created_at"));
                    return p;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting patient by phone: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePatient(Patient patient) {
        String sql = "UPDATE patients SET full_name = ?, date_of_birth = ?, gender = ?, phone_number = ?, email = ?, address = ?, medical_history = ?, drug_allergies = ? WHERE patient_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, patient.getFullName());
            ps.setDate(2, patient.getDateOfBirth());
            ps.setString(3, patient.getGender());
            ps.setString(4, patient.getPhoneNumber());
            ps.setString(5, patient.getEmail());
            ps.setString(6, patient.getAddress());
            ps.setString(7, patient.getMedicalHistory());
            ps.setString(8, patient.getDrugAllergies());
            ps.setInt(9, patient.getPatientId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating patient: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
