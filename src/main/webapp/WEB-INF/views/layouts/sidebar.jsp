<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Sidebar -->
<nav id="sidebar">
    <div class="sidebar-header">
        <i class="bi bi-hospital fs-3 text-primary"></i>
        <p class="text-muted small mb-0 mt-1">Hệ thống quản lý nha khoa</p>
    </div>
    <hr class="my-0">

    <ul class="sidebar-nav list-unstyled px-2 py-3">

        <!-- Dashboard - all roles -->
        <li>
            <a href="${pageContext.request.contextPath}/dashboard"
               class="sidebar-link ${currentPage == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
        </li>

        <!-- Receptionist + Admin -->
        <c:if test="${sessionScope.currentUser.role == 'Admin' || sessionScope.currentUser.role == 'Receptionist'}">
            <li><p class="sidebar-section">LỄ TÂN</p></li>
            <li>
                <a href="${pageContext.request.contextPath}/appointment"
                   class="sidebar-link ${currentPage == 'appointment' ? 'active' : ''}">
                    <i class="bi bi-calendar-check"></i> Lịch hẹn
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/patient"
                   class="sidebar-link ${currentPage == 'patient' ? 'active' : ''}">
                    <i class="bi bi-people"></i> Bệnh nhân
                </a>
            </li>
        </c:if>

        <!-- Doctor + Admin -->
        <c:if test="${sessionScope.currentUser.role == 'Admin' || sessionScope.currentUser.role == 'Doctor'}">
            <li><p class="sidebar-section">BÁC SĨ</p></li>
            <li>
                <a href="${pageContext.request.contextPath}/treatment"
                   class="sidebar-link ${currentPage == 'treatment' ? 'active' : ''}">
                    <i class="bi bi-clipboard2-pulse"></i> Điều trị
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/prescription"
                   class="sidebar-link ${currentPage == 'prescription' ? 'active' : ''}">
                    <i class="bi bi-file-earmark-medical"></i> Đơn thuốc
                </a>
            </li>
        </c:if>

        <!-- Technician + Admin -->
        <c:if test="${sessionScope.currentUser.role == 'Admin' || sessionScope.currentUser.role == 'Technician'}">
            <li><p class="sidebar-section">KỸ THUẬT VIÊN</p></li>
            <li>
                <a href="${pageContext.request.contextPath}/lab-order"
                   class="sidebar-link ${currentPage == 'lab-order' ? 'active' : ''}">
                    <i class="bi bi-flask"></i> Yêu cầu xét nghiệm
                </a>
            </li>
        </c:if>

        <!-- Admin only -->
        <c:if test="${sessionScope.currentUser.role == 'Admin'}">
            <li><p class="sidebar-section">QUẢN TRỊ</p></li>
            <li>
                <a href="${pageContext.request.contextPath}/user"
                   class="sidebar-link ${currentPage == 'user' ? 'active' : ''}">
                    <i class="bi bi-person-gear"></i> Người dùng
                </a>
            </li>
            <li>
                <a href="${pageContext.request.contextPath}/report"
                   class="sidebar-link ${currentPage == 'report' ? 'active' : ''}">
                    <i class="bi bi-bar-chart-line"></i> Báo cáo
                </a>
            </li>
        </c:if>

        <!-- All roles -->
        <li><p class="sidebar-section">TÀI KHOẢN</p></li>
        <li>
            <a href="${pageContext.request.contextPath}/profile"
               class="sidebar-link ${currentPage == 'profile' ? 'active' : ''}">
                <i class="bi bi-person-circle"></i> Hồ sơ cá nhân
            </a>
        </li>
    </ul>
</nav>
<!-- End Sidebar -->

<!-- Page Content -->
<div id="page-content">
    <div class="content-wrapper">
