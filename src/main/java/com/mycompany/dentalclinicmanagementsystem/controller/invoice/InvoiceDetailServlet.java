package com.mycompany.dentalclinicmanagementsystem.controller.invoice;

import com.mycompany.dentalclinicmanagementsystem.dao.InvoiceDAO;
import com.mycompany.dentalclinicmanagementsystem.model.Invoice;
import com.mycompany.dentalclinicmanagementsystem.model.InvoiceItem;
import com.mycompany.dentalclinicmanagementsystem.model.Payment;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "InvoiceDetailServlet", urlPatterns = {"/invoice-detail"})
public class InvoiceDetailServlet extends HttpServlet {

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
            
            if (invoice != null) {
                com.mycompany.dentalclinicmanagementsystem.model.User loggedUser = (com.mycompany.dentalclinicmanagementsystem.model.User) request.getSession().getAttribute("loggedUser");
                if (loggedUser != null && ("Customer".equals(loggedUser.getRoleName()) || loggedUser.getRoleId() == 5)) {
                    com.mycompany.dentalclinicmanagementsystem.dao.PatientDAO patientDAO = new com.mycompany.dentalclinicmanagementsystem.dao.PatientDAO();
                    com.mycompany.dentalclinicmanagementsystem.model.Patient patient = patientDAO.getPatientById(invoice.getPatientId());
                    if (patient == null || patient.getUserId() == null || !patient.getUserId().equals(loggedUser.getUserId())) {
                        response.sendRedirect(request.getContextPath() + "/appointments");
                        return;
                    }
                }
                List<InvoiceItem> items = invoiceDAO.getInvoiceItems(invoiceId);
                List<Payment> payments = invoiceDAO.getPaymentsByInvoice(invoiceId);
                
                request.setAttribute("invoice", invoice);
                request.setAttribute("items", items);
                request.setAttribute("payments", payments);
                
                request.getRequestDispatcher("/WEB-INF/views/invoice/invoice-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect("invoices");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("invoices");
        }
    }
}
