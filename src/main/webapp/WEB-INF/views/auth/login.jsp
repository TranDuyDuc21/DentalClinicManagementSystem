<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Đăng Nhập - Dental Clinic" />
</jsp:include>

<div class="flex-center">
    <div class="card auth-wrapper">
        <div class="auth-header">
            <div style="margin-bottom: 16px; color: var(--primary);">
                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    <path d="M9 12l2 2 4-4"></path>
                </svg>
            </div>
            <h1>Đăng Nhập</h1>
            <p>Vui lòng đăng nhập vào hệ thống</p>
        </div>

        <jsp:include page="/WEB-INF/views/components/messages.jsp" />

        <form action="${pageContext.request.contextPath}/login" method="POST" class="validate-form">
            <input type="hidden" name="redirect" value="${not empty param.redirect ? param.redirect : redirect}">
            <div class="form-group">
                <label for="identifier" class="form-label">Tên đăng nhập hoặc Email</label>
                <input type="text" id="identifier" name="identifier" class="form-control" 
                       value="${identifier}" required 
                       placeholder="Nhập tên đăng nhập hoặc email">
            </div>

            <div class="form-group">
                <label for="password" class="form-label">Mật khẩu</label>
                <div style="position: relative;">
                    <input type="password" id="password" name="password" class="form-control" 
                           required pattern=".*\S.*" title="Mật khẩu không được chỉ chứa khoảng trắng" placeholder="Nhập mật khẩu" style="padding-right: 40px;">
                    <i class="fa-solid fa-eye" id="togglePassword" style="position: absolute; right: 10px; top: 24px; transform: translateY(-50%); cursor: pointer; color: #6b7280;" onclick="
                        const passwordInput = document.getElementById('password');
                        if (passwordInput.type === 'password') {
                            passwordInput.type = 'text';
                            this.classList.remove('fa-eye');
                            this.classList.add('fa-eye-slash');
                        } else {
                            passwordInput.type = 'password';
                            this.classList.remove('fa-eye-slash');
                            this.classList.add('fa-eye');
                        }
                    "></i>
                </div>
            </div>

            <div class="form-group mb-3 text-right">
                <a href="${pageContext.request.contextPath}/forgot-password" class="text-primary" style="text-decoration: none; font-size: 0.9rem;">Quên mật khẩu?</a>
            </div>

            <button type="submit" class="btn btn-primary">Đăng Nhập</button>
        </form>

        <div class="text-center" style="margin-top: 16px; font-size: 0.9rem;">
            Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register" class="text-primary" style="text-decoration: none; font-weight: 500;">Đăng ký ngay</a>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
