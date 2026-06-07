<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Invoice Detail - #${invoice.invoiceCode}</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .card { border: none; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .badge-Unpaid { background-color: #ffc107; color: #000; }
        .badge-Paid { background-color: #198754; color: #fff; }
        .badge-Cancelled { background-color: #dc3545; color: #fff; }
        .section-title { font-size: 1.1rem; font-weight: 600; color: #495057; border-bottom: 2px solid #e9ecef; padding-bottom: 0.5rem; margin-bottom: 1.5rem; }
    </style>
</head>
<body>
<div class="container mt-5 mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-primary fw-bold"><i class="fas fa-file-invoice me-2"></i>Invoice #${invoice.invoiceCode}</h2>
        <a href="invoices" class="btn btn-outline-secondary"><i class="fas fa-arrow-left me-1"></i> Back to List</a>
    </div>

    <c:if test="${not empty msg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${msg} <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="msg" scope="session"/>
    </c:if>

    <div class="row">
        <!-- Invoice Info -->
        <div class="col-md-8">
            <div class="card mb-4">
                <div class="card-body">
                    <div class="row mb-4">
                        <div class="col-sm-6">
                            <h6 class="text-muted mb-1">Patient Name</h6>
                            <div class="fw-bold fs-5">${invoice.patientName}</div>
                            <div class="text-muted"><i class="fas fa-phone me-1"></i> ${invoice.patientPhone}</div>
                        </div>
                        <div class="col-sm-6 text-sm-end">
                            <h6 class="text-muted mb-1">Status</h6>
                            <span class="badge badge-${invoice.status} fs-6">${invoice.status}</span>
                            <div class="text-muted mt-2"><i class="far fa-clock me-1"></i> <fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                        </div>
                    </div>

                    <h5 class="section-title mt-4">Services / Items</h5>
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead class="table-light">
                                <tr>
                                    <th>Description</th>
                                    <th class="text-center">Qty</th>
                                    <th class="text-end">Unit Price</th>
                                    <th class="text-end">Line Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${items}">
                                    <tr>
                                        <td>${not empty item.serviceName ? item.serviceName : item.description}</td>
                                        <td class="text-center">${item.quantity}</td>
                                        <td class="text-end"><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                                        <td class="text-end fw-bold"><fmt:formatNumber value="${item.lineTotal}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="3" class="text-end text-muted">Subtotal</td>
                                    <td class="text-end"><fmt:formatNumber value="${invoice.subtotal}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                                </tr>
                                <tr>
                                    <td colspan="3" class="text-end text-muted">Discount</td>
                                    <td class="text-end text-danger">-<fmt:formatNumber value="${invoice.discount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                                </tr>
                                <tr class="table-light">
                                    <td colspan="3" class="text-end fw-bold fs-5">Total Amount</td>
                                    <td class="text-end fw-bold text-primary fs-5"><fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-body">
                    <h5 class="section-title">Payment History</h5>
                    <c:if test="${empty payments}">
                        <p class="text-muted mb-0">No payments recorded yet.</p>
                    </c:if>
                    <c:if test="${not empty payments}">
                        <div class="table-responsive">
                            <table class="table table-sm">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Method</th>
                                        <th>Transaction Ref</th>
                                        <th>Amount</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="totalPaid" value="0"/>
                                    <c:forEach var="payment" items="${payments}">
                                        <c:set var="totalPaid" value="${totalPaid + payment.amount}"/>
                                        <tr>
                                            <td><fmt:formatDate value="${payment.paidAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>${payment.paymentMethod}</td>
                                            <td>${payment.transactionRef}</td>
                                            <td class="text-success fw-bold"><fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <th colspan="3" class="text-end">Total Paid:</th>
                                        <th class="text-success fs-6"><fmt:formatNumber value="${totalPaid}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></th>
                                    </tr>
                                    <c:if test="${invoice.totalAmount - totalPaid > 0}">
                                        <tr>
                                            <th colspan="3" class="text-end text-danger">Remaining Balance:</th>
                                            <th class="text-danger fs-6"><fmt:formatNumber value="${invoice.totalAmount - totalPaid}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></th>
                                        </tr>
                                    </c:if>
                                </tfoot>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Payment Actions -->
        <div class="col-md-4">
            <div class="card sticky-top" style="top: 2rem;">
                <div class="card-body">
                    <h5 class="section-title">Record Payment</h5>
                    <c:if test="${invoice.status == 'Paid'}">
                        <div class="alert alert-success"><i class="fas fa-check-circle me-2"></i> This invoice has been fully paid.</div>
                    </c:if>
                    <c:if test="${invoice.status == 'Cancelled'}">
                        <div class="alert alert-danger"><i class="fas fa-times-circle me-2"></i> This invoice is cancelled.</div>
                    </c:if>
                    <c:if test="${invoice.status == 'Unpaid'}">
                        <form action="invoice-payment" method="POST">
                            <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
                            
                            <!-- Calculate remaining -->
                            <c:set var="paidAmount" value="0"/>
                            <c:forEach var="p" items="${payments}">
                                <c:set var="paidAmount" value="${paidAmount + p.amount}"/>
                            </c:forEach>
                            <c:set var="remaining" value="${invoice.totalAmount - paidAmount}"/>

                            <div class="mb-3">
                                <label class="form-label">Payment Amount</label>
                                <div class="input-group">
                                    <input type="number" class="form-control" name="amount" value="${remaining}" max="${remaining}" step="0.01" required>
                                    <span class="input-group-text">VND</span>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Payment Method</label>
                                <select class="form-select" name="paymentMethod" required>
                                    <option value="Cash">Cash</option>
                                    <option value="Bank Transfer">Bank Transfer</option>
                                    <option value="Card">Card</option>
                                </select>
                            </div>
                            <div class="mb-4">
                                <label class="form-label">Transaction Ref (Optional)</label>
                                <input type="text" class="form-control" name="transactionRef" placeholder="e.g. TXN123456">
                            </div>
                            <button type="submit" class="btn btn-success w-100"><i class="fas fa-money-bill-wave me-2"></i>Submit Payment</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
