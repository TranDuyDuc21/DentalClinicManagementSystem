package com.mycompany.dentalclinicmanagementsystem.controller.invoice;

import com.mycompany.dentalclinicmanagementsystem.dao.InvoiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Invoice;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "InvoiceListServlet", urlPatterns = {"/invoices"})
public class InvoiceListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        String paymentMethod = request.getParameter("paymentMethod");
        String searchStr = request.getParameter("search");

        String pageStr = request.getParameter("page");
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int limit = 10;
        int offset = (page - 1) * limit;

        InvoiceDAO invoiceDAO = new InvoiceDAO();
        List<Invoice> invoices = invoiceDAO.getAllInvoices(status, paymentMethod, searchStr, offset, limit);
        int totalInvoices = invoiceDAO.getTotalInvoices(status, paymentMethod, searchStr);
        int totalPages = (int) Math.ceil((double) totalInvoices / limit);

        request.setAttribute("invoices", invoices);
        request.setAttribute("pageNumber", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("status", status);
        request.setAttribute("paymentMethod", paymentMethod);
        request.setAttribute("search", searchStr);

        request.getRequestDispatcher("/WEB-INF/views/invoice/invoice-list.jsp").forward(request, response);
    }
}
