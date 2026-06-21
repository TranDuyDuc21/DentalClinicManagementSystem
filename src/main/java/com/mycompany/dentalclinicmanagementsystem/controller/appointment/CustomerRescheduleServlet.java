package com.mycompany.dentalclinicmanagementsystem.controller.appointment;

import java.io.IOException;

import com.mycompany.dentalclinicmanagementsystem.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CustomerRescheduleServlet", urlPatterns = {"/reschedule-appointment"})
public class CustomerRescheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null || !"Customer".equalsIgnoreCase(loggedUser.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Just pass params to JSP
        request.getRequestDispatcher("/WEB-INF/views/appointment/reschedule-form.jsp").forward(request, response);
    }
}
