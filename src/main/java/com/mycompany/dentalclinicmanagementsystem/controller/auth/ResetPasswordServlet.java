package com.mycompany.dentalclinicmanagementsystem.controller.auth;

import com.mycompany.dentalclinicmanagementsystem.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        
        if (otpVerified == null || !otpVerified) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        
        if (otpVerified == null || !otpVerified) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        Integer userId = (Integer) session.getAttribute("resetUserId");
        String verifiedOtp = (String) session.getAttribute("verifiedOtp");

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        AuthService.ResetResult result = authService.processResetPassword(userId, verifiedOtp, newPassword, confirmPassword);

        if (result.status == AuthService.ResetStatus.SUCCESS) {
            // Xóa sạch session liên quan đến reset password
            session.removeAttribute("resetEmail");
            session.removeAttribute("otpVerified");
            session.removeAttribute("verifiedOtp");
            session.removeAttribute("resetUserId");
            
            // Đặt cờ thành công để báo cho trang login
            session.setAttribute("successMessage", result.message);
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("error", result.message);
            request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
        }
    }
}
