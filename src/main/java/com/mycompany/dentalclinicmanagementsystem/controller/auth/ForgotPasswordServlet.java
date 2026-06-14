package com.mycompany.dentalclinicmanagementsystem.controller.auth;

import com.mycompany.dentalclinicmanagementsystem.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        
        AuthService.ResetResult result = authService.processForgotPassword(email);

        if (result.status != AuthService.ResetStatus.SUCCESS) {
            request.setAttribute("error", result.message);
            request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("resetEmail", result.message); // message contains the normalized email from DB
        session.setAttribute("otpAttempts", 0);
        
        response.sendRedirect(request.getContextPath() + "/verify-otp");
    }
}
