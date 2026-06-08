<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="currentPage" value="invoices" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Quản Lý Hóa Đơn" />
</jsp:include>

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
    <h2 style="color: var(--primary); margin: 0;"><i class="fa-solid fa-file-invoice-dollar"></i> Quản Lý Hóa Đơn</h2>
    <a href="${pageContext.request.contextPath}/invoice-create" class="btn btn-primary" style="width: auto;">
        <i class="fa-solid fa-plus"></i> Tạo Hóa Đơn
    </a>
</div>

<t:searchFilter actionUrl="${pageContext.request.contextPath}/invoices" searchPlaceholder="Tìm theo Tên bệnh nhân, SĐT, hoặc Mã HĐ..." searchValue="${param.search}">
    <div style="width: 200px;">
        <select name="status" class="form-control" style="width: 100%; box-sizing: border-box;">
            <option value="">-- Tất cả trạng thái --</option>
            <option value="Unpaid" ${param.status == 'Unpaid' ? 'selected' : ''}>Chưa thanh toán</option>
            <option value="Paid" ${param.status == 'Paid' ? 'selected' : ''}>Đã thanh toán</option>
            <option value="Cancelled" ${param.status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
        </select>
    </div>
    <div style="width: 200px;">
        <select name="paymentMethod" class="form-control" style="width: 100%; box-sizing: border-box;">
            <option value="">-- Tất cả phương thức --</option>
            <option value="Cash" ${param.paymentMethod == 'Cash' ? 'selected' : ''}>Tiền mặt</option>
            <option value="Bank Transfer" ${param.paymentMethod == 'Bank Transfer' ? 'selected' : ''}>Chuyển khoản</option>
            <option value="Card" ${param.paymentMethod == 'Card' ? 'selected' : ''}>Thẻ</option>
        </select>
    </div>
</t:searchFilter>

<div class="card" style="padding: 20px;">
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success" style="margin-bottom: 20px;">
            ${sessionScope.successMessage}
            <c:remove var="successMessage" scope="session" />
        </div>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-error" style="margin-bottom: 20px;">
            ${sessionScope.errorMessage}
            <c:remove var="errorMessage" scope="session" />
        </div>
    </c:if>

    <div style="overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse; min-width: 800px;">
            <thead>
                <tr style="border-bottom: 2px solid var(--border-color); text-align: left; background: #f8fafc;">
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Mã HĐ</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Tên Bệnh Nhân</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">SĐT</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Tổng Tiền</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Trạng Thái</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Ngày Tạo</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); text-align: left;">Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="invoice" items="${invoices}">
                    <tr style="border-bottom: 1px solid var(--border-color); transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#f1f5f9'" onmouseout="this.style.backgroundColor='transparent'">
                        <td style="padding: 12px; font-weight: bold; color: var(--primary);">#${invoice.invoiceCode}</td>
                        <td style="padding: 12px; font-weight: 500; color: var(--text-primary);">${invoice.patientName}</td>
                        <td style="padding: 12px;">${invoice.patientPhone}</td>
                        <td style="padding: 12px;"><fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="VND" maxFractionDigits="0"/></td>
                        <td style="padding: 12px;">
                            <span style="padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 500; 
                                ${invoice.status == 'Paid' ? 'background: #dcfce7; color: #16a34a;' : 
                                  (invoice.status == 'Unpaid' ? 'background: #fef3c7; color: #d97706;' : 
                                  'background: #fee2e2; color: #dc2626;')}">
                                ${invoice.status == 'Paid' ? 'Đã thanh toán' : (invoice.status == 'Unpaid' ? 'Chưa thanh toán' : 'Đã hủy')}
                            </span>
                        </td>
                        <td style="padding: 12px;"><fmt:formatDate value="${invoice.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td style="padding: 12px; text-align: left;">
                            <div style="display: flex; gap: 15px; justify-content: flex-start; align-items: center;">
                                <a href="${pageContext.request.contextPath}/invoice-detail?id=${invoice.invoiceId}" style="color: #6366f1; text-decoration: none; font-weight: 600; font-size: 0.9rem; padding: 6px 0;">
                                    <i class="fa-solid fa-eye"></i> Xem
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty invoices}">
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 30px; color: var(--text-secondary);">
                            Không có dữ liệu hóa đơn nào.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
