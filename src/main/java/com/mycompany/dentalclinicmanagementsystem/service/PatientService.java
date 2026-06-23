package com.mycompany.dentalclinicmanagementsystem.service;

import com.mycompany.dentalclinicmanagementsystem.dao.PatientDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Patient;
import com.mycompany.dentalclinicmanagementsystem.model.User;

import java.sql.SQLException;
import java.util.List;

public class PatientService {

    private PatientDAO patientDAO;

    public PatientService() {
        this.patientDAO = new PatientDAO();
    }

    public List<Patient> getAllPatients(String search, String gender, int page, int limit) {
        int offset = (page - 1) * limit;
        return patientDAO.getAllPatients(search, gender, offset, limit);
    }

    public int getTotalPages(String search, String gender, int limit) {
        int totalPatients = patientDAO.getTotalPatients(search, gender);
        return (int) Math.ceil((double) totalPatients / limit);
    }

    public Patient getPatientById(int id) {
        return patientDAO.getPatientById(id);
    }

    public boolean createPatient(Patient patient) {
        String patientCode = patientDAO.generatePatientCode();
        patient.setPatientCode(patientCode);
        return patientDAO.createPatient(patient);
    }

    public boolean updatePatient(Patient patient) {
        return patientDAO.updatePatient(patient);
    }

    public boolean deletePatient(int patientId, User loggedUser) throws SQLException, IllegalAccessException {
        if (loggedUser == null || (!loggedUser.getRoleName().equals("Admin") && !loggedUser.getRoleName().equals("Receptionist"))) {
            throw new IllegalAccessException("Bạn không có quyền thực hiện thao tác này.");
        }
        return patientDAO.deletePatient(patientId);
    }

    public Patient getPatientByUserId(int userId) {
        return patientDAO.getPatientByUserId(userId);
    }
}
