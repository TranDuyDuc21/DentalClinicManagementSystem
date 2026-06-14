package com.mycompany.dentalclinicmanagementsystem.controller.auth;

import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            User user = (User) session.getAttribute("loggedUser");
            response.sendRedirect(request.getContextPath() + authService.getRedirectUrl(user));
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");
        String redirectUrl = request.getParameter("redirect");

        try {
            User user = authService.login(identifier, password);
            HttpSession session = request.getSession(true);
            session.setAttribute("loggedUser", user);
            
            if (redirectUrl != null && !redirectUrl.trim().isEmpty() && redirectUrl.startsWith("/")) {
                response.sendRedirect(request.getContextPath() + redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + authService.getRedirectUrl(user));
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("identifier", identifier);
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                request.setAttribute("redirect", redirectUrl);
            }
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }
}
