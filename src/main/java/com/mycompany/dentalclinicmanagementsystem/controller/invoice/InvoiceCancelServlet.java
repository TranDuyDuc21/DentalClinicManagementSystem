package com.mycompany.dentalclinicmanagementsystem.controller.invoice;

import com.mycompany.dentalclinicmanagementsystem.dao.InvoiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Invoice;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "InvoiceCancelServlet", urlPatterns = {"/invoice-cancel"})
public class InvoiceCancelServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("invoiceId");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("invoices");
            return;
        }

        try {
            int invoiceId = Integer.parseInt(idParam);
            InvoiceDAO dao = new InvoiceDAO();
            Invoice invoice = dao.getInvoiceById(invoiceId);
            
            if (invoice != null && "Unpaid".equals(invoice.getStatus())) {
                boolean success = dao.updateInvoiceStatus(invoiceId, "Cancelled");
                if (success) {
                    request.getSession().setAttribute("msg", "Hủy hóa đơn thành công!");
                } else {
                    request.getSession().setAttribute("msg", "Có lỗi xảy ra khi hủy hóa đơn!");
                }
            } else {
                request.getSession().setAttribute("msg", "Không thể hủy hóa đơn này!");
            }
            response.sendRedirect("invoice-detail?id=" + invoiceId);
        } catch (NumberFormatException e) {
            response.sendRedirect("invoices");
        }
    }
}
