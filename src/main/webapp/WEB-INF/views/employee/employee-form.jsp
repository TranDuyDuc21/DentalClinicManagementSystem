<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="currentPage" value="employees" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="${empty employee ? 'Thêm Nhân Viên' : 'Cập Nhật Nhân Viên'} - Admin" />
</jsp:include>

<div style="margin-bottom: 20px;">
    <a href="${pageContext.request.contextPath}/employees" style="color: var(--text-secondary); text-decoration: none;">
        <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
    </a>
</div>

<div class="card" style="padding: 30px;">
    <h3 style="margin-bottom: 25px; color: var(--primary); border-bottom: 1px solid var(--border-color); padding-bottom: 15px;">
        <i class="fa-solid ${empty employee ? 'fa-user-plus' : 'fa-user-pen'}"></i>
        ${empty employee ? 'Thêm Nhân Viên Mới' : 'Cập Nhật Thông Tin Nhân Viên'}
    </h3>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-error" style="margin-bottom: 20px;">
            ${sessionScope.errorMessage}
            <c:remove var="errorMessage" scope="session" />
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/employees/${empty employee ? 'create' : 'update'}" method="POST" id="employeeForm">
        <c:if test="${not empty employee}">
            <input type="hidden" name="id" value="${employee.userId}">
        </c:if>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <!-- Column 1 -->
            <div>
                <div class="form-group">
                    <label class="form-label" for="username">Tên đăng nhập <span style="color: red;">*</span></label>
                    <input type="text" class="form-control" id="username" name="username" value="${employee.username}" required ${not empty employee ? 'readonly style="background-color: #f1f5f9; cursor: not-allowed;"' : ''}>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="email">Email <span style="color: red;">*</span></label>
                    <input type="email" class="form-control" id="email" name="email" value="${employee.email}" required ${not empty employee ? 'readonly style="background-color: #f1f5f9; cursor: not-allowed;"' : ''}>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Mật khẩu ${empty employee ? '<span style="color: red;">*</span>' : '<span style="font-size:0.85rem; color:var(--text-secondary)">(Để trống nếu không muốn đổi)</span>'}</label>
                    <input type="password" class="form-control" id="password" name="password" ${empty employee ? 'required' : ''}>
                </div>
            </div>

            <!-- Column 2 -->
            <div>
                <div class="form-group">
                    <label class="form-label" for="fullName">Họ và tên <span style="color: red;">*</span></label>
                    <input type="text" class="form-control" id="fullName" name="fullName" value="${employee.fullName}" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="phoneNumber">Số điện thoại <span style="color: red;">*</span></label>
                    <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" value="${employee.phoneNumber}" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="roleId">Phân quyền chức vụ <span style="color: red;">*</span></label>
                    <select class="form-control" id="roleId" name="roleId" required>
                        <option value="">-- Chọn chức vụ --</option>
                        <c:forEach var="role" items="${roles}">
                            <option value="${role.roleId}" ${employee.roleId == role.roleId ? 'selected' : ''}>${role.roleName}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>

        <div class="form-group" style="margin-top: 20px; padding: 15px; background-color: #f8fafc; border-radius: 8px;">
            <label style="display: flex; align-items: center; cursor: pointer; margin: 0;">
                <input type="checkbox" name="isActive" ${empty employee || employee.active ? 'checked' : ''} style="width: 18px; height: 18px; margin-right: 10px;">
                <strong>Tài khoản hoạt động</strong>
            </label>
            <p style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 5px; margin-bottom: 0; margin-left: 28px;">Bỏ chọn sẽ ngăn người dùng này đăng nhập vào hệ thống.</p>
        </div>

        <div style="margin-top: 30px; display: flex; justify-content: flex-end; gap: 15px;">
            <a href="${pageContext.request.contextPath}/employees" class="btn btn-secondary">Hủy</a>
            <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> Lưu Thay Đổi</button>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
