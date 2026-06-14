<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Đặt Lại Mật Khẩu - Dental Clinic" />
</jsp:include>

<div class="flex-center" style="padding: 40px 20px;">
    <div class="card auth-wrapper">
        <div class="auth-header" style="margin-bottom: 24px;">
            <div style="margin-bottom: 16px; color: var(--primary);">
                <i class="fa-solid fa-shield-halved" style="font-size: 40px;"></i>
            </div>
            <h1>Đặt Lại Mật Khẩu</h1>
            <p>Xác thực thành công! Vui lòng thiết lập mật khẩu mới cho tài khoản <strong>${sessionScope.resetEmail}</strong></p>
        </div>

        <jsp:include page="/WEB-INF/views/components/messages.jsp" />

        <form action="${pageContext.request.contextPath}/reset-password" method="POST" class="validate-form">
            <input type="hidden" name="dummy" value="1">

            <div class="form-group">
                <label for="newPassword" class="form-label">Mật khẩu mới <span style="color: var(--error);">*</span></label>
                <div style="position: relative;">
                    <input type="password" id="newPassword" name="newPassword" class="form-control" 
                           required minlength="6"
                           placeholder="Mật khẩu ít nhất 6 ký tự" style="padding-right: 40px;">
                    <i class="fa-solid fa-eye" style="position: absolute; right: 10px; top: 24px; transform: translateY(-50%); cursor: pointer; color: #6b7280;" onclick="
                        const pwd = document.getElementById('newPassword');
                        if (pwd.type === 'password') {
                            pwd.type = 'text';
                            this.classList.replace('fa-eye', 'fa-eye-slash');
                        } else {
                            pwd.type = 'password';
                            this.classList.replace('fa-eye-slash', 'fa-eye');
                        }
                    "></i>
                </div>
            </div>

            <div class="form-group">
                <label for="confirmPassword" class="form-label">Xác nhận mật khẩu <span style="color: var(--error);">*</span></label>
                <div style="position: relative;">
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                           required data-match="newPassword"
                           placeholder="Nhập lại mật khẩu ở trên" style="padding-right: 40px;">
                    <i class="fa-solid fa-eye" style="position: absolute; right: 10px; top: 24px; transform: translateY(-50%); cursor: pointer; color: #6b7280;" onclick="
                        const pwd = document.getElementById('confirmPassword');
                        if (pwd.type === 'password') {
                            pwd.type = 'text';
                            this.classList.replace('fa-eye', 'fa-eye-slash');
                        } else {
                            pwd.type = 'password';
                            this.classList.replace('fa-eye-slash', 'fa-eye');
                        }
                    "></i>
                </div>
            </div>

            <button type="submit" class="btn btn-primary" style="margin-top: 10px;">Đặt lại mật khẩu</button>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
