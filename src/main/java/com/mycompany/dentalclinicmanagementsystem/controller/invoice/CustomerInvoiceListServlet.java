package com.mycompany.dentalclinicmanagementsystem.controller.invoice;

import com.mycompany.dentalclinicmanagementsystem.dao.InvoiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Invoice;
import com.mycompany.dentalclinicmanagementsystem.model.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CustomerInvoiceListServlet", urlPatterns = {"/customer-invoices"})
public class CustomerInvoiceListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User loggedUser = (User) session.getAttribute("loggedUser");

        if (loggedUser == null || (!"Customer".equals(loggedUser.getRoleName()) && loggedUser.getRoleId() != 5)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

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
        List<Invoice> invoices = invoiceDAO.getInvoicesByUserId(loggedUser.getUserId(), limit, offset);
        int totalInvoices = invoiceDAO.getTotalInvoicesByUserId(loggedUser.getUserId());
        int totalPages = (int) Math.ceil((double) totalInvoices / limit);

        request.setAttribute("invoices", invoices);
        request.setAttribute("pageNumber", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/WEB-INF/views/invoice/customer-invoice-list.jsp").forward(request, response);
    }
}
