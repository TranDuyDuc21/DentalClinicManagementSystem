package com.mycompany.dentalclinicmanagementsystem.dao;

import com.mycompany.dentalclinicmanagementsystem.model.PrescriptionItem;
import com.mycompany.dentalclinicmanagementsystem.model.TreatmentPlan;
import com.mycompany.dentalclinicmanagementsystem.model.TreatmentStep;
import com.mycompany.dentalclinicmanagementsystem.model.Visit;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MedicalRecordDAO {

    public Visit getVisitById(int visitId) {
        String sql = "SELECT v.*, d.full_name as doctorName, p.full_name as patientName, " +
                     "(SELECT s.service_name FROM appointments a JOIN services s ON a.service_id = s.service_id WHERE a.appointment_id = v.appointment_id) as serviceName " +
                     "FROM visits v " +
                     "JOIN doctors doc ON v.doctor_id = doc.doctor_id " +
                     "JOIN users d ON doc.user_id = d.user_id " +
                     "JOIN patients pat ON v.patient_id = pat.patient_id " +
                     "JOIN users p ON pat.user_id = p.user_id " +
                     "WHERE v.visit_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, visitId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Visit visit = new Visit();
                    visit.setVisitId(rs.getInt("visit_id"));
                    visit.setAppointmentId(rs.getInt("appointment_id"));
                    visit.setPatientId(rs.getInt("patient_id"));
                    visit.setDoctorId(rs.getInt("doctor_id"));
                    visit.setVisitDate(rs.getTimestamp("visit_date"));
                    visit.setSymptoms(rs.getString("symptoms"));
                    visit.setDiagnosis(rs.getString("diagnosis"));
                    visit.setClinicalNotes(rs.getString("clinical_notes"));
                    visit.setIsConcluded(rs.getBoolean("is_concluded"));
                    
                    visit.setDoctorName(rs.getString("doctorName"));
                    visit.setPatientName(rs.getString("patientName"));
                    visit.setServiceName(rs.getString("serviceName"));
                    return visit;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<PrescriptionItem> getPrescriptionItemsByVisitId(int visitId) {
        List<PrescriptionItem> list = new ArrayList<>();
        String sql = "SELECT pi.*, COALESCE(m.name, pi.medication_name) as medName " +
                     "FROM prescriptions p " +
                     "JOIN prescription_items pi ON p.prescription_id = pi.prescription_id " +
                     "LEFT JOIN medications m ON pi.medication_id = m.medication_id " +
                     "WHERE p.visit_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, visitId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PrescriptionItem item = new PrescriptionItem();
                    item.setItemId(rs.getInt("item_id"));
                    item.setPrescriptionId(rs.getInt("prescription_id"));
                    item.setMedicationId(rs.getObject("medication_id") != null ? rs.getInt("medication_id") : null);
                    item.setMedicationName(rs.getString("medName"));
                    item.setDosage(rs.getString("dosage"));
                    item.setDuration(rs.getString("duration"));
                    item.setUsageInstruction(rs.getString("usage_instruction"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public TreatmentPlan getTreatmentPlanByVisitId(int visitId) {
        String sql = "SELECT * FROM treatment_plans WHERE visit_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, visitId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TreatmentPlan plan = new TreatmentPlan();
                    plan.setPlanId(rs.getInt("plan_id"));
                    plan.setVisitId(rs.getInt("visit_id"));
                    plan.setPatientId(rs.getInt("patient_id"));
                    plan.setTitle(rs.getString("title"));
                    plan.setCreatedAt(rs.getTimestamp("created_at"));
                    return plan;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<TreatmentStep> getTreatmentStepsByPlanId(int planId) {
        List<TreatmentStep> list = new ArrayList<>();
        String sql = "SELECT * FROM treatment_steps WHERE plan_id = ? ORDER BY step_order ASC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, planId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TreatmentStep step = new TreatmentStep();
                    step.setStepId(rs.getInt("step_id"));
                    step.setPlanId(rs.getInt("plan_id"));
                    step.setStepOrder(rs.getInt("step_order"));
                    step.setDescription(rs.getString("description"));
                    step.setEstimatedCost(rs.getBigDecimal("estimated_cost"));
                    step.setNextAppointmentDate(rs.getDate("next_appointment_date"));
                    step.setStatus(rs.getString("status"));
                    list.add(step);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
