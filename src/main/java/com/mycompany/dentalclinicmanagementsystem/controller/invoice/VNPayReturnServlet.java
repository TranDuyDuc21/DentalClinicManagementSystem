package com.mycompany.dentalclinicmanagementsystem.controller.invoice;

import com.mycompany.dentalclinicmanagementsystem.service.PaymentService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;

@WebServlet("/vnpay-return")
public class VNPayReturnServlet extends HttpServlet {

    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        paymentService = new PaymentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        Map<String, String> requestParams = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            requestParams.put(fieldName, fieldValue);
        }

        Object userIdObj = session.getAttribute("userId");
        int recordedBy = userIdObj != null ? (int) userIdObj : 1; 

        PaymentService.PaymentReturnResult result = paymentService.processVNPayReturn(requestParams, recordedBy);

        if (result.isSuccess()) {
            session.setAttribute("msg", result.getMessage());
        } else {
            session.setAttribute("error", result.getMessage());
        }

        if (result.getInvoiceId() > 0) {
            response.sendRedirect(request.getContextPath() + "/invoice-detail?id=" + result.getInvoiceId());
        } else {
            response.sendRedirect(request.getContextPath() + "/invoices");
        }
    }
}
