<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="currentPage" value="appointments" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Quản Lý Lịch Khám" />
</jsp:include>

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
    <h2 style="color: var(--primary); margin: 0;"><i class="fa-solid fa-calendar-check"></i> Danh Sách Lịch Khám</h2>
    <a href="#" class="btn btn-primary" style="width: auto;">
        <i class="fa-solid fa-plus"></i> Đặt Lịch Mới
    </a>
</div>

<t:searchFilter actionUrl="${pageContext.request.contextPath}/appointments" searchPlaceholder="Tìm theo Tên bệnh nhân, SĐT, Bác sĩ..." searchValue="${param.search}">
    <select name="status" class="form-control" onchange="this.form.submit()" style="width: 200px;">
        <option value="All" ${currentStatus == 'All' ? 'selected' : ''}>Tất Cả Trạng Thái</option>
        <option value="New" ${currentStatus == 'New' ? 'selected' : ''}>Mới (New)</option>
        <option value="Waiting" ${currentStatus == 'Waiting' ? 'selected' : ''}>Chờ Khám (Waiting)</option>
        <option value="In Exam" ${currentStatus == 'In Exam' ? 'selected' : ''}>Đang Khám (In Exam)</option>
        <option value="Done" ${currentStatus == 'Done' ? 'selected' : ''}>Đã Xong (Done)</option>
        <option value="Cancelled" ${currentStatus == 'Cancelled' ? 'selected' : ''}>Đã Hủy (Cancelled)</option>
    </select>
</t:searchFilter>

<div class="card" style="padding: 0;">
    <div style="overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse; min-width: 1000px;">
            <thead>
                <tr style="border-bottom: 2px solid var(--border-color); text-align: left; background: #f8fafc;">
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Mã Lịch</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Bệnh Nhân</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">SĐT</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Bác Sĩ</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Dịch Vụ</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Giờ Hẹn</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Trạng Thái</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); text-align: left;">Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="appt" items="${appointments}">
                    <tr style="border-bottom: 1px solid var(--border-color); transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#f8fafc'" onmouseout="this.style.backgroundColor='transparent'">
                        <td style="padding: 12px; font-weight: 500; color: var(--text-primary);">#${appt.appointmentId}</td>
                        <td style="padding: 12px; color: var(--text-primary); font-weight: 500;">${appt.patientName}</td>
                        <td style="padding: 12px; color: var(--text-secondary); font-size: 0.95rem;">${appt.patientPhone}</td>
                        <td style="padding: 12px; color: var(--text-secondary);">${appt.doctorName}</td>
                        <td style="padding: 12px; color: var(--text-secondary); max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${appt.serviceName}">${empty appt.serviceName ? 'Khám / Tư Vấn' : appt.serviceName}</td>
                        <td style="padding: 12px; color: var(--text-primary); font-weight: 500;">
                            <fmt:formatDate value="${appt.scheduledDatetime}" pattern="HH:mm - dd/MM/yyyy"/>
                        </td>
                        <td style="padding: 12px;">
                            <c:choose>
                                <c:when test="${appt.status == 'Done'}">
                                    <span style="padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 500; background: #dcfce7; color: #16a34a;">Hoàn thành</span>
                                </c:when>
                                <c:when test="${appt.status == 'New' || appt.status == 'Waiting'}">
                                    <span style="padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 500; background: #dbeafe; color: #2563eb;">Chờ khám</span>
                                </c:when>
                                <c:when test="${appt.status == 'In Exam' || appt.status == 'Imaging/Testing'}">
                                    <span style="padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 500; background: #fef3c7; color: #d97706;">Đang xử lý</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 500; background: #fee2e2; color: #dc2626;">Đã hủy</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="padding: 12px; text-align: left;">
                            <div style="display: flex; gap: 10px; justify-content: flex-start; align-items: center;">
                                <c:choose>
                                    <c:when test="${appt.status == 'Done' && not empty appt.visitId && (empty appt.invoiceId || appt.invoiceStatus == 'Unpaid')}">
                                        <a href="${pageContext.request.contextPath}/invoice-create?visitId=${appt.visitId}" 
                                           class="btn btn-primary" 
                                           style="padding: 6px 12px; font-size: 0.85rem; width: auto; background-color: var(--success); border-color: var(--success);">
                                            <i class="fa-solid fa-file-invoice-dollar"></i> Tạo Hóa Đơn
                                        </a>
                                    </c:when>
                                    <c:when test="${not empty appt.invoiceId && appt.invoiceStatus != 'Unpaid'}">
                                        <a href="${pageContext.request.contextPath}/invoice-detail?id=${appt.invoiceId}" 
                                           class="btn btn-outline-secondary" 
                                           style="padding: 6px 12px; font-size: 0.85rem; width: auto; color: var(--text-secondary); border-color: #d1d5db;" title="Đã có hóa đơn">
                                            <i class="fa-solid fa-check-double"></i> Xem HĐ
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-outline-secondary" style="padding: 6px 12px; font-size: 0.85rem; width: auto;" disabled title="Chỉ tạo được hóa đơn khi đã hoàn thành khám">
                                            <i class="fa-solid fa-file-invoice-dollar"></i> Tạo Hóa Đơn
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                                <a href="#" class="btn btn-outline-secondary" style="padding: 6px 10px; min-width: auto; width: auto;" title="Chi tiết">
                                    <i class="fa-solid fa-eye"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty appointments}">
                    <tr>
                        <td colspan="8" style="text-align: center; padding: 30px; color: var(--text-secondary);">
                            Không có dữ liệu lịch khám nào.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
