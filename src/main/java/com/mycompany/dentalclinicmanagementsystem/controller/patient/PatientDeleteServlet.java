package com.mycompany.dentalclinicmanagementsystem.controller.patient;

import com.mycompany.dentalclinicmanagementsystem.service.PatientService;
import com.mycompany.dentalclinicmanagementsystem.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/patients/delete")
public class PatientDeleteServlet extends HttpServlet {

    private PatientService patientService;

    @Override
    public void init() throws ServletException {
        patientService = new PatientService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int patientId = Integer.parseInt(idStr);
                boolean success = patientService.deletePatient(patientId, loggedUser);
                if (success) {
                    session.setAttribute("successMessage", "Xoá hồ sơ bệnh nhân thành công.");
                } else {
                    session.setAttribute("errorMessage", "Không thể xoá hồ sơ bệnh nhân. Vui lòng thử lại.");
                }
            } catch (IllegalAccessException e) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
                return;
            } catch (SQLException e) {
                session.setAttribute("errorMessage", "Không thể xoá bệnh nhân này vì đã có lịch khám/điều trị liên quan.");
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Mã bệnh nhân không hợp lệ.");
            }
        } else {
            session.setAttribute("errorMessage", "Không tìm thấy hồ sơ để xoá.");
        }
        
        response.sendRedirect(request.getContextPath() + "/patients");
    }
}
