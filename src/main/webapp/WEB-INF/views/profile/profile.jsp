<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Hồ Sơ Cá Nhân" />
<c:set var="currentPage" value="profile" scope="request" />
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="page-header mb-4" style="margin-bottom: 20px;">
    <h2 class="fw-bold mb-1" style="color: var(--primary);"><i class="fa-regular fa-user me-2"></i>Hồ Sơ Cá Nhân</h2>
    <p class="text-muted small mb-0">Quản lý thông tin cá nhân và bảo mật tài khoản</p>
</div>

<jsp:include page="/WEB-INF/views/components/messages.jsp" />

<div style="display: flex; gap: 20px; flex-wrap: wrap;">
    <!-- Card Thông tin cá nhân -->
    <div class="card" style="flex: 1; min-width: 300px; padding: 20px;">
        <h3 style="margin-bottom: 20px; font-size: 1.25rem; color: #333; border-bottom: 1px solid #eee; padding-bottom: 10px;">Thông Tin Cơ Bản</h3>
        
        <form action="${pageContext.request.contextPath}/profile" method="POST" enctype="multipart/form-data" class="validate-form">
            <input type="hidden" name="action" value="updateProfile">
            
            <div style="text-align: center; margin-bottom: 20px;">
                <div style="position: relative; display: inline-block;">
                    <img id="avatarPreview" src="${not empty sessionScope.loggedUser.profilePicture ? pageContext.request.contextPath.concat(sessionScope.loggedUser.profilePicture) : pageContext.request.contextPath.concat('/assets/images/default-avatar.png')}" 
                         alt="Avatar" style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; border: 3px solid var(--primary); cursor: pointer;"
                         onerror="this.src='https://ui-avatars.com/api/?name=${sessionScope.loggedUser.fullName}&background=random'"
                         onclick="document.getElementById('avatarInput').click();">
                    <div style="position: absolute; bottom: 0; right: 0; background: var(--primary); color: white; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; pointer-events: none;">
                        <i class="fa-solid fa-camera"></i>
                    </div>
                </div>
                <input type="file" id="avatarInput" name="avatar" style="display: none;" accept="image/*" onchange="previewImage(event)">
                <p style="font-size: 0.85rem; color: #666; margin-top: 8px;">Nhấn vào ảnh để thay đổi</p>
            </div>

            <div class="form-group" style="margin-bottom: 15px;">
                <label for="fullName" class="form-label">Họ và tên <span style="color: var(--error);">*</span></label>
                <input type="text" id="fullName" name="fullName" class="form-control" value="${sessionScope.loggedUser.fullName}" required minlength="3" maxlength="150" placeholder="Nhập họ và tên">
            </div>

            <div class="form-group" style="margin-bottom: 15px;">
                <label for="email" class="form-label">Email (Không thể thay đổi)</label>
                <input type="email" id="email" class="form-control" value="${sessionScope.loggedUser.email}" readonly style="background-color: #f1f5f9; cursor: not-allowed;">
            </div>

            <div class="form-group" style="margin-bottom: 15px;">
                <label for="phoneNumber" class="form-label">Số điện thoại <span style="color: var(--error);">*</span></label>
                <input type="text" id="phoneNumber" name="phoneNumber" class="form-control" value="${sessionScope.loggedUser.phoneNumber}" required data-rule="phone" data-unique="phone" placeholder="Nhập số điện thoại (10-11 số)">
            </div>

            <div style="display: flex; gap: 15px; margin-bottom: 15px;">
                <div class="form-group" style="flex: 1;">
                    <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                    <fmt:formatDate value="${sessionScope.loggedUser.dateOfBirth}" pattern="yyyy-MM-dd" var="formattedDate" />
                    <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control" value="${formattedDate}">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label for="gender" class="form-label">Giới tính</label>
                    <select id="gender" name="gender" class="form-control">
                        <option value="Male" ${sessionScope.loggedUser.gender == 'Male' ? 'selected' : ''}>Nam</option>
                        <option value="Female" ${sessionScope.loggedUser.gender == 'Female' ? 'selected' : ''}>Nữ</option>
                        <option value="Other" ${sessionScope.loggedUser.gender == 'Other' ? 'selected' : ''}>Khác</option>
                    </select>
                </div>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%;">Lưu Thay Đổi</button>
        </form>
    </div>

    <!-- Card Đổi mật khẩu -->
    <div class="card" style="flex: 1; min-width: 300px; padding: 20px;">
        <h3 style="margin-bottom: 20px; font-size: 1.25rem; color: #333; border-bottom: 1px solid #eee; padding-bottom: 10px;">Đổi Mật Khẩu</h3>
        
        <form action="${pageContext.request.contextPath}/profile" method="POST" class="validate-form">
            <input type="hidden" name="action" value="changePassword">
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label for="currentPassword" class="form-label">Mật khẩu hiện tại <span style="color: var(--error);">*</span></label>
                <div style="position: relative;">
                    <input type="password" id="currentPassword" name="currentPassword" class="form-control" required style="padding-right: 40px;">
                    <i class="fa-regular fa-eye toggle-password" data-target="currentPassword" style="position: absolute; right: 15px; top: 24px; transform: translateY(-50%); cursor: pointer; color: #6b7280;"></i>
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 15px;">
                <label for="newPassword" class="form-label">Mật khẩu mới <span style="color: var(--error);">*</span></label>
                <div style="position: relative;">
                    <input type="password" id="newPassword" name="newPassword" class="form-control" required minlength="6" pattern="^\S+$" title="Mật khẩu không được chứa khoảng trắng" style="padding-right: 40px;">
                    <i class="fa-regular fa-eye toggle-password" data-target="newPassword" style="position: absolute; right: 15px; top: 24px; transform: translateY(-50%); cursor: pointer; color: #6b7280;"></i>
                </div>
                <div class="password-strength mt-2" style="display: none;">
                    <div class="strength-bar"></div>
                    <span class="strength-text text-sm"></span>
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 25px;">
                <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới <span style="color: var(--error);">*</span></label>
                <div style="position: relative;">
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required data-match="newPassword" pattern="^\S+$" title="Mật khẩu không được chứa khoảng trắng" style="padding-right: 40px;">
                    <i class="fa-regular fa-eye toggle-password" data-target="confirmPassword" style="position: absolute; right: 15px; top: 24px; transform: translateY(-50%); cursor: pointer; color: #6b7280;"></i>
                </div>
            </div>

            <button type="submit" class="btn" style="width: 100%; background-color: #10b981; color: white;">Cập Nhật Mật Khẩu</button>
        </form>
    </div>
</div>

<script>
function previewImage(event) {
    var reader = new FileReader();
    reader.onload = function() {
        var output = document.getElementById('avatarPreview');
        output.src = reader.result;
    }
    if(event.target.files[0]) {
        reader.readAsDataURL(event.target.files[0]);
    }
}
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
