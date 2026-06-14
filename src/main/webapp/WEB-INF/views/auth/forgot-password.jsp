<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Quên Mật Khẩu - Dental Clinic" />
</jsp:include>

<div class="flex-center" style="padding: 40px 20px;">
    <div class="card auth-wrapper">
        <div class="auth-header" style="margin-bottom: 24px;">
            <div style="margin-bottom: 16px; color: var(--primary);">
                <i class="fa-solid fa-key" style="font-size: 40px;"></i>
            </div>
            <h1>Quên Mật Khẩu</h1>
            <p>Vui lòng nhập email bạn đã đăng ký. Chúng tôi sẽ gửi mã OTP để đặt lại mật khẩu.</p>
        </div>

        <jsp:include page="/WEB-INF/views/components/messages.jsp" />

        <form action="${pageContext.request.contextPath}/forgot-password" method="POST" class="validate-form">
            <div class="form-group">
                <label for="email" class="form-label">Email đăng ký <span style="color: var(--error);">*</span></label>
                <div style="position: relative;">
                    <i class="fa-solid fa-envelope" style="position: absolute; left: 15px; top: 24px; transform: translateY(-50%); color: #6b7280;"></i>
                    <input type="email" id="email" name="email" class="form-control" 
                           required data-rule="email"
                           placeholder="Nhập địa chỉ email của bạn"
                           style="padding-left: 40px;">
                </div>
            </div>

            <button type="submit" class="btn btn-primary" style="margin-top: 10px;">Gửi mã xác nhận</button>
        </form>

        <div class="text-center" style="margin-top: 20px; font-size: 0.95rem;">
            Nhớ mật khẩu? <a href="${pageContext.request.contextPath}/login" class="text-primary" style="text-decoration: none; font-weight: 500;">Quay lại Đăng nhập</a>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
