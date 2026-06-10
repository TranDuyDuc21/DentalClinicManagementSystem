package com.mycompany.dentalclinicmanagementsystem.controller.api;

import com.mycompany.dentalclinicmanagementsystem.dao.PatientDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;

@WebServlet("/api/patient")
public class PatientApiServlet extends HttpServlet {

    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String phone = request.getParameter("phone");

        if (phone == null || phone.trim().isEmpty()) {
            out.print("{\"success\": false, \"message\": \"Số điện thoại không được để trống\"}");
            out.flush();
            return;
        }

        java.util.List<Patient> patients = patientDAO.getPatientsByPhone(phone.trim());

        if (patients != null && !patients.isEmpty()) {
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"success\": true,");
            json.append("\"patients\": [");
            for (int i = 0; i < patients.size(); i++) {
                Patient patient = patients.get(i);
                json.append("{");
                json.append("\"patientId\": ").append(patient.getPatientId()).append(",");
                json.append("\"patientCode\": \"").append(escapeJson(patient.getPatientCode())).append("\",");
                json.append("\"fullName\": \"").append(escapeJson(patient.getFullName())).append("\",");
                
                String dobStr = "";
                if (patient.getDateOfBirth() != null) {
                    dobStr = new SimpleDateFormat("yyyy-MM-dd").format(patient.getDateOfBirth());
                }
                json.append("\"dateOfBirth\": \"").append(dobStr).append("\",");
                json.append("\"gender\": \"").append(escapeJson(patient.getGender())).append("\",");
                json.append("\"phoneNumber\": \"").append(escapeJson(patient.getPhoneNumber())).append("\",");
                json.append("\"email\": \"").append(escapeJson(patient.getEmail())).append("\",");
                json.append("\"address\": \"").append(escapeJson(patient.getAddress())).append("\",");
                json.append("\"medicalHistory\": \"").append(escapeJson(patient.getMedicalHistory())).append("\",");
                json.append("\"drugAllergies\": \"").append(escapeJson(patient.getDrugAllergies())).append("\"");
                json.append("}");
                if (i < patients.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            json.append("}");
            out.print(json.toString());
        } else {
            out.print("{\"success\": false, \"message\": \"Không tìm thấy bệnh nhân\"}");
        }
        
        out.flush();
    }

    private String escapeJson(String data) {
        if (data == null) {
            return "";
        }
        return data.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\b", "\\b")
                   .replace("\f", "\\f")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
