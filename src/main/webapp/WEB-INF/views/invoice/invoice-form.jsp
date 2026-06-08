<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="currentPage" value="invoices" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="${not empty invoice ? 'Cập Nhật' : 'Tạo'} Hóa Đơn" />
</jsp:include>

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
    <h2 style="color: var(--primary); margin: 0;"><i class="fa-solid fa-file-invoice"></i> ${not empty invoice ? 'Cập Nhật' : 'Tạo Mới'} Hóa Đơn</h2>
    <a href="${pageContext.request.contextPath}/invoices" class="btn btn-outline-secondary" style="width: auto;">
        <i class="fa-solid fa-arrow-left"></i> Quay lại
    </a>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-error" style="margin-bottom: 20px;">${error}</div>
</c:if>

<div class="card" style="padding: 20px;">
    <form action="${pageContext.request.contextPath}/${not empty invoice ? 'invoice-update' : 'invoice-create'}" method="POST" id="invoiceForm">
        <c:if test="${not empty invoice}">
            <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
        </c:if>
        
        <h5 style="font-size: 1.1rem; font-weight: 600; color: var(--text-primary); border-bottom: 2px solid var(--border-color); padding-bottom: 10px; margin-bottom: 20px;">Thông Tin Chung</h5>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px;">
            <div class="form-group">
                <label style="display: block; margin-bottom: 5px; font-weight: 500; color: var(--text-secondary);">ID Bệnh Nhân</label>
                <input type="number" class="form-control" name="patientId" required placeholder="Nhập ID Bệnh Nhân" value="${invoice.patientId}" style="width: 100%; box-sizing: border-box;">
            </div>
            <div class="form-group">
                <label style="display: block; margin-bottom: 5px; font-weight: 500; color: var(--text-secondary);">ID Lần Khám (Visit ID)</label>
                <input type="number" class="form-control" name="visitId" required placeholder="Nhập ID Lần Khám" value="${invoice.visitId}" style="width: 100%; box-sizing: border-box;">
            </div>
        </div>

        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid var(--border-color); padding-bottom: 10px; margin-bottom: 20px;">
            <h5 style="font-size: 1.1rem; font-weight: 600; color: var(--text-primary); margin: 0;">Dịch Vụ / Mặt Hàng</h5>
            <button type="button" class="btn btn-primary" onclick="addItem()" style="width: auto; padding: 6px 12px; font-size: 0.9rem;">
                <i class="fa-solid fa-plus"></i> Thêm Mặt Hàng
            </button>
        </div>
        
        <div style="overflow-x: auto; margin-bottom: 30px;">
            <table style="width: 100%; border-collapse: collapse; min-width: 800px;" id="itemsTable">
                <thead>
                    <tr style="border-bottom: 2px solid var(--border-color); text-align: left; background: #f8fafc;">
                        <th style="padding: 12px; font-weight: 600; color: var(--text-secondary);">Mô Tả / Tên Dịch Vụ</th>
                        <th style="padding: 12px; font-weight: 600; color: var(--text-secondary); width: 120px;">Số Lượng</th>
                        <th style="padding: 12px; font-weight: 600; color: var(--text-secondary); width: 180px;">Đơn Giá (VND)</th>
                        <th style="padding: 12px; font-weight: 600; color: var(--text-secondary); width: 180px; text-align: right;">Thành Tiền (VND)</th>
                        <th style="padding: 12px; font-weight: 600; color: var(--text-secondary); width: 80px; text-align: center;">Xóa</th>
                    </tr>
                </thead>
                <tbody id="itemsBody">
                    <c:if test="${not empty items}">
                        <c:forEach var="item" items="${items}">
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 10px;"><input type="text" class="form-control" name="description[]" required value="${item.description}" style="width: 100%; box-sizing: border-box;"></td>
                                <td style="padding: 10px;"><input type="number" class="form-control qty" name="quantity[]" min="1" onchange="calcTotal()" required value="${item.quantity}" style="width: 100%; box-sizing: border-box;"></td>
                                <td style="padding: 10px;"><input type="number" class="form-control price" name="unitPrice[]" min="0" step="1000" onchange="calcTotal()" required value="${item.unitPrice}" style="width: 100%; box-sizing: border-box;"></td>
                                <td style="padding: 10px; text-align: right; font-weight: 600; color: var(--text-primary);" class="line-total">${item.lineTotal}</td>
                                <td style="padding: 10px; text-align: center;">
                                    <button type="button" class="btn" style="background: var(--error); color: white; padding: 6px 10px; min-width: auto; width: auto;" onclick="removeItem(this)"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty items}">
                        <tr style="border-bottom: 1px solid var(--border-color);">
                            <td style="padding: 10px;"><input type="text" class="form-control" name="description[]" required style="width: 100%; box-sizing: border-box;"></td>
                            <td style="padding: 10px;"><input type="number" class="form-control qty" name="quantity[]" value="1" min="1" onchange="calcTotal()" required style="width: 100%; box-sizing: border-box;"></td>
                            <td style="padding: 10px;"><input type="number" class="form-control price" name="unitPrice[]" value="0" min="0" step="1000" onchange="calcTotal()" required style="width: 100%; box-sizing: border-box;"></td>
                            <td style="padding: 10px; text-align: right; font-weight: 600; color: var(--text-primary);" class="line-total">0</td>
                            <td style="padding: 10px; text-align: center;">
                                <button type="button" class="btn" style="background: var(--error); color: white; padding: 6px 10px; min-width: auto; width: auto;" onclick="removeItem(this)"><i class="fa-solid fa-trash"></i></button>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3" style="padding: 12px; text-align: right; color: var(--text-secondary);">Tạm tính:</td>
                        <td style="padding: 12px; text-align: right; font-weight: 600; color: var(--text-primary);" id="subtotalDisplay">0</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td colspan="3" style="padding: 12px; text-align: right; color: var(--text-secondary);">Giảm giá (VND):</td>
                        <td style="padding: 10px;">
                            <input type="number" class="form-control" name="discount" id="discountInput" value="${not empty invoice ? invoice.discount : 0}" min="0" step="1000" onchange="calcTotal()" style="width: 100%; box-sizing: border-box; text-align: right;">
                        </td>
                        <td></td>
                    </tr>
                    <tr style="background: #f8fafc;">
                        <td colspan="3" style="padding: 15px 12px; text-align: right; font-weight: 600; font-size: 1.1rem;">Tổng Cộng:</td>
                        <td style="padding: 15px 12px; text-align: right; font-weight: bold; color: var(--primary); font-size: 1.1rem;" id="totalDisplay">0</td>
                        <td></td>
                    </tr>
                </tfoot>
            </table>
        </div>

        <div style="text-align: right;">
            <button type="submit" class="btn btn-primary" style="width: auto;">
                <i class="fa-solid fa-save"></i> ${not empty invoice ? 'Cập Nhật' : 'Lưu'} Hóa Đơn
            </button>
        </div>
    </form>
</div>

<script>
    function addItem() {
        const tbody = document.getElementById('itemsBody');
        const tr = document.createElement('tr');
        tr.style.borderBottom = "1px solid var(--border-color)";
        tr.innerHTML = `
            <td style="padding: 10px;"><input type="text" class="form-control" name="description[]" required style="width: 100%; box-sizing: border-box;"></td>
            <td style="padding: 10px;"><input type="number" class="form-control qty" name="quantity[]" value="1" min="1" onchange="calcTotal()" required style="width: 100%; box-sizing: border-box;"></td>
            <td style="padding: 10px;"><input type="number" class="form-control price" name="unitPrice[]" value="0" min="0" step="1000" onchange="calcTotal()" required style="width: 100%; box-sizing: border-box;"></td>
            <td style="padding: 10px; text-align: right; font-weight: 600; color: var(--text-primary);" class="line-total">0</td>
            <td style="padding: 10px; text-align: center;">
                <button type="button" class="btn" style="background: var(--error); color: white; padding: 6px 10px; min-width: auto; width: auto;" onclick="removeItem(this)"><i class="fa-solid fa-trash"></i></button>
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

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
