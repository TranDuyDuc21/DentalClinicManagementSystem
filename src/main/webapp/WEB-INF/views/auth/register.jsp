<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Đăng Ký - Dental Clinic" />
</jsp:include>

<div class="flex-center" style="padding: 40px 20px;">
    <div class="card auth-wrapper" style="max-width: 700px;">
        <div class="auth-header" style="margin-bottom: 24px;">
            <div style="margin-bottom: 16px; color: var(--primary);">
                <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                    <line x1="19" y1="8" x2="19" y2="14"></line>
                    <line x1="22" y1="11" x2="16" y2="11"></line>
                </svg>
            </div>
            <h1>Đăng Ký Tài Khoản</h1>
            <p>Điền thông tin bên dưới để tạo tài khoản mới</p>
        </div>

        <jsp:include page="/WEB-INF/views/components/messages.jsp" />

        <form action="${pageContext.request.contextPath}/register" method="POST" class="validate-form">
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0 20px;">
                <div class="form-group">
                    <label for="fullName" class="form-label">Họ và tên <span style="color: var(--error);">*</span></label>
                    <input type="text" id="fullName" name="fullName" class="form-control" 
                           value="${user.fullName}" required minlength="3" maxlength="150"
                           placeholder="Nhập họ và tên">
                </div>

                <div class="form-group">
                    <label for="username" class="form-label">Tên đăng nhập <span style="color: var(--error);">*</span></label>
                    <input type="text" id="username" name="username" class="form-control" 
                           value="${user.username}" required minlength="4" maxlength="50" data-rule="username" data-unique="username"
                           placeholder="Nhập tên đăng nhập">
                </div>

                <div class="form-group">
                    <label for="email" class="form-label">Email <span style="color: var(--error);">*</span></label>
                    <input type="email" id="email" name="email" class="form-control" 
                           value="${user.email}" required data-rule="email" maxlength="150" data-unique="email"
                           placeholder="Nhập địa chỉ email hợp lệ">
                </div>

                <div class="form-group">
                    <label for="phoneNumber" class="form-label">Số điện thoại <span style="color: var(--error);">*</span></label>
                    <input type="text" id="phoneNumber" name="phoneNumber" class="form-control" 
                           value="${user.phoneNumber}" required data-rule="phone" data-unique="phone"
                           placeholder="Nhập số điện thoại (10-11 số)">
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">Mật khẩu <span style="color: var(--error);">*</span></label>
                    <input type="password" id="password" name="password" class="form-control" 
                           required minlength="6"
                           placeholder="Mật khẩu ít nhất 6 ký tự">
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu <span style="color: var(--error);">*</span></label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                           required data-match="password"
                           placeholder="Nhập lại mật khẩu ở trên">
                </div>
            </div>

            <button type="submit" class="btn btn-primary" style="margin-top: 10px;">Đăng Ký</button>
        </form>

        <div class="text-center" style="margin-top: 20px; font-size: 0.95rem;">
            Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" class="text-primary" style="text-decoration: none; font-weight: 500;">Đăng nhập</a>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
