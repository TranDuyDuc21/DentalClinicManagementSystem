package com.mycompany.dentalclinicmanagementsystem.controller.patient;

import com.mycompany.dentalclinicmanagementsystem.dao.PatientDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Patient;
import com.mycompany.dentalclinicmanagementsystem.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/patients")
public class PatientListServlet extends HttpServlet {

    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        // Allowed for Receptionist, Admin, Doctor (per UC18: Doctor and Receptionist can view)
        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String search = request.getParameter("search");
        String gender = request.getParameter("gender");

        String pageStr = request.getParameter("page");
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int limit = 10;
        int offset = (page - 1) * limit;

        List<Patient> patients = patientDAO.getAllPatients(search, gender, offset, limit);
        int totalPatients = patientDAO.getTotalPatients(search, gender);
        int totalPages = (int) Math.ceil((double) totalPatients / limit);

        request.setAttribute("patients", patients);
        request.setAttribute("pageNumber", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/WEB-INF/views/patient/patient-list.jsp").forward(request, response);
    }
}
