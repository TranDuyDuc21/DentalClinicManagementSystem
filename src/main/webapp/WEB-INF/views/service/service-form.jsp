<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="currentPage" value="services" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="${not empty service ? 'Sửa' : 'Thêm'} Danh Mục Dịch Vụ - Admin" />
</jsp:include>

<div style="margin-bottom: 20px;">
    <a href="${pageContext.request.contextPath}/services" style="color: var(--text-secondary); text-decoration: none;">
        <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
    </a>
</div>

<div class="card" style="padding: 30px;">
    <h3 style="margin-bottom: 25px; color: var(--primary); border-bottom: 1px solid var(--border-color); padding-bottom: 15px;">
        <i class="fa-solid ${not empty service ? 'fa-pen-to-square' : 'fa-plus'}"></i> 
        ${not empty service ? 'Cập Nhật Dịch Vụ' : 'Thêm Dịch Vụ Mới'}
    </h3>

    <jsp:include page="/WEB-INF/views/components/messages.jsp" />

    <form action="${pageContext.request.contextPath}/services/${not empty service ? 'update' : 'create'}" method="POST" class="validate-form">
        <c:if test="${not empty service}">
            <input type="hidden" name="serviceId" value="${service.serviceId}">
        </c:if>

        <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 20px;">
            <div class="form-group">
                <label class="form-label" for="serviceCode">Mã dịch vụ <span style="color: var(--error);">*</span></label>
                <input type="text" class="form-control" id="serviceCode" name="serviceCode" value="${service.serviceCode}" required maxlength="20" placeholder="VD: SV-001">
                <div id="serviceCodeFeedback" style="font-size: 0.85rem; margin-top: 5px;"></div>
            </div>

            <div class="form-group">
                <label class="form-label" for="serviceName">Tên dịch vụ <span style="color: var(--error);">*</span></label>
                <input type="text" class="form-control" id="serviceName" name="serviceName" value="${service.serviceName}" required maxlength="150" placeholder="Nhập tên dịch vụ nha khoa">
            </div>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <div class="form-group">
                <label class="form-label" for="listedPrice">Giá niêm yết (VNĐ) <span style="color: var(--error);">*</span></label>
                <input type="number" class="form-control" id="listedPrice" name="listedPrice" value="${service.listedPrice}" required min="0" step="1000" placeholder="0">
            </div>

            <div class="form-group">
                <label class="form-label" for="estimatedMinutes">Thời gian dự kiến (Phút)</label>
                <input type="number" class="form-control" id="estimatedMinutes" name="estimatedMinutes" value="${service.estimatedMinutes}" min="1" max="600" placeholder="VD: 30">
            </div>
        </div>

        <div class="form-group">
            <label class="form-label" for="description">Mô tả dịch vụ</label>
            <textarea class="form-control" id="description" name="description" rows="4" placeholder="Nhập mô tả chi tiết về dịch vụ..." style="resize: vertical;">${service.description}</textarea>
        </div>

        <div class="form-group" style="margin-top: 15px;">
            <label class="form-label" style="display: flex; align-items: center; gap: 10px; cursor: pointer;">
                <input type="checkbox" name="isActive" value="true" ${empty service || service.active ? 'checked' : ''} style="width: 18px; height: 18px; cursor: pointer;">
                <span>Cho phép hiển thị & sử dụng dịch vụ này (Đang hoạt động)</span>
            </label>
        </div>

        <div style="margin-top: 30px; display: flex; justify-content: flex-end; gap: 15px; border-top: 1px solid var(--border-color); padding-top: 20px;">
            <a href="${pageContext.request.contextPath}/services" class="btn btn-secondary">Hủy bỏ</a>
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-floppy-disk"></i> Lưu Dịch Vụ
            </button>
        </div>
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const codeInput = document.getElementById('serviceCode');
        const feedback = document.getElementById('serviceCodeFeedback');
        const submitBtn = document.querySelector('button[type="submit"]');
        const excludeId = '${service.serviceId}';

        let timeout = null;

        codeInput.addEventListener('input', function() {
            clearTimeout(timeout);
            const code = this.value.trim();
            
            if (!code) {
                feedback.textContent = '';
                codeInput.style.borderColor = '';
                submitBtn.disabled = false;
                return;
            }

            timeout = setTimeout(() => {
                fetch('${pageContext.request.contextPath}/api/services/check-code?code=' + encodeURIComponent(code) + (excludeId ? '&excludeId=' + excludeId : ''))
                    .then(response => response.json())
                    .then(data => {
                        if (data.exists) {
                            feedback.textContent = 'Mã dịch vụ này đã tồn tại!';
                            feedback.style.color = 'var(--error)';
                            submitBtn.disabled = true;
                            codeInput.style.borderColor = 'var(--error)';
                        } else {
                            feedback.textContent = 'Mã dịch vụ hợp lệ.';
                            feedback.style.color = 'var(--success)';
                            submitBtn.disabled = false;
                            codeInput.style.borderColor = 'var(--success)';
                        }
                    })
                    .catch(err => console.error('Error checking code:', err));
            }, 500); // 500ms debounce
        });
    });
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
