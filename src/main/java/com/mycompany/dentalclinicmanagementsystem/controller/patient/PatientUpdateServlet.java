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

@WebServlet("/patients/update")
public class PatientUpdateServlet extends HttpServlet {

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

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int patientId = Integer.parseInt(idStr);
                Patient patient = patientService.getPatientById(patientId);
                if (patient != null) {
                    request.setAttribute("patient", patient);
                    request.getRequestDispatcher("/WEB-INF/views/patient/patient-form.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Ignore and fall through to error
            }
        }
        
        session.setAttribute("errorMessage", "Không tìm thấy thông tin bệnh nhân.");
        response.sendRedirect(request.getContextPath() + "/patients");
    }
}
