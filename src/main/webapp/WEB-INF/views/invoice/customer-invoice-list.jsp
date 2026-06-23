<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="currentPage" value="customer-invoices" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Hóa Đơn Của Tôi" />
</jsp:include>

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
    <h2 style="color: var(--primary); margin: 0;">Hóa Đơn Của Tôi</h2>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-error" style="margin-bottom: 20px;">
        ${error}
        <c:remove var="error" scope="session"/>
    </div>
</c:if>
<c:if test="${not empty msg}">
    <div class="alert alert-success" style="margin-bottom: 20px;">
        ${msg}
        <c:remove var="msg" scope="session"/>
    </div>
</c:if>

<div class="card" style="padding: 20px;">
    <div style="overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr style="border-bottom: 2px solid var(--border-color); text-align: left;">
                    <th style="padding: 12px; font-weight: 600; color: var(--text-secondary);">Mã HĐ</th>
                    <th style="padding: 12px; font-weight: 600; color: var(--text-secondary);">Tên Bệnh Nhân</th>
                    <th style="padding: 12px; font-weight: 600; color: var(--text-secondary);">Ngày Tạo</th>
                    <th style="padding: 12px; font-weight: 600; color: var(--text-secondary); text-align: right;">Tổng Tiền</th>
                    <th style="padding: 12px; font-weight: 600; color: var(--text-secondary); text-align: center;">Trạng Thái</th>
                    <th style="padding: 12px; font-weight: 600; color: var(--text-secondary); text-align: center;">Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty invoices}">
                    <tr>
                        <td colspan="6" style="padding: 20px; text-align: center; color: var(--text-secondary);">Bạn chưa có hóa đơn nào.</td>
                    </tr>
                </c:if>
                <c:forEach var="invoice" items="${invoices}">
                    <tr style="border-bottom: 1px solid var(--border-color);">
                        <td style="padding: 12px;"><strong>#${invoice.invoiceCode}</strong></td>
                        <td style="padding: 12px;">${invoice.patientName}</td>
                        <td style="padding: 12px;"><fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td style="padding: 12px; text-align: right; font-weight: bold; color: var(--primary);">
                            <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/>
                        </td>
                        <td style="padding: 12px; text-align: center;">
                            <span style="padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 500; display: inline-block;
                                ${invoice.status == 'Paid' ? 'background: #dcfce7; color: #16a34a;' : 
                                  (invoice.status == 'Unpaid' ? 'background: #fef3c7; color: #d97706;' : 
                                  'background: #fee2e2; color: #dc2626;')}">
                                ${invoice.status == 'Paid' ? 'Đã thanh toán' : (invoice.status == 'Unpaid' ? 'Chưa thanh toán' : 'Đã hủy')}
                            </span>
                        </td>
                        <td style="padding: 12px; text-align: center;">
                            <a href="${pageContext.request.contextPath}/invoice-detail?id=${invoice.invoiceId}" class="btn btn-outline-primary" style="padding: 5px 10px; font-size: 0.9rem;">
                                <i class="fa-solid fa-eye"></i> Xem Chi Tiết
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <div style="display: flex; justify-content: center; gap: 5px; margin-top: 20px;">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="${pageContext.request.contextPath}/customer-invoices?page=${i}" 
                   class="btn ${i == pageNumber ? 'btn-primary' : 'btn-outline-secondary'}" 
                   style="padding: 5px 12px;">${i}</a>
            </c:forEach>
        </div>
    </c:if>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
