<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="currentPage" value="services" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="${service.serviceName} - Chi Tiết Dịch Vụ" />
</jsp:include>



<!-- Hero Section -->
<div class="sd-hero">
    <div class="container">
        <div class="sd-hero-content">
            <div class="sd-icon-wrapper">
                <c:choose>
                    <c:when test="${service.serviceName.contains('Cạo Vôi') || service.serviceName.contains('Vệ Sinh')}">
                        <i class="fa-solid fa-tooth"></i>
                    </c:when>
                    <c:when test="${service.serviceName.contains('Tẩy Trắng')}">
                        <i class="fa-regular fa-face-smile-beam"></i>
                    </c:when>
                    <c:when test="${service.serviceName.contains('Nhổ Răng')}">
                        <i class="fa-solid fa-staff-snake"></i>
                    </c:when>
                    <c:when test="${service.serviceName.contains('Implant') || service.serviceName.contains('Cắm Ghép')}">
                        <i class="fa-solid fa-screwdriver-wrench"></i>
                    </c:when>
                    <c:when test="${service.serviceName.contains('Niềng Răng') || service.serviceName.contains('Chỉnh Nha')}">
                        <i class="fa-solid fa-teeth-open"></i>
                    </c:when>
                    <c:otherwise>
                        <i class="fa-solid fa-hand-holding-medical"></i>
                    </c:otherwise>
                </c:choose>
            </div>
            <h1 class="sd-title">${service.serviceName}</h1>
            <div class="sd-badge">
                <i class="fa-solid fa-star" style="color: #fbbf24; margin-right: 5px;"></i> Dịch Vụ Nha Khoa Cao Cấp
            </div>
        </div>
    </div>
</div>

<!-- Main Content Card -->
<div class="container">
    <div class="sd-main-card">
        
        <div class="sd-price-banner">
            <div class="sd-price-label">Giá Dịch Vụ Trọn Gói</div>
            <div class="sd-price-value">
                <fmt:formatNumber value="${service.listedPrice}" type="number" maxFractionDigits="0"/>
                <span class="sd-price-currency">VNĐ</span>
            </div>
        </div>

        <div class="sd-info-grid">
            <div class="sd-info-item">
                <div class="sd-info-icon"><i class="fa-regular fa-clock"></i></div>
                <div class="sd-info-text">
                    <h4>Thời Gian Thực Hiện</h4>
                    <p>${service.estimatedMinutes} phút</p>
                </div>
            </div>
            <div class="sd-info-item">
                <div class="sd-info-icon"><i class="fa-solid fa-qrcode"></i></div>
                <div class="sd-info-text">
                    <h4>Mã Dịch Vụ</h4>
                    <p>${service.serviceCode}</p>
                </div>
            </div>
        </div>

        <div class="sd-desc-section">
            <h3 class="sd-desc-title">Tổng Quan Dịch Vụ</h3>
            <div class="sd-desc-content">
                ${service.description != null ? service.description : 'Trải nghiệm quá trình điều trị chuyên nghiệp với hệ thống máy móc tân tiến và đội ngũ bác sĩ hàng đầu. Dịch vụ này không chỉ khắc phục triệt để vấn đề nha khoa của bạn mà còn mang lại vẻ đẹp tự nhiên, giúp bạn tự tin hơn với nụ cười hoàn mỹ.'}
            </div>
        </div>

        <div class="sd-actions">
            <a href="${pageContext.request.contextPath}/services" class="btn-ultra-back">
                <i class="fa-solid fa-arrow-left"></i> Trở Về Danh Mục
            </a>
            <a href="${pageContext.request.contextPath}/booking?serviceId=${service.serviceId}" class="btn-ultra-book">
                Đặt Lịch Ngay <i class="fa-solid fa-calendar-check"></i>
            </a>
        </div>
        
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
