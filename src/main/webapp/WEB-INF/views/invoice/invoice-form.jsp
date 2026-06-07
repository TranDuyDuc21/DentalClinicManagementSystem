<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${not empty invoice ? 'Update' : 'Create'} Invoice</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Inter', sans-serif; }
        .card { border: none; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .section-title { font-size: 1.1rem; font-weight: 600; color: #495057; border-bottom: 2px solid #e9ecef; padding-bottom: 0.5rem; margin-bottom: 1.5rem; }
    </style>
</head>
<body>
<div class="container mt-5 mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-primary fw-bold"><i class="fas fa-file-invoice me-2"></i>${not empty invoice ? 'Update' : 'Create New'} Invoice</h2>
        <a href="invoices" class="btn btn-outline-secondary"><i class="fas fa-arrow-left me-1"></i> Back to List</a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="card">
        <div class="card-body">
            <!-- Assuming a separate endpoint for update in the future, currently forwards to create -->
            <form action="${not empty invoice ? 'invoice-update' : 'invoice-create'}" method="POST" id="invoiceForm">
                <c:if test="${not empty invoice}">
                    <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
                </c:if>
                
                <h5 class="section-title">General Information</h5>
                <div class="row mb-4">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Patient ID</label>
                        <input type="number" class="form-control" name="patientId" required placeholder="Enter Patient ID" value="${invoice.patientId}">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Visit ID</label>
                        <input type="number" class="form-control" name="visitId" required placeholder="Enter Visit ID" value="${invoice.visitId}">
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mt-4 mb-3 border-bottom pb-2">
                    <h5 class="section-title border-bottom-0 mb-0">Services / Items</h5>
                    <button type="button" class="btn btn-sm btn-primary" onclick="addItem()"><i class="fas fa-plus me-1"></i> Add Item</button>
                </div>
                
                <div class="table-responsive">
                    <table class="table" id="itemsTable">
                        <thead class="table-light">
                            <tr>
                                <th>Description / Service Name</th>
                                <th style="width: 150px;">Quantity</th>
                                <th style="width: 200px;">Unit Price (VND)</th>
                                <th style="width: 200px;" class="text-end">Line Total (VND)</th>
                                <th style="width: 80px;" class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody id="itemsBody">
                            <c:if test="${not empty items}">
                                <c:forEach var="item" items="${items}">
                                    <tr>
                                        <td><input type="text" class="form-control" name="description[]" required value="${item.description}"></td>
                                        <td><input type="number" class="form-control qty" name="quantity[]" min="1" onchange="calcTotal()" required value="${item.quantity}"></td>
                                        <td><input type="number" class="form-control price" name="unitPrice[]" min="0" step="1000" onchange="calcTotal()" required value="${item.unitPrice}"></td>
                                        <td class="text-end line-total fw-bold align-middle">${item.lineTotal}</td>
                                        <td class="text-center align-middle">
                                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(this)"><i class="fas fa-trash"></i></button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty items}">
                                <tr>
                                    <td><input type="text" class="form-control" name="description[]" required></td>
                                    <td><input type="number" class="form-control qty" name="quantity[]" value="1" min="1" onchange="calcTotal()" required></td>
                                    <td><input type="number" class="form-control price" name="unitPrice[]" value="0" min="0" step="1000" onchange="calcTotal()" required></td>
                                    <td class="text-end line-total fw-bold align-middle">0</td>
                                    <td class="text-center align-middle">
                                        <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(this)"><i class="fas fa-trash"></i></button>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="3" class="text-end text-muted align-middle">Subtotal:</td>
                                <td class="text-end fw-bold align-middle" id="subtotalDisplay">0</td>
                                <td></td>
                            </tr>
                            <tr>
                                <td colspan="3" class="text-end text-muted align-middle">Discount (VND):</td>
                                <td><input type="number" class="form-control text-end" name="discount" id="discountInput" value="${not empty invoice ? invoice.discount : 0}" min="0" step="1000" onchange="calcTotal()"></td>
                                <td></td>
                            </tr>
                            <tr class="table-light">
                                <td colspan="3" class="text-end fw-bold fs-5 align-middle">Total Amount:</td>
                                <td class="text-end fw-bold text-primary fs-5 align-middle" id="totalDisplay">0</td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>

                <div class="text-end mt-4">
                    <button type="submit" class="btn btn-success btn-lg"><i class="fas fa-save me-2"></i>${not empty invoice ? 'Update' : 'Create'} Invoice</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function addItem() {
        const tbody = document.getElementById('itemsBody');
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td><input type="text" class="form-control" name="description[]" required></td>
            <td><input type="number" class="form-control qty" name="quantity[]" value="1" min="1" onchange="calcTotal()" required></td>
            <td><input type="number" class="form-control price" name="unitPrice[]" value="0" min="0" step="1000" onchange="calcTotal()" required></td>
            <td class="text-end line-total fw-bold align-middle">0</td>
            <td class="text-center align-middle">
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(this)"><i class="fas fa-trash"></i></button>
            </td>
        `;
        tbody.appendChild(tr);
    }

    function removeItem(btn) {
        btn.closest('tr').remove();
        calcTotal();
    }

    function calcTotal() {
        let subtotal = 0;
        const rows = document.querySelectorAll('#itemsBody tr');
        rows.forEach(row => {
            const qty = parseFloat(row.querySelector('.qty').value) || 0;
            const price = parseFloat(row.querySelector('.price').value) || 0;
            const lineTotal = qty * price;
            row.querySelector('.line-total').innerText = lineTotal.toLocaleString('vi-VN');
            subtotal += lineTotal;
        });

        document.getElementById('subtotalDisplay').innerText = subtotal.toLocaleString('vi-VN');
        
        const discount = parseFloat(document.getElementById('discountInput').value) || 0;
        let total = subtotal - discount;
        if(total < 0) total = 0;
        
        document.getElementById('totalDisplay').innerText = total.toLocaleString('vi-VN');
    }
    
    // Initial calculation on load
    window.onload = function() {
        calcTotal();
    };
</script>
<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
