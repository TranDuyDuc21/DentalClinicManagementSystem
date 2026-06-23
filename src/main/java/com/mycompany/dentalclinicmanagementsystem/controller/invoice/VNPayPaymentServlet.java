package com.mycompany.dentalclinicmanagementsystem.controller.invoice;

import com.mycompany.dentalclinicmanagementsystem.dao.InvoiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Invoice;
import com.mycompany.dentalclinicmanagementsystem.model.User;
import com.mycompany.dentalclinicmanagementsystem.service.PaymentService;
import com.mycompany.dentalclinicmanagementsystem.util.VNPayConfig;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/vnpay-payment")
public class VNPayPaymentServlet extends HttpServlet {

    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        paymentService = new PaymentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String invoiceIdStr = request.getParameter("invoiceId");
            String amountStr = request.getParameter("amount");

            if (invoiceIdStr == null || invoiceIdStr.isEmpty() || amountStr == null || amountStr.isEmpty()) {
                session.setAttribute("error", "Dữ liệu thanh toán không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/invoices");
                return;
            }

            int invoiceId = Integer.parseInt(invoiceIdStr);
            long amountVND = new java.math.BigDecimal(amountStr).longValue();
            
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            Invoice invoice = invoiceDAO.getInvoiceById(invoiceId);

            if (invoice == null) {
                session.setAttribute("error", "Không tìm thấy hóa đơn.");
                response.sendRedirect(request.getContextPath() + "/invoices");
                return;
            }

            String ipAddress = VNPayConfig.getIpAddress(request);
            String returnUrl = VNPayConfig.getReturnUrl(request);

            String paymentUrl = paymentService.createVNPayPaymentUrl(invoice, amountVND, ipAddress, returnUrl);
            
            response.sendRedirect(paymentUrl);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Dữ liệu hóa đơn không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/invoices");
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi thanh toán: " + e.getMessage());
            String invoiceIdStr = request.getParameter("invoiceId");
            if (invoiceIdStr != null && !invoiceIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/invoice-detail?id=" + invoiceIdStr);
            } else {
                response.sendRedirect(request.getContextPath() + "/invoices");
            }
        }
    }
}
