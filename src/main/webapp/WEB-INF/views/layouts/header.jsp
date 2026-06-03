<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle.concat(' - Dental Clinic') : 'Dental Clinic'}</title>

    <!-- Bootstrap 5 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/components/sidebar.css">
    <c:if test="${not empty pageCSS}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/${pageCSS}">
    </c:if>
</head>
<body>

<!-- Top Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top" id="topNavbar">
    <div class="container-fluid">
        <button class="btn btn-link text-white fs-5 me-2 p-0" id="sidebarToggle">
            <i class="bi bi-list"></i>
        </button>
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/dashboard">
            <i class="bi bi-hospital me-1"></i> Dental Clinic
        </a>
        <div class="ms-auto d-flex align-items-center gap-3">
            <span class="text-white d-none d-md-inline">
                <i class="bi bi-person-circle me-1"></i>${sessionScope.currentUser.fullName}
            </span>
            <span class="badge bg-light text-primary">${sessionScope.currentUser.role}</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">
                <i class="bi bi-box-arrow-right"></i> Đăng xuất
            </a>
        </div>
    </div>
</nav>

<!-- Page Wrapper -->
<div class="d-flex" id="wrapper">
