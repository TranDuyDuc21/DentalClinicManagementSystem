<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="currentPage" value="dashboard" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Dashboard - Quản Trị Nha Khoa" />
</jsp:include>

<h1 style="color: var(--primary); margin-bottom: 20px;">Chào mừng, ${sessionScope.loggedUser.fullName}!</h1>
<p style="font-size: 1.1rem; color: var(--text-secondary); margin-bottom: 30px;">
    Vai trò của bạn: <strong>${sessionScope.loggedUser.roleName}</strong>
</p>

<div class="card" style="padding: 30px; text-align: center;">
    <div style="font-size: 3rem; color: var(--primary); margin-bottom: 15px;">
        <i class="fa-solid fa-chart-line"></i>
    </div>
    <h3>Tổng Quan Hệ Thống</h3>
    <p>Bạn đã đăng nhập thành công. Nội dung Dashboard sẽ hiển thị theo chức vụ của bạn.</p>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
