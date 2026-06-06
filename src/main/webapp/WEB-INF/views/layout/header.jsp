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
</head>
<body class="${not empty sessionScope.loggedUser ? 'dashboard-body' : ''}">

<c:if test="${not empty sessionScope.loggedUser}">
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
        <div class="dashboard-content">
</c:if>
