package com.mycompany.dentalclinicmanagementsystem.controller;

import com.mycompany.dentalclinicmanagementsystem.dao.UserDAO;
import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");

        if (identifier == null || identifier.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không được để trống.");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.getUserByUsernameOrEmail(identifier);

        if (user != null && PasswordUtil.checkPassword(password, user.getPasswordHash())) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loggedUser", user);
            
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("errorMessage", "Tên đăng nhập/email hoặc mật khẩu không đúng.");
            request.setAttribute("identifier", identifier);
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }
}
