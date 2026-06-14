package com.mycompany.dentalclinicmanagementsystem.controller.auth;

import com.mycompany.dentalclinicmanagementsystem.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");
        
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        Integer attempts = (Integer) session.getAttribute("otpAttempts");
        if (attempts == null) attempts = 0;

        String otp = request.getParameter("otp");

        AuthService.ResetResult result = authService.processVerifyOtp(email, otp, attempts);

        if (result.status == AuthService.ResetStatus.ERROR_MAX_ATTEMPTS) {
            session.removeAttribute("resetEmail");
            session.removeAttribute("otpAttempts");
            session.setAttribute("errorMsg", result.message);
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        if (result.status != AuthService.ResetStatus.SUCCESS) {
            // Update attempts in session
            if (result.dataId != null) {
                session.setAttribute("otpAttempts", result.dataId);
            }
            request.setAttribute("error", result.message);
            request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
            return;
        }

        // OTP đúng -> Lưu cờ xác thực vào session
        session.setAttribute("otpVerified", true);
        session.setAttribute("verifiedOtp", otp.trim());
        session.setAttribute("resetUserId", result.dataId);
        session.removeAttribute("otpAttempts"); // Reset số lần thử
        
        response.sendRedirect(request.getContextPath() + "/reset-password");
    }
}
