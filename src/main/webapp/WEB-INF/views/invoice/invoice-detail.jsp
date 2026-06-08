<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="currentPage" value="invoices" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Chi Tiết Hóa Đơn - #${invoice.invoiceCode}" />
</jsp:include>

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
    <h2 style="color: var(--primary); margin: 0;"><i class="fa-solid fa-file-invoice"></i> Chi Tiết Hóa Đơn #${invoice.invoiceCode}</h2>
    <a href="${pageContext.request.contextPath}/invoices" class="btn btn-outline-secondary" style="width: auto;">
        <i class="fa-solid fa-arrow-left"></i> Quay lại
    </a>
</div>

<c:if test="${not empty msg}">
    <div class="alert alert-success" style="margin-bottom: 20px;">
        ${msg}
        <c:remove var="msg" scope="session"/>
    </div>
</c:if>

<div style="display: grid; grid-template-columns: 2fr 1fr; gap: 20px; align-items: start;">
    <!-- Invoice Info -->
    <div>
        <div class="card" style="padding: 20px; margin-bottom: 20px;">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                <div>
                    <h6 style="color: var(--text-secondary); margin-bottom: 5px;">Tên Bệnh Nhân</h6>
                    <div style="font-size: 1.25rem; font-weight: 600; color: var(--text-primary);">${invoice.patientName}</div>
                    <div style="color: var(--text-secondary); margin-top: 5px;"><i class="fa-solid fa-phone"></i> ${invoice.patientPhone}</div>
                </div>
                <div style="text-align: right;">
                    <h6 style="color: var(--text-secondary); margin-bottom: 5px;">Trạng Thái</h6>
                    <span style="padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 500; display: inline-block;
                        ${invoice.status == 'Paid' ? 'background: #dcfce7; color: #16a34a;' : 
                          (invoice.status == 'Unpaid' ? 'background: #fef3c7; color: #d97706;' : 
                          'background: #fee2e2; color: #dc2626;')}">
                        ${invoice.status == 'Paid' ? 'Đã thanh toán' : (invoice.status == 'Unpaid' ? 'Chưa thanh toán' : 'Đã hủy')}
                    </span>
                    <div style="color: var(--text-secondary); margin-top: 5px;"><i class="fa-regular fa-clock"></i> <fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                </div>
            </div>

            <h5 style="font-size: 1.1rem; font-weight: 600; color: var(--text-primary); border-bottom: 2px solid var(--border-color); padding-bottom: 10px; margin-bottom: 20px;">Dịch Vụ / Mặt Hàng</h5>
            <div style="overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="border-bottom: 2px solid var(--border-color); text-align: left; background: #f8fafc;">
                            <th style="padding: 12px; font-weight: 600; color: var(--text-secondary);">Mô Tả</th>
                            <th style="padding: 12px; font-weight: 600; color: var(--text-secondary); text-align: center;">SL</th>
                            <th style="padding: 12px; font-weight: 600; color: var(--text-secondary); text-align: right;">Đơn Giá</th>
                            <th style="padding: 12px; font-weight: 600; color: var(--text-secondary); text-align: right;">Thành Tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${items}">
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 12px; color: var(--text-primary);">${not empty item.serviceName ? item.serviceName : item.description}</td>
                                <td style="padding: 12px; text-align: center;">${item.quantity}</td>
                                <td style="padding: 12px; text-align: right;"><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                                <td style="padding: 12px; text-align: right; font-weight: 600;"><fmt:formatNumber value="${item.lineTotal}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3" style="padding: 12px; text-align: right; color: var(--text-secondary);">Tạm tính</td>
                            <td style="padding: 12px; text-align: right;"><fmt:formatNumber value="${invoice.subtotal}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                        </tr>
                        <tr>
                            <td colspan="3" style="padding: 12px; text-align: right; color: var(--text-secondary);">Giảm giá</td>
                            <td style="padding: 12px; text-align: right; color: var(--error);">-<fmt:formatNumber value="${invoice.discount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                        </tr>
                        <tr style="background: #f8fafc;">
                            <td colspan="3" style="padding: 15px 12px; text-align: right; font-weight: 600; font-size: 1.1rem;">Tổng Cộng</td>
                            <td style="padding: 15px 12px; text-align: right; font-weight: bold; color: var(--primary); font-size: 1.1rem;"><fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
        
        <div class="card" style="padding: 20px;">
            <h5 style="font-size: 1.1rem; font-weight: 600; color: var(--text-primary); border-bottom: 2px solid var(--border-color); padding-bottom: 10px; margin-bottom: 20px;">Lịch Sử Thanh Toán</h5>
            <c:if test="${empty payments}">
                <p style="color: var(--text-secondary); margin: 0;">Chưa có giao dịch thanh toán nào.</p>
            </c:if>
            <c:if test="${not empty payments}">
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr style="border-bottom: 2px solid var(--border-color); text-align: left; background: #f8fafc;">
                                <th style="padding: 12px; font-weight: 600; color: var(--text-secondary);">Ngày</th>
                                <th style="padding: 12px; font-weight: 600; color: var(--text-secondary);">Phương Thức</th>
                                <th style="padding: 12px; font-weight: 600; color: var(--text-secondary);">Mã GD</th>
                                <th style="padding: 12px; font-weight: 600; color: var(--text-secondary); text-align: right;">Số Tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:set var="totalPaid" value="0"/>
                            <c:forEach var="payment" items="${payments}">
                                <c:set var="totalPaid" value="${totalPaid + payment.amount}"/>
                                <tr style="border-bottom: 1px solid var(--border-color);">
                                    <td style="padding: 12px;"><fmt:formatDate value="${payment.paidAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                    <td style="padding: 12px;">${payment.paymentMethod == 'Cash' ? 'Tiền mặt' : (payment.paymentMethod == 'Bank Transfer' ? 'Chuyển khoản' : (payment.paymentMethod == 'Card' ? 'Thẻ' : payment.paymentMethod))}</td>
                                    <td style="padding: 12px;">${payment.transactionRef}</td>
                                    <td style="padding: 12px; text-align: right; color: var(--success); font-weight: 600;"><fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <th colspan="3" style="padding: 12px; text-align: right;">Tổng Đã Trả:</th>
                                <th style="padding: 12px; text-align: right; color: var(--success); font-weight: bold;"><fmt:formatNumber value="${totalPaid}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></th>
                            </tr>
                            <c:if test="${invoice.totalAmount - totalPaid > 0}">
                                <tr>
                                    <th colspan="3" style="padding: 12px; text-align: right; color: var(--error);">Còn Nợ:</th>
                                    <th style="padding: 12px; text-align: right; color: var(--error); font-weight: bold;"><fmt:formatNumber value="${invoice.totalAmount - totalPaid}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></th>
                                </tr>
                            </c:if>
                        </tfoot>
                    </table>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Payment Actions -->
    <div>
        <div class="card" style="padding: 20px; position: sticky; top: 20px;">
            <h5 style="font-size: 1.1rem; font-weight: 600; color: var(--text-primary); border-bottom: 2px solid var(--border-color); padding-bottom: 10px; margin-bottom: 20px;">Ghi Nhận Thanh Toán</h5>
            <c:if test="${invoice.status == 'Paid'}">
                <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Hóa đơn này đã được thanh toán đủ.</div>
            </c:if>
            <c:if test="${invoice.status == 'Cancelled'}">
                <div class="alert alert-error"><i class="fa-solid fa-circle-xmark"></i> Hóa đơn này đã bị hủy.</div>
            </c:if>
            <c:if test="${invoice.status == 'Unpaid'}">
                <form action="${pageContext.request.contextPath}/invoice-payment" method="POST" style="margin: 0;">
                    <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
                    
                    <c:set var="paidAmount" value="0"/>
                    <c:forEach var="p" items="${payments}">
                        <c:set var="paidAmount" value="${paidAmount + p.amount}"/>
                    </c:forEach>
                    <c:set var="remaining" value="${invoice.totalAmount - paidAmount}"/>

                    <div class="form-group" style="margin-bottom: 15px;">
                        <label style="display: block; margin-bottom: 5px; font-weight: 500; color: var(--text-secondary);">Số Tiền (VND)</label>
                        <input type="number" class="form-control" name="amount" value="${remaining}" max="${remaining}" step="0.01" required style="width: 100%; box-sizing: border-box;">
                    </div>
                    <div class="form-group" style="margin-bottom: 15px;">
                        <label style="display: block; margin-bottom: 5px; font-weight: 500; color: var(--text-secondary);">Phương Thức</label>
                        <select class="form-control" name="paymentMethod" required style="width: 100%; box-sizing: border-box;">
                            <option value="Cash">Tiền mặt</option>
                            <option value="Bank Transfer">Chuyển khoản</option>
                            <option value="Card">Thẻ</option>
                        </select>
                    </div>
                    <div class="form-group" style="margin-bottom: 20px;">
                        <label style="display: block; margin-bottom: 5px; font-weight: 500; color: var(--text-secondary);">Mã GD (Tuỳ chọn)</label>
                        <input type="text" class="form-control" name="transactionRef" placeholder="VD: TXN123456" style="width: 100%; box-sizing: border-box;">
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                        <i class="fa-solid fa-money-bill-wave"></i> Thanh Toán
                    </button>
                </form>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
