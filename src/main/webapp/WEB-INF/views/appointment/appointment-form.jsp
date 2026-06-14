<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="currentPage" value="appointments" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Đặt Lịch Hẹn" />
</jsp:include>

<div class="page-header mb-4" style="margin-bottom: 20px;">
    <h2 class="fw-bold mb-1" style="color: var(--primary);"><i class="fa-solid fa-calendar-plus me-2"></i>Đặt Lịch Hẹn Mới</h2>
    <p class="text-muted small mb-0">Điền thông tin bên dưới để tạo lịch khám</p>
</div>

<jsp:include page="/WEB-INF/views/components/messages.jsp" />

<div class="card" style="max-width: 800px; margin: 0 auto; padding: 30px;">
    <form action="${pageContext.request.contextPath}/appointment-form" method="POST" class="validate-form">
        
        <c:if test="${sessionScope.loggedUser.roleName != 'Customer'}">
            <div class="form-group" style="margin-bottom: 20px;">
                <label for="patientId" class="form-label">Chọn Bệnh Nhân (Dành cho Lễ Tân) <span style="color: var(--error);">*</span></label>
                <select id="patientId" name="patientId" class="form-control" required>
                    <option value="">-- Chọn bệnh nhân --</option>
                    <c:forEach var="pt" items="${patients}">
                        <option value="${pt.patientId}">${pt.patientCode} - ${pt.fullName} (${pt.phoneNumber})</option>
                    </c:forEach>
                </select>
            </div>
        </c:if>

        <div class="form-group" style="margin-bottom: 20px;">
            <label for="serviceId" class="form-label">Dịch Vụ Mong Muốn</label>
            <select id="serviceId" name="serviceId" class="form-control">
                <option value="">-- Khám Tổng Quát / Tư Vấn --</option>
                <c:forEach var="svc" items="${services}">
                    <option value="${svc.serviceId}" ${param.serviceId == svc.serviceId ? 'selected' : ''}>${svc.serviceName} (${svc.estimatedMinutes} phút)</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group" style="margin-bottom: 20px;">
            <label for="doctorId" class="form-label">Chọn Bác Sĩ <span style="color: var(--error);">*</span></label>
            <select id="doctorId" name="doctorId" class="form-control" required>
                <option value="">-- Vui lòng chọn bác sĩ --</option>
                <c:forEach var="doc" items="${doctors}">
                    <option value="${doc.doctorId}" ${param.doctorId == doc.doctorId ? 'selected' : ''}>${doc.fullName} - ${doc.specialty}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group" style="margin-bottom: 20px;">
            <label for="scheduledDatetime" class="form-label">Ngày và Giờ Khám <span style="color: var(--error);">*</span></label>
            <input type="datetime-local" id="scheduledDatetime" name="scheduledDatetime" class="form-control" required>
            <small style="color: #666; margin-top: 5px; display: inline-block;">Lưu ý: Bạn không thể đặt lịch trong quá khứ và phải đặt trước ít nhất 1 giờ.</small>
        </div>

        <div style="margin-top: 30px; display: flex; justify-content: flex-end; gap: 15px;">
            <a href="${pageContext.request.contextPath}/appointments" class="btn btn-outline-secondary">Hủy</a>
            <button type="submit" class="btn btn-primary" style="padding-left: 30px; padding-right: 30px;">Xác Nhận Đặt Lịch</button>
        </div>
    </form>
</div>

<script>
    // Prevent selecting past dates
    document.addEventListener('DOMContentLoaded', function() {
        var dtInput = document.getElementById('scheduledDatetime');
        var now = new Date();
        now.setHours(now.getHours() + 1); // Require at least 1 hour in advance
        var year = now.getFullYear();
        var month = (now.getMonth() + 1).toString().padStart(2, '0');
        var day = now.getDate().toString().padStart(2, '0');
        var hours = now.getHours().toString().padStart(2, '0');
        var minutes = now.getMinutes().toString().padStart(2, '0');
        
        var minDatetime = year + '-' + month + '-' + day + 'T' + hours + ':' + minutes;
        dtInput.min = minDatetime;
    });
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
