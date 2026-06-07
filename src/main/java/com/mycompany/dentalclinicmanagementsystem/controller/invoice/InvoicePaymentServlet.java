package com.mycompany.dentalclinicmanagementsystem.controller.invoice;

import com.mycompany.dentalclinicmanagementsystem.dao.InvoiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Payment;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "InvoicePaymentServlet", urlPatterns = {"/invoice-payment"})
public class InvoicePaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
            BigDecimal amount = new BigDecimal(request.getParameter("amount"));
            String paymentMethod = request.getParameter("paymentMethod");
            String transactionRef = request.getParameter("transactionRef");
            
            Object userIdObj = request.getSession().getAttribute("userId");
            int recordedBy = userIdObj != null ? (int) userIdObj : 1; // Fallback to 1 for testing
            
            Payment payment = new Payment();
            payment.setInvoiceId(invoiceId);
            payment.setAmount(amount);
            payment.setPaymentMethod(paymentMethod);
            payment.setTransactionRef(transactionRef);
            payment.setRecordedBy(recordedBy);
            
            InvoiceDAO dao = new InvoiceDAO();
            boolean success = dao.addPayment(payment);
            
            if (success) {
                request.getSession().setAttribute("msg", "Payment added successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to add payment");
            }
            
            response.sendRedirect("invoice-detail?id=" + invoiceId);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("invoices"); // redirect to list on error
        }
    }
}
