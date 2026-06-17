package com.mycompany.dentalclinicmanagementsystem.controller.invoice;

import com.mycompany.dentalclinicmanagementsystem.dao.InvoiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Invoice;
import com.mycompany.dentalclinicmanagementsystem.model.InvoiceItem;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "InvoiceUpdateServlet", urlPatterns = {"/invoice-update"})
public class InvoiceUpdateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("invoices");
            return;
        }

        try {
            int invoiceId = Integer.parseInt(idParam);
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            Invoice invoice = invoiceDAO.getInvoiceById(invoiceId);
            
            if (invoice != null && "Unpaid".equals(invoice.getStatus())) {
                List<InvoiceItem> items = invoiceDAO.getInvoiceItems(invoiceId);
                request.setAttribute("invoice", invoice);
                request.setAttribute("items", items);
                request.getRequestDispatcher("/WEB-INF/views/invoice/invoice-form.jsp").forward(request, response);
            } else {
                response.sendRedirect("invoice-detail?id=" + invoiceId);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("invoices");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
            BigDecimal discount = new BigDecimal(request.getParameter("discount"));
            
            String[] descriptions = request.getParameterValues("description[]");
            String[] quantities = request.getParameterValues("quantity[]");
            String[] unitPrices = request.getParameterValues("unitPrice[]");
            
            BigDecimal subtotal = BigDecimal.ZERO;
            List<InvoiceItem> items = new ArrayList<>();
            
            if (descriptions != null) {
                for (int i = 0; i < descriptions.length; i++) {
                    InvoiceItem item = new InvoiceItem();
                    item.setDescription(descriptions[i]);
                    item.setQuantity(Integer.parseInt(quantities[i]));
                    item.setUnitPrice(new BigDecimal(unitPrices[i]));
                    BigDecimal lineTotal = item.getUnitPrice().multiply(new BigDecimal(item.getQuantity()));
                    item.setLineTotal(lineTotal);
                    items.add(item);
                    
                    subtotal = subtotal.add(lineTotal);
                }
            }
            
            BigDecimal totalAmount = subtotal.subtract(discount);
            if (totalAmount.compareTo(BigDecimal.ZERO) < 0) {
                totalAmount = BigDecimal.ZERO;
            }
            
            Invoice invoice = new Invoice();
            invoice.setInvoiceId(invoiceId);
            invoice.setSubtotal(subtotal);
            invoice.setDiscount(discount);
            invoice.setTotalAmount(totalAmount);
            
            InvoiceDAO dao = new InvoiceDAO();
            Invoice currentInvoice = dao.getInvoiceById(invoiceId);
            if (currentInvoice != null && "Unpaid".equals(currentInvoice.getStatus())) {
                boolean success = dao.updateInvoice(invoice, items);
                if (success) {
                    request.getSession().setAttribute("msg", "Cập nhật hóa đơn thành công!");
                } else {
                    request.getSession().setAttribute("msg", "Có lỗi xảy ra khi cập nhật hóa đơn!");
                }
            }
            response.sendRedirect("invoice-detail?id=" + invoiceId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("invoices");
        }
    }
}
