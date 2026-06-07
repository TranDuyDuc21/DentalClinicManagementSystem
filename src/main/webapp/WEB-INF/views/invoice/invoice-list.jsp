<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Invoice List</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .card { border: none; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .table th { background-color: #f1f3f5; font-weight: 600; color: #495057; }
        .badge-Unpaid { background-color: #ffc107; color: #000; }
        .badge-Paid { background-color: #198754; color: #fff; }
        .badge-Cancelled { background-color: #dc3545; color: #fff; }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-primary fw-bold"><i class="fas fa-file-invoice-dollar me-2"></i>Invoice Management</h2>
        <a href="invoice-create" class="btn btn-primary shadow-sm"><i class="fas fa-plus me-1"></i> Create Invoice</a>
    </div>

    <div class="card mb-4">
        <div class="card-body">
            <form action="invoices" method="GET" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label text-muted">Search Patient</label>
                    <input type="text" name="search" value="${search}" class="form-control" placeholder="Name, Phone, or Invoice Code">
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted">Status</label>
                    <select name="status" class="form-select">
                        <option value="">All Statuses</option>
                        <option value="Unpaid" ${status == 'Unpaid' ? 'selected' : ''}>Unpaid</option>
                        <option value="Paid" ${status == 'Paid' ? 'selected' : ''}>Paid</option>
                        <option value="Cancelled" ${status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted">Payment Method</label>
                    <select name="paymentMethod" class="form-select">
                        <option value="">All Methods</option>
                        <option value="Cash" ${paymentMethod == 'Cash' ? 'selected' : ''}>Cash</option>
                        <option value="Bank Transfer" ${paymentMethod == 'Bank Transfer' ? 'selected' : ''}>Bank Transfer</option>
                        <option value="Card" ${paymentMethod == 'Card' ? 'selected' : ''}>Card</option>
                    </select>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-secondary w-100"><i class="fas fa-filter me-1"></i> Filter</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead>
                        <tr>
                            <th class="ps-4">Invoice Code</th>
                            <th>Patient Name</th>
                            <th>Phone</th>
                            <th>Total Amount</th>
                            <th>Status</th>
                            <th>Created At</th>
                            <th class="text-end pe-4">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="invoice" items="${invoices}">
                            <tr>
                                <td class="ps-4 fw-bold text-primary">#${invoice.invoiceCode}</td>
                                <td>${invoice.patientName}</td>
                                <td>${invoice.patientPhone}</td>
                                <td><fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                                <td>
                                    <span class="badge badge-${invoice.status}">${invoice.status}</span>
                                </td>
                                <td><fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td class="text-end pe-4">
                                    <a href="invoice-detail?id=${invoice.invoiceId}" class="btn btn-sm btn-outline-primary">View</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty invoices}">
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">No invoices found.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
