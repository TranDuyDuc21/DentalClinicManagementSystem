<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="currentPage" value="appointments" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Lịch Hẹn Của Tôi" />
</jsp:include>

<jsp:include page="/WEB-INF/views/components/messages.jsp" />

<!-- Premium Scientific Styling for Customer Appointment List -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer-premium.css">

<style>
    /* Styling cho Layout Danh sách Lịch hẹn */
    .appointment-page-container {
        width: 100%;
        margin: 40px 0;
        padding: 0;
    }
    
    .page-header {
        text-align: center;
        margin-bottom: 40px;
    }
    
    .page-header h1 {
        font-size: 2.2rem;
        font-weight: 700;
        color: var(--color-primary-dark);
        margin-bottom: 10px;
    }
    
    .page-header p {
        color: var(--color-text-muted);
        font-size: 1.1rem;
    }
    
    .appointment-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 25px;
        margin-top: 30px;
    }
    
    .appointment-card {
        background: #fff;
        border-radius: var(--radius-xl);
        box-shadow: var(--shadow-md);
        padding: 25px;
        border: 1px solid #e2e8f0;
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
    }
    
    .appointment-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--shadow-xl);
        border-color: var(--color-primary-light);
    }
    
    /* Decoration Line */
    .appointment-card::before {
        content: '';
        position: absolute;
        top: 0; left: 0; width: 100%; height: 5px;
        background: var(--color-primary-gradient);
    }
    
    .status-badge {
        position: absolute;
        top: 20px;
        right: 20px;
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 0.8rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    
    .status-badge.new { background: #dbeafe; color: #1e40af; }
    .status-badge.waiting { background: #e0e7ff; color: #3730a3; }
    .status-badge.in-exam { background: #fef3c7; color: #b45309; }
    .status-badge.done { background: #dcfce7; color: #166534; }
    .status-badge.cancelled { background: #fee2e2; color: #991b1b; }
    
    .appt-date {
        font-size: 1.3rem;
        font-weight: 800;
        color: var(--color-primary-dark);
        margin-bottom: 5px;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .appt-service {
        font-size: 1.1rem;
        font-weight: 600;
        color: var(--color-text-main);
        margin-bottom: 15px;
        line-height: 1.4;
    }
    
    .appt-info-row {
        display: flex;
        align-items: flex-start;
        gap: 10px;
        margin-bottom: 12px;
        font-size: 0.95rem;
        color: var(--color-text-muted);
    }
    
    .appt-info-row i {
        color: var(--color-primary);
        margin-top: 3px;
    }
    
    .appt-actions {
        display: flex;
        gap: 10px;
        margin-top: 25px;
        padding-top: 20px;
        border-top: 1px dashed #e2e8f0;
    }
    
    .btn-appt {
        flex: 1;
        padding: 10px;
        border-radius: 12px;
        font-weight: 600;
        text-align: center;
        cursor: pointer;
        transition: all 0.2s ease;
        border: none;
        font-size: 0.9rem;
    }
    
    .btn-reschedule {
        background: var(--color-primary-light);
        color: var(--color-primary-dark);
    }
    
    .btn-reschedule:hover {
        background: var(--color-primary);
        color: #fff;
    }
    
    .btn-cancel {
        background: #fee2e2;
        color: #b91c1c;
    }
    
    .btn-cancel:hover {
        background: #f87171;
        color: #fff;
    }
    
    .no-data {
        text-align: center;
        padding: 50px 20px;
        background: #fff;
        border-radius: var(--radius-xl);
        box-shadow: var(--shadow-md);
        grid-column: 1 / -1;
    }
    
    .no-data i {
        font-size: 4rem;
        color: #cbd5e1;
        margin-bottom: 20px;
    }
</style>

<div class="appointment-page-container">
    <div class="page-header">
        <h1>Lịch Hẹn Của Tôi</h1>
        <p>Quản lý các lịch khám nha khoa của bạn một cách dễ dàng và khoa học.</p>
    </div>
    
    <!-- Bộ lọc -->
    <t:searchFilter actionUrl="${pageContext.request.contextPath}/appointments" searchPlaceholder="Tìm theo Dịch vụ, Tên bác sĩ..." searchValue="${param.search}">
        <select name="doctorId" class="form-control" onchange="this.form.submit()" style="width: auto; min-width: 150px;">
            <option value="">-- Tất Cả Tên Bác Sĩ --</option>
            <c:forEach var="doc" items="${doctors}">
                <option value="${doc.doctorId}" ${param.doctorId == doc.doctorId ? 'selected' : ''}>${doc.fullName}</option>
            </c:forEach>
        </select>
        
        <input type="date" name="filterDate" class="form-control" value="${param.filterDate}" onchange="this.form.submit()" style="width: 150px;">

        <select name="status" class="form-control" onchange="this.form.submit()" style="width: auto; min-width: 160px;">
            <option value="All" ${currentStatus == 'All' ? 'selected' : ''}>Tất Cả Trạng Thái</option>
            <option value="New" ${currentStatus == 'New' ? 'selected' : ''}>Sắp tới (Mới)</option>
            <option value="Waiting" ${currentStatus == 'Waiting' ? 'selected' : ''}>Đang chờ khám</option>
            <option value="In Exam" ${currentStatus == 'In Exam' ? 'selected' : ''}>Đang khám</option>
            <option value="Done" ${currentStatus == 'Done' ? 'selected' : ''}>Đã Hoàn Thành</option>
            <option value="Cancelled" ${currentStatus == 'Cancelled' ? 'selected' : ''}>Đã Hủy</option>
        </select>
    </t:searchFilter>

    <div class="appointment-grid">
        <c:forEach var="appt" items="${appointments}">
            <div class="appointment-card">
                <!-- Trạng thái -->
                <c:choose>
                    <c:when test="${appt.status == 'New'}">
                        <span class="status-badge new">Sắp tới</span>
                    </c:when>
                    <c:when test="${appt.status == 'Waiting'}">
                        <span class="status-badge waiting">Chờ khám</span>
                    </c:when>
                    <c:when test="${appt.status == 'In Exam'}">
                        <span class="status-badge in-exam">Đang khám</span>
                    </c:when>
                    <c:when test="${appt.status == 'Done'}">
                        <span class="status-badge done">Hoàn thành</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge cancelled">Đã hủy</span>
                    </c:otherwise>
                </c:choose>

                <!-- Giờ khám -->
                <div class="appt-date">
                    <i class="fa-regular fa-clock"></i> 
                    <fmt:formatDate value="${appt.scheduledDatetime}" pattern="HH:mm"/> 
                    <span style="font-size: 0.9rem; font-weight: 500; color: var(--color-text-muted); margin-left: 5px;">
                        <fmt:formatDate value="${appt.scheduledDatetime}" pattern="dd/MM/yyyy"/>
                    </span>
                </div>
                
                <!-- Dịch vụ -->
                <div class="appt-service">
                    ${empty appt.serviceName ? 'Khám và Tư Vấn' : appt.serviceName}
                </div>
                
                <!-- Bác sĩ -->
                <div class="appt-info-row">
                    <i class="fa-solid fa-user-doctor"></i>
                    <div>
                        <strong>Bác sĩ phụ trách:</strong><br/>
                        ${appt.doctorName}
                    </div>
                </div>
                
                <!-- Nguồn -->
                <div class="appt-info-row">
                    <i class="fa-solid fa-globe"></i>
                    <div>
                        <strong>Kênh đặt lịch:</strong> ${appt.bookingSource}
                    </div>
                </div>

                <!-- Hành động (Chỉ hiện nếu lịch chưa diễn ra hoặc có hóa đơn, bệnh án) -->
                <c:if test="${appt.status == 'New' || appt.status == 'Waiting' || (not empty appt.invoiceId && appt.invoiceId > 0) || (not empty appt.visitId && appt.visitId > 0)}">
                    <div class="appt-actions" style="${(appt.status != 'New' && appt.status != 'Waiting') ? 'display: flex; gap: 10px;' : ''}">
                        <c:if test="${appt.status == 'New' || appt.status == 'Waiting'}">
                            <a href="${pageContext.request.contextPath}/reschedule-appointment?appointmentId=${appt.appointmentId}&serviceId=${appt.serviceId}&doctorId=${appt.doctorId}" class="btn-appt btn-reschedule" style="display: inline-block; text-decoration: none;">
                                <i class="fa-solid fa-calendar-days"></i> Đổi Lịch
                            </a>
                            
                            <form action="${pageContext.request.contextPath}/appointment-action" method="POST" style="flex: 1; margin: 0;" onsubmit="event.preventDefault(); const form = this; showConfirmModal('Bạn có chắc chắn muốn hủy lịch khám này?', () => form.submit(), 'danger');">
                                <input type="hidden" name="appointmentId" value="${appt.appointmentId}">
                                <input type="hidden" name="action" value="cancel">
                                <button type="submit" class="btn-appt btn-cancel" style="width: 100%;">
                                    <i class="fa-solid fa-xmark"></i> Hủy Khám
                                </button>
                            </form>
                        </c:if>
                        <c:if test="${not empty appt.visitId && appt.visitId > 0}">
                            <a href="${pageContext.request.contextPath}/customer-visit-detail?id=${appt.visitId}" class="btn-appt" style="flex: 1; background: #f0fdf4; color: #16a34a; border: 1px solid #16a34a; display: inline-block; text-decoration: none;">
                                <i class="fa-solid fa-notes-medical"></i> Xem Bệnh Án
                            </a>
                        </c:if>
                        <c:if test="${not empty appt.invoiceId && appt.invoiceId > 0}">
                            <a href="${pageContext.request.contextPath}/invoice-detail?id=${appt.invoiceId}" class="btn-appt" style="flex: 1; background: #f8fafc; color: var(--primary); border: 1px solid var(--primary); display: inline-block; text-decoration: none;">
                                <i class="fa-solid fa-file-invoice-dollar"></i> Xem Hóa Đơn
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </c:forEach>

        <c:if test="${empty appointments}">
            <div class="no-data">
                <i class="fa-regular fa-calendar-xmark"></i>
                <h3>Bạn chưa có lịch hẹn nào</h3>
                <p style="color: var(--color-text-muted); margin-top: 10px;">Hãy đặt lịch ngay để trải nghiệm dịch vụ chăm sóc răng miệng đẳng cấp.</p>
                <a href="${pageContext.request.contextPath}/booking" class="btn-submit-sci" style="display: inline-block; width: auto; margin-top: 20px; padding: 12px 30px; font-size: 1rem; text-decoration: none;">
                    Đặt Lịch Ngay
                </a>
            </div>
        </c:if>
    </div>

    <!-- Phân trang -->
    <div style="margin-top: 40px;">
        <t:pagination activePage="${not empty pageNumber ? pageNumber : (not empty param.page ? param.page : 1)}" totalPages="${totalPages}" urlParams="&search=${param.search}&status=${param.status}" />
    </div>
</div>



<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
