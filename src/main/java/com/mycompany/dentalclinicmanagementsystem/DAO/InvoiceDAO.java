package com.mycompany.dentalclinicmanagementsystem.dao;

import com.mycompany.dentalclinicmanagementsystem.model.Invoice;
import com.mycompany.dentalclinicmanagementsystem.model.InvoiceItem;
import com.mycompany.dentalclinicmanagementsystem.model.Payment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO extends DBContext {

    public List<Invoice> getAllInvoices(String status, String paymentMethod, String searchStr) {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT i.*, p.full_name as patientName, p.phone_number as patientPhone, u.full_name as createdByName " +
                     "FROM invoices i " +
                     "JOIN patients p ON i.patient_id = p.patient_id " +
                     "LEFT JOIN users u ON i.created_by = u.user_id " +
                     "WHERE 1=1 ";

        if (status != null && !status.isEmpty()) {
            sql += " AND i.status = ? ";
        }
        
        // paymentMethod filtering might need join with payments table or just basic filtering if we simplify.
        // Actually, we can filter by paymentMethod using EXISTS if needed, but let's stick to status and search first.
        if (paymentMethod != null && !paymentMethod.isEmpty()) {
            sql += " AND EXISTS (SELECT 1 FROM payments py WHERE py.invoice_id = i.invoice_id AND py.payment_method = ?) ";
        }

        if (searchStr != null && !searchStr.isEmpty()) {
            sql += " AND (i.invoice_code LIKE ? OR p.full_name LIKE ? OR p.phone_number LIKE ?) ";
        }
        
        sql += " ORDER BY i.created_at DESC";

        try (Connection connection = DBContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            int paramIndex = 1;
            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            if (paymentMethod != null && !paymentMethod.isEmpty()) {
                ps.setString(paramIndex++, paymentMethod);
            }
            if (searchStr != null && !searchStr.isEmpty()) {
                String likeSearch = "%" + searchStr + "%";
                ps.setString(paramIndex++, likeSearch);
                ps.setString(paramIndex++, likeSearch);
                ps.setString(paramIndex++, likeSearch);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice inv = mapInvoice(rs);
                    list.add(inv);
                }
            }
        } catch (SQLException e) {
            System.out.println("getAllInvoices error: " + e.getMessage());
        }
        return list;
    }

    public Invoice getInvoiceById(int id) {
        String sql = "SELECT i.*, p.full_name as patientName, p.phone_number as patientPhone, u.full_name as createdByName " +
                     "FROM invoices i " +
                     "JOIN patients p ON i.patient_id = p.patient_id " +
                     "LEFT JOIN users u ON i.created_by = u.user_id " +
                     "WHERE i.invoice_id = ?";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapInvoice(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("getInvoiceById error: " + e.getMessage());
        }
        return null;
    }

    public int createInvoice(Invoice invoice, List<InvoiceItem> items) {
        String insertInvoice = "INSERT INTO invoices (invoice_code, visit_id, patient_id, subtotal, discount, total_amount, status, created_by) " +
                               "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String insertItem = "INSERT INTO invoice_items (invoice_id, service_id, description, quantity, unit_price, line_total) " +
                            "VALUES (?, ?, ?, ?, ?, ?)";
                            
        try (Connection connection = DBContext.getConnection()) {
            connection.setAutoCommit(false);
            try {
                int newInvoiceId = -1;
                try (PreparedStatement psInv = connection.prepareStatement(insertInvoice, Statement.RETURN_GENERATED_KEYS)) {
                    psInv.setString(1, invoice.getInvoiceCode());
                    psInv.setInt(2, invoice.getVisitId());
                    psInv.setInt(3, invoice.getPatientId());
                    psInv.setBigDecimal(4, invoice.getSubtotal());
                    psInv.setBigDecimal(5, invoice.getDiscount());
                    psInv.setBigDecimal(6, invoice.getTotalAmount());
                    psInv.setString(7, invoice.getStatus());
                    psInv.setInt(8, invoice.getCreatedBy());
                    psInv.executeUpdate();
                    
                    try (ResultSet rs = psInv.getGeneratedKeys()) {
                        if (rs.next()) {
                            newInvoiceId = rs.getInt(1);
                        }
                    }
                }
                
                if (newInvoiceId != -1) {
                    try (PreparedStatement psItem = connection.prepareStatement(insertItem)) {
                        for (InvoiceItem item : items) {
                            psItem.setInt(1, newInvoiceId);
                            if (item.getServiceId() != null) {
                                psItem.setInt(2, item.getServiceId());
                            } else {
                                psItem.setNull(2, java.sql.Types.INTEGER);
                            }
                            psItem.setString(3, item.getDescription());
                            psItem.setInt(4, item.getQuantity());
                            psItem.setBigDecimal(5, item.getUnitPrice());
                            psItem.setBigDecimal(6, item.getLineTotal());
                            psItem.addBatch();
                        }
                        psItem.executeBatch();
                    }
                    connection.commit();
                    return newInvoiceId;
                } else {
                    connection.rollback();
                }
            } catch (SQLException e) {
                try { connection.rollback(); } catch (SQLException ex) {}
                System.out.println("createInvoice error: " + e.getMessage());
            } finally {
                try { connection.setAutoCommit(true); } catch (SQLException ex) {}
            }
        } catch (SQLException e) {
            System.out.println("Database connection error: " + e.getMessage());
        }
        return -1;
    }

    public boolean updateInvoiceStatus(int invoiceId, String status) {
        String sql = "UPDATE invoices SET status = ? WHERE invoice_id = ?";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, invoiceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("updateInvoiceStatus error: " + e.getMessage());
        }
        return false;
    }

    public List<InvoiceItem> getInvoiceItems(int invoiceId) {
        List<InvoiceItem> list = new ArrayList<>();
        String sql = "SELECT ii.*, s.service_name " +
                     "FROM invoice_items ii " +
                     "LEFT JOIN services s ON ii.service_id = s.service_id " +
                     "WHERE ii.invoice_id = ?";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InvoiceItem item = new InvoiceItem();
                    item.setInvoiceItemId(rs.getInt("invoice_item_id"));
                    item.setInvoiceId(rs.getInt("invoice_id"));
                    item.setServiceId(rs.getObject("service_id") != null ? rs.getInt("service_id") : null);
                    item.setDescription(rs.getString("description"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    item.setLineTotal(rs.getBigDecimal("line_total"));
                    item.setServiceName(rs.getString("service_name"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            System.out.println("getInvoiceItems error: " + e.getMessage());
        }
        return list;
    }

    public List<Payment> getPaymentsByInvoice(int invoiceId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, u.full_name as recordedByName " +
                     "FROM payments p " +
                     "LEFT JOIN users u ON p.recorded_by = u.user_id " +
                     "WHERE p.invoice_id = ? " +
                     "ORDER BY p.paid_at DESC";
        try (Connection connection = DBContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payment p = new Payment();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setInvoiceId(rs.getInt("invoice_id"));
                    p.setAmount(rs.getBigDecimal("amount"));
                    p.setPaymentMethod(rs.getString("payment_method"));
                    p.setTransactionRef(rs.getString("transaction_ref"));
                    p.setPaidAt(rs.getTimestamp("paid_at"));
                    p.setRecordedBy(rs.getInt("recorded_by"));
                    p.setRecordedByName(rs.getString("recordedByName"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            System.out.println("getPaymentsByInvoice error: " + e.getMessage());
        }
        return list;
    }

    public boolean addPayment(Payment payment) {
        String sql = "INSERT INTO payments (invoice_id, amount, payment_method, transaction_ref, recorded_by) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = DBContext.getConnection()) {
            connection.setAutoCommit(false);
            try {
                try (PreparedStatement ps = connection.prepareStatement(sql)) {
                    ps.setInt(1, payment.getInvoiceId());
                    ps.setBigDecimal(2, payment.getAmount());
                    ps.setString(3, payment.getPaymentMethod());
                    ps.setString(4, payment.getTransactionRef());
                    ps.setInt(5, payment.getRecordedBy());
                    int rows = ps.executeUpdate();
                    
                    if (rows > 0) {
                        // check if total paid >= invoice total amount to update status to Paid
                        String sumSql = "SELECT SUM(amount) FROM payments WHERE invoice_id = ?";
                        try (PreparedStatement psSum = connection.prepareStatement(sumSql)) {
                            psSum.setInt(1, payment.getInvoiceId());
                            try (ResultSet rsSum = psSum.executeQuery()) {
                                if (rsSum.next()) {
                                    java.math.BigDecimal totalPaid = rsSum.getBigDecimal(1);
                                    Invoice inv = getInvoiceById(payment.getInvoiceId());
                                    if (inv != null && totalPaid != null && totalPaid.compareTo(inv.getTotalAmount()) >= 0) {
                                        updateInvoiceStatus(payment.getInvoiceId(), "Paid");
                                    }
                                }
                            }
                        }
                    }
                    connection.commit();
                    return rows > 0;
                }
            } catch (SQLException e) {
                try { connection.rollback(); } catch (SQLException ex) {}
                System.out.println("addPayment error: " + e.getMessage());
            } finally {
                try { connection.setAutoCommit(true); } catch (SQLException ex) {}
            }
        } catch (SQLException e) {
            System.out.println("Database connection error: " + e.getMessage());
        }
        return false;
    }

    private Invoice mapInvoice(ResultSet rs) throws SQLException {
        Invoice i = new Invoice();
        i.setInvoiceId(rs.getInt("invoice_id"));
        i.setInvoiceCode(rs.getString("invoice_code"));
        i.setVisitId(rs.getInt("visit_id"));
        i.setPatientId(rs.getInt("patient_id"));
        i.setSubtotal(rs.getBigDecimal("subtotal"));
        i.setDiscount(rs.getBigDecimal("discount"));
        i.setTotalAmount(rs.getBigDecimal("total_amount"));
        i.setStatus(rs.getString("status"));
        i.setCreatedBy(rs.getInt("created_by"));
        i.setCreatedAt(rs.getTimestamp("created_at"));
        
        i.setPatientName(rs.getString("patientName"));
        i.setPatientPhone(rs.getString("patientPhone"));
        i.setCreatedByName(rs.getString("createdByName"));
        return i;
    }
}
