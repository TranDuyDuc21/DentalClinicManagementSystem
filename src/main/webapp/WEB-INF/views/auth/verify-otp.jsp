<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Xác Thực OTP - Dental Clinic" />
</jsp:include>

<div class="flex-center" style="padding: 40px 20px;">
    <div class="card auth-wrapper">
        <div class="auth-header" style="margin-bottom: 24px;">
            <div style="margin-bottom: 16px; color: var(--primary);">
                <i class="fa-solid fa-shield-halved" style="font-size: 40px;"></i>
            </div>
            <h1>Xác Thực OTP</h1>
            <p>Mã OTP đã được gửi đến email <strong>${sessionScope.resetEmail}</strong>. Vui lòng kiểm tra hộp thư của bạn.</p>
        </div>

        <jsp:include page="/WEB-INF/views/components/messages.jsp" />

        <form action="${pageContext.request.contextPath}/verify-otp" method="POST" class="validate-form">
            <div class="form-group">
                <label for="otp" class="form-label">Mã OTP (6 chữ số) <span style="color: var(--error);">*</span></label>
                <div style="position: relative;">
                    <i class="fa-solid fa-hashtag" style="position: absolute; left: 15px; top: 24px; transform: translateY(-50%); color: #6b7280;"></i>
                    <input type="text" id="otp" name="otp" class="form-control" 
                           required minlength="6" maxlength="6"
                           placeholder="Nhập mã OTP"
                           style="padding-left: 40px; letter-spacing: 5px; font-weight: bold; font-size: 1.2rem; text-align: center;">
                </div>
                <div style="margin-top: 8px; font-size: 0.85rem; color: #6b7280; text-align: center;">
                    Mã sẽ hết hạn sau <span id="timer" style="color: var(--error); font-weight: bold;">15:00</span>
                </div>
            </div>

            <button type="submit" class="btn btn-primary" style="margin-top: 10px;">Xác nhận</button>
        </form>

        <div class="text-center" style="margin-top: 20px; font-size: 0.95rem;">
            Chưa nhận được mã? <a href="${pageContext.request.contextPath}/forgot-password" class="text-primary" style="text-decoration: none; font-weight: 500;">Thử lại</a>
        </div>
    </div>
</div>

<script>
    // Đếm ngược 15 phút tượng trưng trên giao diện
    let timeLeft = 15 * 60;
    const timerElement = document.getElementById('timer');
    
    const countdown = setInterval(function() {
        if (timeLeft <= 0) {
            clearInterval(countdown);
            timerElement.innerHTML = "Hết hạn";
            return;
        }
        
        let minutes = Math.floor(timeLeft / 60);
        let seconds = timeLeft % 60;
        
        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;
        
        timerElement.innerHTML = minutes + ":" + seconds;
        timeLeft -= 1;
    }, 1000);
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
