<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Dental Clinic Management'}</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/design-system.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer-premium.css">
</head>
<c:set var="isCustomer" value="${sessionScope.loggedUser != null && sessionScope.loggedUser.roleName == 'Customer'}" />
<c:set var="isStaff" value="${sessionScope.loggedUser != null && sessionScope.loggedUser.roleName != 'Customer'}" />
<c:set var="isGuest" value="${sessionScope.loggedUser == null}" />

<body class="${isStaff ? 'dashboard-body' : ''}">

<c:if test="${isCustomer || isGuest}">
    <!-- Top Navigation Header cho Customer và Khách -->
    <header style="background: white; box-shadow: 0 2px 10px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 1000;">
        <div style="max-width: 1200px; margin: 0 auto; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center;">
            <a href="${pageContext.request.contextPath}/home" style="text-decoration: none; display: flex; align-items: center; gap: 10px; color: var(--primary);">
                <i class="fa-solid fa-tooth" style="font-size: 1.8rem;"></i>
                <span style="font-size: 1.25rem; font-weight: 700;">DentalClinic</span>
            </a>
            
            <nav style="display: flex; gap: 30px; align-items: center;">
                <a href="${pageContext.request.contextPath}/home" style="text-decoration: none; font-weight: 500; color: ${currentPage == 'home' ? 'var(--primary)' : 'var(--text-secondary)'};">Trang Chủ</a>
                
                <c:choose>
                    <c:when test="${isCustomer}">
                        <a href="${pageContext.request.contextPath}/appointments" style="text-decoration: none; font-weight: 500; color: ${currentPage == 'appointments' ? 'var(--primary)' : 'var(--text-secondary)'};">Lịch Hẹn</a>
                        <a href="${pageContext.request.contextPath}/customer-invoices" style="text-decoration: none; font-weight: 500; color: ${currentPage == 'customer-invoices' ? 'var(--primary)' : 'var(--text-secondary)'};">Hóa Đơn</a>
                        <a href="${pageContext.request.contextPath}/profile" style="text-decoration: none; font-weight: 500; color: ${currentPage == 'profile' ? 'var(--primary)' : 'var(--text-secondary)'};">Hồ Sơ</a>
                        
                        <div style="display: flex; align-items: center; gap: 12px; border-left: 1px solid #e2e8f0; padding-left: 20px; margin-left: 10px;">
                            <img src="${pageContext.request.contextPath}/assets/images/default-avatar.png" onerror="this.src='https://ui-avatars.com/api/?name=${sessionScope.loggedUser.fullName}&background=random'" style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover;">
                            <div style="display: flex; flex-direction: column;">
                                <span style="font-weight: 600; font-size: 0.95rem; color: var(--text-primary);">${sessionScope.loggedUser.fullName}</span>
                                <a href="${pageContext.request.contextPath}/logout" style="color: var(--error); font-size: 0.85rem; text-decoration: none;"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="display: flex; align-items: center; gap: 15px; margin-left: 10px;">
                            <a href="${pageContext.request.contextPath}/login" style="padding: 10px 24px; border-radius: 8px; font-weight: 600; text-decoration: none; color: var(--primary); white-space: nowrap; transition: all 0.3s; display: inline-block;">Đăng Nhập</a>
                            <a href="${pageContext.request.contextPath}/register" style="padding: 10px 24px; border-radius: 8px; font-weight: 600; text-decoration: none; color: white; background: linear-gradient(135deg, var(--primary) 0%, #0ea5e9 100%); border: 2px solid transparent; white-space: nowrap; transition: all 0.3s; box-shadow: 0 4px 14px 0 rgba(2, 132, 199, 0.39); display: inline-block;">Đăng Ký</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </header>
    
    <div class="customer-main-content" style="flex-grow: 1; display: flex; flex-direction: column; ${not empty currentPage and currentPage != 'home' ? 'padding: 30px 20px; max-width: 1200px; margin: 0 auto; width: 100%;' : 'width: 100%;'}">
</c:if>

<c:if test="${isStaff}">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <!-- Main Content Wrapper -->
    <div class="dashboard-main">
        
        <!-- Header -->
        <div class="dashboard-header">
            <div class="header-left">
                <button class="btn-icon">
                    <i class="fa-solid fa-bars"></i>
                </button>
                <span class="header-title" style="margin-left: 15px; font-weight: 500;">
                    Hệ thống Nha Khoa DentalClinic
                </span>
            </div>
            
            <div class="header-right">
                <div class="header-notifications">
                    <button class="btn-icon">
                        <i class="fa-regular fa-bell"></i>
                        <span class="badge">3</span>
                    </button>
                </div>
                
                <div class="header-user">
                    <img src="${pageContext.request.contextPath}/assets/images/default-avatar.png" alt="Avatar" class="avatar-sm" onerror="this.src='https://ui-avatars.com/api/?name=${sessionScope.loggedUser.fullName}&background=random'">
                    <div class="user-info">
                        <span class="user-name">${sessionScope.loggedUser.fullName}</span>
                        <span class="user-role">${sessionScope.loggedUser.roleName}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bắt đầu nội dung trang -->
        <div class="dashboard-content" style="padding: 30px;">
</c:if>
