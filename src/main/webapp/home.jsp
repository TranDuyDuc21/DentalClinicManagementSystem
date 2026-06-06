<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Trang Chủ - Dental Clinic" />
</jsp:include>

<div class="container" style="padding: 60px 20px; text-align: center; min-height: 60vh;">
    <h1 style="color: var(--primary); margin-bottom: 20px;">Welcome Home!</h1>
    
    <c:if test="${not empty sessionScope.loggedUser}">
        <p style="font-size: 1.2rem;">Chào mừng quay trở lại, <strong>${sessionScope.loggedUser.fullName}</strong>!</p>
        <p>Đây là khu vực dành cho khách hàng. Chức năng đặt lịch hẹn và xem hồ sơ sẽ sớm ra mắt.</p>
        <div style="margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">Đăng xuất</a>
        </div>
    </c:if>
    <c:if test="${empty sessionScope.loggedUser}">
        <p style="font-size: 1.2rem;">Chào mừng bạn đến với Hệ thống Nha khoa của chúng tôi!</p>
        <div style="margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Đăng nhập</a>
        </div>
    </c:if>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
