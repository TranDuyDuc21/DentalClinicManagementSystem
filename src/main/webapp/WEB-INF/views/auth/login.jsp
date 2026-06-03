<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Dental Clinic</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/auth.css">
</head>
<body class="auth-page">

<div class="auth-card">
    <div class="auth-logo">
        <i class="bi bi-hospital"></i>
        <h4 class="fw-bold mt-2">Dental Clinic</h4>
        <p class="text-muted small">Hệ thống quản lý phòng khám nha khoa</p>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger py-2">
            <i class="bi bi-exclamation-triangle me-1"></i>${errorMessage}
        </div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success py-2">
            <i class="bi bi-check-circle me-1"></i>${successMessage}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
        <div class="mb-3">
            <label class="form-label fw-medium">Tên đăng nhập</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-person"></i></span>
                <input type="text" name="username" class="form-control"
                       placeholder="Nhập tên đăng nhập" required autofocus
                       value="${not empty param.username ? param.username : ''}">
            </div>
        </div>
        <div class="mb-3">
            <label class="form-label fw-medium">Mật khẩu</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                <input type="password" name="password" id="passwordInput" class="form-control"
                       placeholder="Nhập mật khẩu" required>
                <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                    <i class="bi bi-eye" id="toggleIcon"></i>
                </button>
            </div>
        </div>
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="form-check">
                <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                <label class="form-check-label small" for="rememberMe">Ghi nhớ đăng nhập</label>
            </div>
            <a href="${pageContext.request.contextPath}/forgot-password"
               class="text-decoration-none small">Quên mật khẩu?</a>
        </div>
        <button type="submit" class="btn btn-primary w-100 fw-medium">
            <i class="bi bi-box-arrow-in-right me-1"></i> Đăng nhập
        </button>
    </form>

    <p class="text-center text-muted small mt-3 mb-0">
        Chưa có tài khoản?
        <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-medium">Đăng ký ngay</a>
    </p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('togglePassword').addEventListener('click', function () {
        const input = document.getElementById('passwordInput');
        const icon  = document.getElementById('toggleIcon');
        if (input.type === 'password') {
            input.type = 'text';
            icon.className = 'bi bi-eye-slash';
        } else {
            input.type = 'password';
            icon.className = 'bi bi-eye';
        }
    });
</script>
</body>
</html>
