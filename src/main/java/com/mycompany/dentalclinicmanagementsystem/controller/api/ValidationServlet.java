package com.mycompany.dentalclinicmanagementsystem.controller.api;

import com.mycompany.dentalclinicmanagementsystem.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/validate")
public class ValidationServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String field = request.getParameter("field");
        String value = request.getParameter("value");
        String excludeIdStr = request.getParameter("excludeId");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        if (field == null || value == null || value.trim().isEmpty()) {
            out.print("{\"exists\": false}");
            out.flush();
            return;
        }
        
        Integer excludeId = null;
        if (excludeIdStr != null && !excludeIdStr.trim().isEmpty()) {
            try {
                excludeId = Integer.parseInt(excludeIdStr);
            } catch (NumberFormatException e) {
                // ignore
            }
        }
        
        String dbField = field;
        if (field.equals("phone")) {
            dbField = "phone_number";
        }
        
        boolean exists = userDAO.isFieldExists(dbField, value.trim(), excludeId);
        
        out.print("{\"exists\": " + exists + "}");
        out.flush();
    }
}
