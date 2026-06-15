<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="currentPage" value="home" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Trang Chủ - Dental Clinic" />
</jsp:include>

<style>
    /* Premium Root Variables */
    :root {
        --color-primary: #0284c7;
        --color-primary-dark: #0369a1;
        --color-primary-light: #bae6fd;
        --color-secondary: #0ea5e9;
        --color-accent: #f59e0b;
        --color-bg: #f8fafc;
        --color-text-main: #0f172a;
        --color-text-muted: #64748b;
        --color-white: #ffffff;
        --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
        --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
        --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
        --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
        --shadow-glow: 0 0 20px rgba(2, 132, 199, 0.2);
        --radius-lg: 16px;
        --radius-xl: 24px;
        --font-main: 'Outfit', sans-serif;
    }

    body {
        background-color: var(--color-bg);
        font-family: var(--font-main);
        color: var(--color-text-main);
        margin: 0;
        padding: 0;
    }

    /* Professional Grid System */
    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    }
    
    .row {
        display: flex;
        flex-wrap: wrap;
        margin-right: -15px;
        margin-left: -15px;
    }
    
    .col {
        padding-right: 15px;
        padding-left: 15px;
        box-sizing: border-box;
    }

    .col-4 { width: 33.33%; }
    .col-5 { width: 41.66%; }
    .col-6 { width: 50%; }
    .col-2 { width: 16.66%; }

    @media (max-width: 992px) {
        .col-4, .col-5, .col-2, .col-6 { width: 100%; margin-bottom: 20px; }
    }

    /* Hero Section - Stunning Gradient & Image */
    .hero-section {
        background: linear-gradient(135deg, rgba(2, 132, 199, 0.95) 0%, rgba(14, 165, 233, 0.85) 100%), 
                    url('https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?q=80&w=1920&auto=format&fit=crop') center/cover;
        color: var(--color-white);
        padding: 120px 20px 160px;
        text-align: center;
        position: relative;
        overflow: hidden;
    }
    
    .hero-section::after {
        content: '';
        position: absolute;
        bottom: -50px; left: 0; right: 0; height: 100px;
        background: var(--color-bg);
        transform: skewY(-2deg);
    }

    .hero-title {
        font-size: 3.5rem;
        font-weight: 800;
        margin-bottom: 24px;
        letter-spacing: -0.5px;
        text-shadow: 0 2px 4px rgba(0,0,0,0.2);
        animation: fadeInDown 0.8s ease-out;
    }

    .hero-subtitle {
        font-size: 1.25rem;
        font-weight: 300;
        line-height: 1.6;
        opacity: 0.95;
        max-width: 650px;
        margin: 0 auto;
        animation: fadeInUp 0.8s ease-out 0.2s both;
    }

    /* Floating Booking Card */
    .booking-wrapper {
        position: relative;
        margin-top: -100px;
        z-index: 10;
        padding: 0 20px;
        animation: fadeInUp 0.8s ease-out 0.4s both;
    }

    .booking-card {
        background: var(--color-white);
        padding: 40px;
        border-radius: var(--radius-xl);
        box-shadow: var(--shadow-xl);
        max-width: 1000px;
        margin: 0 auto;
        border: 1px solid rgba(255, 255, 255, 0.5);
        backdrop-filter: blur(10px);
    }

    .booking-card h3 {
        color: var(--color-primary-dark);
        font-size: 1.75rem;
        font-weight: 700;
        margin-bottom: 25px;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .form-control-premium {
        width: 100%;
        padding: 14px 18px;
        border: 2px solid #e2e8f0;
        border-radius: 12px;
        font-size: 1rem;
        color: var(--color-text-main);
        background-color: #f8fafc;
        transition: all 0.3s ease;
        appearance: none;
        background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%2364748b' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
        background-repeat: no-repeat;
        background-position: right 1rem center;
        background-size: 1em;
    }

    .form-control-premium:focus {
        border-color: var(--color-primary);
        background-color: var(--color-white);
        outline: none;
        box-shadow: 0 0 0 4px var(--color-primary-light);
    }

    .form-label-premium {
        display: block;
        font-weight: 600;
        margin-bottom: 8px;
        color: var(--color-text-main);
        font-size: 0.95rem;
    }

    .btn-premium {
        background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
        color: white;
        border: none;
        padding: 14px 16px;
        border-radius: 12px;
        font-weight: 600;
        font-size: 1.1rem;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: var(--shadow-md);
        width: 100%;
        height: 52px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        white-space: nowrap;
    }

    .btn-premium:hover {
        transform: translateY(-2px);
        box-shadow: var(--shadow-lg), var(--shadow-glow);
    }

    /* Section Titles */
    .section-spacing {
        padding: 80px 0;
    }

    .section-title-premium {
        text-align: center;
        font-size: 2.25rem;
        font-weight: 800;
        color: var(--color-text-main);
        margin-bottom: 50px;
        position: relative;
    }

    .section-title-premium::after {
        content: '';
        position: absolute;
        bottom: -15px;
        left: 50%;
        transform: translateX(-50%);
        width: 80px;
        height: 5px;
        background: linear-gradient(90deg, var(--color-primary), var(--color-secondary));
        border-radius: 10px;
    }

    /* Premium Service Cards */
    .service-card-premium {
        background: var(--color-white);
        border-radius: var(--radius-lg);
        padding: 35px 25px;
        text-align: center;
        transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        height: 100%;
        display: flex;
        flex-direction: column;
        box-shadow: var(--shadow-sm);
        border: 1px solid #f1f5f9;
        position: relative;
        overflow: hidden;
    }

    .service-card-premium::before {
        content: '';
        position: absolute;
        top: 0; left: 0; width: 100%; height: 4px;
        background: linear-gradient(90deg, var(--color-primary), var(--color-secondary));
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .service-card-premium:hover {
        transform: translateY(-10px);
        box-shadow: var(--shadow-xl);
    }

    .service-card-premium:hover::before {
        opacity: 1;
    }

    .service-icon-wrapper {
        width: 80px;
        height: 80px;
        background: var(--color-primary-light);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 25px;
        color: var(--color-primary-dark);
        font-size: 2.2rem;
        transition: transform 0.3s ease;
    }

    .service-card-premium:hover .service-icon-wrapper {
        transform: scale(1.1) rotate(5deg);
    }

    .service-card-premium h4 {
        font-size: 1.4rem;
        font-weight: 700;
        margin-bottom: 15px;
        color: var(--color-text-main);
    }

    .service-card-premium p {
        color: var(--color-text-muted);
        font-size: 0.95rem;
        line-height: 1.6;
        margin-bottom: 25px;
        flex-grow: 1;
    }

    .service-price {
        font-size: 1.5rem;
        font-weight: 800;
        color: var(--color-primary);
        margin-bottom: 20px;
        background: -webkit-linear-gradient(var(--color-primary), var(--color-secondary));
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }

    .btn-outline-premium {
        background: transparent;
        color: var(--color-primary);
        border: 2px solid var(--color-primary);
        padding: 10px 20px;
        border-radius: 10px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        width: 100%;
        display: inline-block;
    }

    .btn-outline-premium:hover {
        background: var(--color-primary);
        color: white;
        box-shadow: var(--shadow-glow);
    }

    /* Premium Doctor Cards */
    .doctor-card-premium {
        background: var(--color-white);
        border-radius: var(--radius-lg);
        padding: 20px;
        display: flex;
        align-items: center;
        box-shadow: var(--shadow-md);
        transition: all 0.3s ease;
        border: 1px solid transparent;
        margin-bottom: 25px;
    }

    .doctor-card-premium:hover {
        transform: translateX(5px);
        border-color: var(--color-primary-light);
        box-shadow: var(--shadow-lg);
    }

    .doctor-avatar-wrapper {
        position: relative;
        margin-right: 25px;
    }

    .doctor-avatar-premium {
        width: 90px;
        height: 90px;
        border-radius: 50%;
        object-fit: cover;
        border: 4px solid var(--color-white);
        box-shadow: var(--shadow-md);
    }

    .doctor-status {
        position: absolute;
        bottom: 5px; right: 5px;
        width: 16px; height: 16px;
        background: #10b981;
        border: 3px solid var(--color-white);
        border-radius: 50%;
    }

    .doctor-info-premium h5 {
        font-size: 1.25rem;
        font-weight: 700;
        margin: 0 0 8px 0;
        color: var(--color-text-main);
    }

    .doctor-spec {
        color: var(--color-text-muted);
        font-size: 0.95rem;
        margin-bottom: 12px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    /* Animations */
    @keyframes fadeInDown {
        from { opacity: 0; transform: translateY(-30px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(30px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>

<!-- Hero Section -->
<div class="hero-section" style="position: relative;">
    <div style="position: absolute; top: 20px; right: 40px; z-index: 100;">
        <c:if test="${empty sessionScope.loggedUser}">
            <a href="${pageContext.request.contextPath}/login" class="btn-premium" style="height: 45px; width: auto; padding: 0 20px; font-size: 1rem; border-radius: 8px;">
                <i class="fa-solid fa-right-to-bracket"></i> Đăng Nhập
            </a>
        </c:if>
        <c:if test="${not empty sessionScope.loggedUser}">
            <a href="${pageContext.request.contextPath}/dashboard" class="btn-premium" style="height: 45px; width: auto; padding: 0 20px; font-size: 1rem; border-radius: 8px;">
                <i class="fa-solid fa-chart-line"></i> Dashboard
            </a>
        </c:if>
    </div>
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
                            <i class="fa-solid fa-tooth"></i>
                        </div>
                        <h4>${svc.serviceName}</h4>
                        <p>${svc.description != null ? svc.description : 'Giải pháp nha khoa toàn diện mang lại nụ cười rạng rỡ và sự tự tin tối đa cho bạn.'}</p>
                        <div class="service-price">
                            <fmt:formatNumber value="${svc.listedPrice}" type="number" maxFractionDigits="0"/> VNĐ
                        </div>
                        <form action="${pageContext.request.contextPath}/home" method="POST" style="margin:0; width:100%;">
                            <input type="hidden" name="serviceId" value="${svc.serviceId}">
                            <button type="submit" class="btn-outline-premium">Chọn Dịch Vụ Này</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
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