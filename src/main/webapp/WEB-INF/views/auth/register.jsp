<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Dental Clinic</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common/variables.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pages/auth.css">
</head>
<body class="auth-page">

<div class="auth-card auth-card-wide">
    <!-- Logo -->
    <div class="auth-logo">
        <i class="bi bi-hospital"></i>
        <h4 class="fw-bold mt-2">Dental Clinic</h4>
        <p class="text-muted small">Tạo tài khoản mới</p>
    </div>

    <!-- Alerts -->
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

    <form action="${pageContext.request.contextPath}/register" method="post" novalidate id="registerForm">

        <!-- Họ tên + Tên đăng nhập -->
        <div class="row g-3 mb-3">
            <div class="col-12 col-md-6">
                <label class="form-label fw-medium">Họ và tên <span class="text-danger">*</span></label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person-vcard"></i></span>
                    <input type="text" name="fullName" class="form-control"
                           placeholder="Nguyễn Văn A" required
                           value="${not empty param.fullName ? param.fullName : ''}">
                </div>
            </div>
            <div class="col-12 col-md-6">
                <label class="form-label fw-medium">Tên đăng nhập <span class="text-danger">*</span></label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-at"></i></span>
                    <input type="text" name="username" class="form-control"
                           placeholder="username123" required
                           value="${not empty param.username ? param.username : ''}">
                </div>
            </div>
        </div>

        <!-- Email -->
        <div class="mb-3">
            <label class="form-label fw-medium">Email <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                <input type="email" name="email" class="form-control"
                       placeholder="example@email.com" required
                       value="${not empty param.email ? param.email : ''}">
            </div>
        </div>

        <!-- Số điện thoại + Giới tính -->
        <div class="row g-3 mb-3">
            <div class="col-12 col-md-6">
                <label class="form-label fw-medium">Số điện thoại</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-phone"></i></span>
                    <input type="tel" name="phoneNumber" class="form-control"
                           placeholder="0901234567"
                           value="${not empty param.phoneNumber ? param.phoneNumber : ''}">
                </div>
            </div>
            <div class="col-12 col-md-6">
                <label class="form-label fw-medium">Giới tính</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-gender-ambiguous"></i></span>
                    <select name="gender" class="form-select">
                        <option value="" disabled selected>Chọn giới tính</option>
                        <option value="Male"   ${param.gender == 'Male'   ? 'selected' : ''}>Nam</option>
                        <option value="Female" ${param.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                        <option value="Other"  ${param.gender == 'Other'  ? 'selected' : ''}>Khác</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Ngày sinh -->
        <div class="mb-3">
            <label class="form-label fw-medium">Ngày sinh</label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-calendar3"></i></span>
                <input type="date" name="dateOfBirth" class="form-control"
                       value="${not empty param.dateOfBirth ? param.dateOfBirth : ''}">
            </div>
        </div>

        <!-- Mật khẩu -->
        <div class="mb-3">
            <label class="form-label fw-medium">Mật khẩu <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                <input type="password" name="password" id="passwordInput" class="form-control"
                       placeholder="Tối thiểu 8 ký tự" required minlength="8">
                <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                    <i class="bi bi-eye" id="toggleIcon"></i>
                </button>
            </div>
            <div class="password-strength mt-1" id="strengthBar"></div>
        </div>

        <!-- Xác nhận mật khẩu -->
        <div class="mb-4">
            <label class="form-label fw-medium">Xác nhận mật khẩu <span class="text-danger">*</span></label>
            <div class="input-group">
                <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                <input type="password" name="confirmPassword" id="confirmInput" class="form-control"
                       placeholder="Nhập lại mật khẩu" required>
            </div>
            <div class="invalid-feedback d-block text-danger small mt-1" id="matchError" style="display:none!important"></div>
        </div>

        <button type="submit" class="btn btn-primary w-100 fw-medium">
            <i class="bi bi-person-plus me-1"></i> Đăng ký
        </button>
    </form>

    <p class="text-center text-muted small mt-3 mb-0">
        Đã có tài khoản?
        <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-medium">Đăng nhập</a>
    </p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Toggle password visibility
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

    // Password strength indicator
    document.getElementById('passwordInput').addEventListener('input', function () {
        const val = this.value;
        const bar = document.getElementById('strengthBar');
        let strength = 0;
        if (val.length >= 8)              strength++;
        if (/[A-Z]/.test(val))            strength++;
        if (/[0-9]/.test(val))            strength++;
        if (/[^A-Za-z0-9]/.test(val))    strength++;

        const labels = ['', 'Yếu', 'Trung bình', 'Mạnh', 'Rất mạnh'];
        const colors = ['', '#dc3545', '#fd7e14', '#0d6efd', '#198754'];
        bar.innerHTML = val.length === 0 ? '' :
            `<div class="d-flex align-items-center gap-2">
                ${[1,2,3,4].map(i =>
                    `<div style="height:4px;flex:1;border-radius:2px;background:${i <= strength ? colors[strength] : '#dee2e6'}"></div>`
                ).join('')}
                <span class="small" style="color:${colors[strength]};white-space:nowrap">${labels[strength]}</span>
            </div>`;
    });

    // Confirm password match
    function checkMatch() {
        const pwd     = document.getElementById('passwordInput').value;
        const confirm = document.getElementById('confirmInput').value;
        const err     = document.getElementById('matchError');
        if (confirm.length > 0 && pwd !== confirm) {
            err.textContent = 'Mật khẩu xác nhận không khớp';
            err.style.display = 'block';
        } else {
            err.style.display = 'none';
        }
    }
    document.getElementById('confirmInput').addEventListener('input', checkMatch);
    document.getElementById('passwordInput').addEventListener('input', checkMatch);

    // Prevent submit if passwords don't match
    document.getElementById('registerForm').addEventListener('submit', function (e) {
        const pwd     = document.getElementById('passwordInput').value;
        const confirm = document.getElementById('confirmInput').value;
        if (pwd !== confirm) {
            e.preventDefault();
            document.getElementById('matchError').style.display = 'block';
            document.getElementById('confirmInput').focus();
        }
    });
</script>
</body>
</html>
