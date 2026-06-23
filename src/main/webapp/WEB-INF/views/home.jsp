<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="currentPage" value="home" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Trang Chủ - Dental Clinic" />
</jsp:include>


<div class="hero-section">
    <div class="container">
        <h1 class="hero-title">Nụ Cười Hoàn Mỹ Của Bạn Khởi Nguồn Từ Đây</h1>
        <p class="hero-subtitle">Trải nghiệm dịch vụ nha khoa đẳng cấp quốc tế với hệ thống trang thiết bị tối tân và đội ngũ chuyên gia tận tâm vì sức khỏe của bạn.</p>
    </div>
</div>

<!-- Quick Booking Form -->
<div class="booking-wrapper">
    <div class="booking-card">
        <h3><i class="fa-solid fa-calendar-check"></i> Đặt Lịch Khám Nhanh</h3>
        <form action="${pageContext.request.contextPath}/home" method="POST">
            <div class="row">
                <div class="col col-5">
                    <label for="serviceId" class="form-label-premium">Dịch vụ bạn quan tâm</label>
                    <select name="serviceId" id="serviceId" class="form-control-premium">
                        <option value="">-- Tất cả dịch vụ --</option>
                        <c:forEach var="svc" items="${services}">
                            <option value="${svc.serviceId}">${svc.serviceName} - <fmt:formatNumber value="${svc.listedPrice}" type="number" maxFractionDigits="0"/> VNĐ</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col col-5">
                    <label for="doctorId" class="form-label-premium">Chuyên gia nha khoa</label>
                    <select name="doctorId" id="doctorId" class="form-control-premium">
                        <option value="">-- Bác sĩ bất kỳ --</option>
                        <c:forEach var="doc" items="${doctors}">
                            <option value="${doc.doctorId}">BS. ${doc.fullName} - ${doc.specialty}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col col-2" style="display: flex; align-items: flex-end;">
                    <button type="submit" class="btn-premium">
                        Xác Nhận <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Services Section -->
<div class="section-spacing bg-white">
    <div class="container">
        <h2 class="section-title-premium">Dịch Vụ Nổi Bật</h2>
        <div class="row" style="margin-top: 40px;">
            <c:forEach var="svc" items="${services}">
                <div class="col col-4" style="margin-bottom: 30px;">
                    <div class="service-card-premium">
                        <div class="service-icon-wrapper">
                            <c:choose>
                                <c:when test="${svc.serviceName.contains('Cạo Vôi') || svc.serviceName.contains('Vệ Sinh')}">
                                    <i class="fa-solid fa-tooth"></i>
                                </c:when>
                                <c:when test="${svc.serviceName.contains('Tẩy Trắng')}">
                                    <i class="fa-regular fa-face-smile-beam"></i>
                                </c:when>
                                <c:when test="${svc.serviceName.contains('Nhổ Răng')}">
                                    <i class="fa-solid fa-staff-snake"></i>
                                </c:when>
                                <c:when test="${svc.serviceName.contains('Implant') || svc.serviceName.contains('Cắm Ghép')}">
                                    <i class="fa-solid fa-screwdriver-wrench"></i>
                                </c:when>
                                <c:when test="${svc.serviceName.contains('Niềng Răng') || svc.serviceName.contains('Chỉnh Nha')}">
                                    <i class="fa-solid fa-teeth-open"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="fa-solid fa-hand-holding-medical"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h4 style="min-height: 45px; display: flex; align-items: center; justify-content: center;">${svc.serviceName}</h4>
                        <p style="display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;">
                            ${svc.description != null ? svc.description : 'Giải pháp nha khoa toàn diện mang lại nụ cười rạng rỡ và sự tự tin tối đa cho bạn.'}
                        </p>
                        <div style="font-size: 0.85rem; color: #64748b; margin-bottom: 15px; font-weight: 600; display: flex; align-items: center; justify-content: center; gap: 6px;">
                            <span style="background: #f1f5f9; padding: 4px 10px; border-radius: 20px;">
                                <i class="fa-regular fa-clock" style="color: #0ea5e9;"></i> ${svc.estimatedMinutes} phút
                            </span>
                        </div>
                        <div class="service-price">
                            <fmt:formatNumber value="${svc.listedPrice}" type="number" maxFractionDigits="0"/> <span style="font-size: 1rem; font-weight: 600;">VNĐ</span>
                        </div>
                        
                        <div style="display: flex; gap: 8px; margin-top: auto; padding-top: 10px; border-top: 1px dashed #e2e8f0;">
                            <a href="${pageContext.request.contextPath}/service-detail?id=${svc.serviceId}" class="btn-outline-premium" style="flex: 1; padding: 8px 5px; text-align: center; text-decoration: none;">
                                Xem Chi Tiết
                            </a>
                            <a href="${pageContext.request.contextPath}/booking?serviceId=${svc.serviceId}" class="btn-premium" style="flex: 1.2; padding: 8px 5px; text-align: center; text-decoration: none; height: auto; font-size: 0.85rem; border-radius: 8px;">
                                Đặt Dịch Vụ
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div style="text-align: center; margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/services" class="btn-outline-premium" style="width: auto; padding: 12px 30px;">
                Xem Tất Cả Dịch Vụ <i class="fa-solid fa-arrow-right" style="margin-left: 8px;"></i>
            </a>
        </div>
    </div>
</div>

<!-- Doctors Section -->
<div class="section-spacing" style="background-color: var(--color-bg);">
    <div class="container">
        <h2 class="section-title-premium">Đội Ngũ Chuyên Gia</h2>
        <div class="row" style="margin-top: 40px;">
            <c:forEach var="doc" items="${doctors}">
                <div class="col col-6">
                    <div class="doctor-card-premium">
                        <div class="doctor-avatar-wrapper">
                            <img src="${not empty doc.profilePicture ? pageContext.request.contextPath.concat('/').concat(doc.profilePicture) : 'https://ui-avatars.com/api/?name='.concat(doc.fullName).concat('&background=0ea5e9&color=fff&size=128')}" alt="${doc.fullName}" class="doctor-avatar-premium">
                            <div class="doctor-status"></div>
                        </div>
                        <div class="doctor-info-premium">
                            <h5>BS. ${doc.fullName}</h5>
                            <div class="doctor-spec">
                                <i class="fa-solid fa-stethoscope" style="color: var(--color-primary);"></i>
                                ${doc.specialty}
                            </div>
                            <form action="${pageContext.request.contextPath}/home" method="POST" style="margin: 0;">
                                <input type="hidden" name="doctorId" value="${doc.doctorId}">
                                <button type="submit" style="background: none; border: none; color: var(--color-primary); font-weight: 600; padding: 0; cursor: pointer; display: flex; align-items: center; gap: 5px;">
                                    Đặt lịch hẹn <i class="fa-solid fa-chevron-right" style="font-size: 0.8em;"></i>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />