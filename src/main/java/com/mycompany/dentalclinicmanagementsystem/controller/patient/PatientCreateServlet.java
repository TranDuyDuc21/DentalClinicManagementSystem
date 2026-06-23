package com.mycompany.dentalclinicmanagementsystem.controller.patient;

import com.mycompany.dentalclinicmanagementsystem.service.PatientService;
import com.mycompany.dentalclinicmanagementsystem.model.Patient;
import com.mycompany.dentalclinicmanagementsystem.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/patients/create")
public class PatientCreateServlet extends HttpServlet {

    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        patientService = new PatientService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/patient/patient-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String fullName = request.getParameter("fullName");
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            String phoneNumber = request.getParameter("phoneNumber");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String medicalHistory = request.getParameter("medicalHistory");
            String drugAllergies = request.getParameter("drugAllergies");

            Patient patient = new Patient();
            patient.setFullName(fullName);
            if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
                patient.setDateOfBirth(Date.valueOf(dateOfBirthStr));
            }
            patient.setGender(gender);
            patient.setPhoneNumber(phoneNumber);
            patient.setEmail(email);
            patient.setAddress(address);
            patient.setMedicalHistory(medicalHistory);
            patient.setDrugAllergies(drugAllergies);

            String patientIdStr = request.getParameter("patientId");
            boolean isUpdate = (patientIdStr != null && !patientIdStr.trim().isEmpty());

            boolean success;
            if (isUpdate) {
                patient.setPatientId(Integer.parseInt(patientIdStr));
                success = patientService.updatePatient(patient);
                if (success) {
                    session.setAttribute("successMessage", "Đã cập nhật hồ sơ bệnh nhân thành công.");
                    response.sendRedirect(request.getContextPath() + "/patients"); 
                } else {
                    session.setAttribute("errorMessage", "Đã xảy ra lỗi khi cập nhật hồ sơ. Vui lòng thử lại.");
                    response.sendRedirect(request.getContextPath() + "/patients/create");
                }
            } else {
                success = patientService.createPatient(patient);
                if (success) {
                    session.setAttribute("successMessage", "Đã tạo hồ sơ bệnh nhân thành công với mã: " + patient.getPatientCode());
                    response.sendRedirect(request.getContextPath() + "/patients"); 
                } else {
                    session.setAttribute("errorMessage", "Đã xảy ra lỗi khi tạo hồ sơ. Vui lòng thử lại.");
                    response.sendRedirect(request.getContextPath() + "/patients/create");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/patients/create");
        }
    }
}
