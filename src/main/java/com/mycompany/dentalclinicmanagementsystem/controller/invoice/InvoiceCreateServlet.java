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
        String visitIdParam = request.getParameter("visitId");
        if (visitIdParam != null && !visitIdParam.isEmpty()) {
            try {
                int visitId = Integer.parseInt(visitIdParam);
                String sql = "SELECT v.visit_id, p.patient_id, p.full_name as patientName, a.service_id, s.service_name, s.listed_price " +
                             "FROM visits v " +
                             "JOIN patients p ON v.patient_id = p.patient_id " +
                             "JOIN appointments a ON v.appointment_id = a.appointment_id " +
                             "LEFT JOIN services s ON a.service_id = s.service_id " +
                             "WHERE v.visit_id = ?";
                try (java.sql.Connection conn = com.mycompany.dentalclinicmanagementsystem.dao.DBContext.getConnection();
                     java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, visitId);
                    try (java.sql.ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            request.setAttribute("visitId", visitId);
                            request.setAttribute("patientId", rs.getInt("patient_id"));
                            request.setAttribute("patientName", rs.getString("patientName"));
                            
                            List<InvoiceItem> defaultItems = new ArrayList<>();
                            
                            int serviceId = rs.getInt("service_id");
                            if (!rs.wasNull()) {
                                InvoiceItem mainItem = new InvoiceItem();
                                mainItem.setDescription(rs.getString("service_name"));
                                mainItem.setQuantity(1);
                                BigDecimal price = rs.getBigDecimal("listed_price");
                                if (price == null) price = BigDecimal.ZERO;
                                mainItem.setUnitPrice(price);
                                mainItem.setLineTotal(price);
                                defaultItems.add(mainItem);
                            }
                            
                            // Fetch test orders
                            String sqlTests = "SELECT test_type, cost FROM test_orders WHERE visit_id = ?";
                            try(java.sql.PreparedStatement psTests = conn.prepareStatement(sqlTests)) {
                                psTests.setInt(1, visitId);
                                try(java.sql.ResultSet rsTests = psTests.executeQuery()) {
                                    while(rsTests.next()) {
                                        InvoiceItem testItem = new InvoiceItem();
                                        testItem.setDescription("Xét nghiệm: " + rsTests.getString("test_type"));
                                        testItem.setQuantity(1);
                                        BigDecimal testCost = rsTests.getBigDecimal("cost");
                                        if (testCost == null) testCost = BigDecimal.ZERO;
                                        testItem.setUnitPrice(testCost);
                                        testItem.setLineTotal(testCost);
                                        defaultItems.add(testItem);
                                    }
                                }
                            }
                            
                            // Fetch treatment steps
                            String sqlSteps = "SELECT ts.description, ts.estimated_cost FROM treatment_steps ts " +
                                              "JOIN treatment_plans tp ON ts.plan_id = tp.plan_id " +
                                              "WHERE tp.visit_id = ?";
                            try(java.sql.PreparedStatement psSteps = conn.prepareStatement(sqlSteps)) {
                                psSteps.setInt(1, visitId);
                                try(java.sql.ResultSet rsSteps = psSteps.executeQuery()) {
                                    while(rsSteps.next()) {
                                        InvoiceItem stepItem = new InvoiceItem();
                                        stepItem.setDescription("Thủ thuật: " + rsSteps.getString("description"));
                                        stepItem.setQuantity(1);
                                        BigDecimal cost = rsSteps.getBigDecimal("estimated_cost");
                                        if (cost == null) cost = BigDecimal.ZERO;
                                        stepItem.setUnitPrice(cost);
                                        stepItem.setLineTotal(cost);
                                        defaultItems.add(stepItem);
                                    }
                                }
                            }
                            
                            if (!defaultItems.isEmpty()) {
                                request.setAttribute("defaultItems", defaultItems);
                            }
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
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
