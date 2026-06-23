package com.mycompany.dentalclinicmanagementsystem.controller.appointment;

import com.mycompany.dentalclinicmanagementsystem.dao.MedicalRecordDAO;
import com.mycompany.dentalclinicmanagementsystem.dao.PatientDAO;
import com.mycompany.dentalclinicmanagementsystem.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/customer-visit-detail")
public class CustomerVisitDetailServlet extends HttpServlet {
    private MedicalRecordDAO medicalRecordDAO;
    private PatientDAO patientDAO;

    @Override
    public void init() {
        medicalRecordDAO = new MedicalRecordDAO();
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null || (!"Customer".equals(loggedUser.getRoleName()) && loggedUser.getRoleId() != 5)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String visitIdStr = request.getParameter("id");
        if (visitIdStr == null || visitIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/appointments");
            return;
        }

        try {
            int visitId = Integer.parseInt(visitIdStr);
            Visit visit = medicalRecordDAO.getVisitById(visitId);

            if (visit == null) {
                response.sendRedirect(request.getContextPath() + "/appointments");
                return;
            }

            // Security check: Only the patient themselves can view their medical record
            Patient patient = patientDAO.getPatientById(visit.getPatientId());
            if (patient == null || patient.getUserId() != loggedUser.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/appointments");
                return;
            }

            List<PrescriptionItem> prescriptions = medicalRecordDAO.getPrescriptionItemsByVisitId(visitId);
            TreatmentPlan plan = medicalRecordDAO.getTreatmentPlanByVisitId(visitId);
            List<TreatmentStep> steps = null;
            if (plan != null) {
                steps = medicalRecordDAO.getTreatmentStepsByPlanId(plan.getPlanId());
            }

            request.setAttribute("visit", visit);
            request.setAttribute("prescriptions", prescriptions);
            request.setAttribute("treatmentPlan", plan);
            request.setAttribute("treatmentSteps", steps);

            request.getRequestDispatcher("/WEB-INF/views/appointment/customer-visit-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/appointments");
        }
    }
}
