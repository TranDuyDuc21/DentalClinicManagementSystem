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

@WebServlet(name = "InvoiceCreateServlet", urlPatterns = {"/invoice-create"})
public class InvoiceCreateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Normally we'd load active visits/patients to display in the dropdown here
        // For simplicity, we just forward to the form
        request.getRequestDispatcher("/WEB-INF/views/invoice/invoice-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            int visitId = Integer.parseInt(request.getParameter("visitId")); // assuming visitId is selected or entered
            BigDecimal discount = new BigDecimal(request.getParameter("discount"));
            
            // Assume the user ID is stored in session, fallback to 1 (Admin) for demo
            Object userIdObj = request.getSession().getAttribute("userId");
            int createdBy = userIdObj != null ? (int) userIdObj : 1;
            
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
            invoice.setInvoiceCode("INV-" + System.currentTimeMillis()); // generate code
            invoice.setPatientId(patientId);
            invoice.setVisitId(visitId);
            invoice.setSubtotal(subtotal);
            invoice.setDiscount(discount);
            invoice.setTotalAmount(totalAmount);
            invoice.setStatus("Unpaid");
            invoice.setCreatedBy(createdBy);
            
            InvoiceDAO dao = new InvoiceDAO();
            int newId = dao.createInvoice(invoice, items);
            
            if (newId > 0) {
                response.sendRedirect("invoice-detail?id=" + newId);
            } else {
                request.setAttribute("error", "Could not create invoice.");
                request.getRequestDispatcher("/WEB-INF/views/invoice/invoice-form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid input: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/invoice/invoice-form.jsp").forward(request, response);
        }
    }
}
