package com.mycompany.dentalclinicmanagementsystem.controller.api;

import com.mycompany.dentalclinicmanagementsystem.service.ClinicService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/api/services/check-code")
public class ServiceCheckCodeServlet extends HttpServlet {

    private ClinicService clinicService;

    @Override
    public void init() throws ServletException {
        clinicService = new ClinicService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        String excludeIdStr = request.getParameter("excludeId");
        
        Integer excludeId = null;
        if (excludeIdStr != null && !excludeIdStr.trim().isEmpty()) {
            try {
                excludeId = Integer.parseInt(excludeIdStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }

        boolean exists = clinicService.isServiceCodeExists(code, excludeId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"exists\": " + exists + "}");
    }
}
