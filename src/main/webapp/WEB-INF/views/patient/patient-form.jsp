<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="currentPage" value="patients" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Tạo Hồ Sơ Bệnh Nhân - Admin" />
</jsp:include>

<div style="margin-bottom: 20px;">
    <!-- Giả định URL danh sách sau này sẽ là /patients -->
    <a href="${pageContext.request.contextPath}/patients/create" style="color: var(--text-secondary); text-decoration: none;">
        <i class="fa-solid fa-arrow-left"></i> Quay lại
    </a>
</div>

<div class="card" style="padding: 30px;">
    <h3 style="margin-bottom: 25px; color: var(--primary); border-bottom: 1px solid var(--border-color); padding-bottom: 15px;">
        <i class="fa-solid fa-file-medical"></i> Tạo Hồ Sơ Bệnh Nhân
    </h3>

    <jsp:include page="/WEB-INF/views/components/messages.jsp" />

    <!-- Tìm kiếm số điện thoại trước -->
    <div id="searchPhoneBox" style="background: #f8fafc; padding: 20px; border-radius: 8px; margin-bottom: 25px; border: 1px solid var(--border-color); display: grid; grid-template-columns: 1fr auto; gap: 15px; align-items: flex-end;">
        <div>
            <label class="form-label" for="searchPhone" style="display: block; margin-bottom: 8px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">Tra cứu số điện thoại trước khi tạo mới <span style="color: var(--error);">*</span></label>
            <input type="tel" class="form-control" id="searchPhone" placeholder="Nhập số điện thoại bệnh nhân..." style="width: 100%;">
        </div>
        <button type="button" class="btn btn-primary" id="btnSearchPhone" onclick="checkPatientPhone()" style="width: auto; min-width: 150px; white-space: nowrap;">
            <i class="fa-solid fa-magnifying-glass"></i> Kiểm Tra
        </button>
    </div>

    <!-- Form chính -->
    <form action="${pageContext.request.contextPath}/patients/create" method="POST" id="patientForm" class="validate-form" style="opacity: 0.5; pointer-events: none; transition: all 0.3s ease;">
        <input type="hidden" name="patientId" id="patientId" value="">
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
            <!-- Cột 1: Thông tin cơ bản -->
            <div>
                <h4 style="margin-bottom: 15px; color: var(--text-primary); font-size: 1.1rem;">Thông tin cơ bản</h4>
                
                <div class="form-group">
                    <label class="form-label" for="fullName">Họ và tên <span style="color: var(--error);">*</span></label>
                    <input type="text" class="form-control" id="fullName" name="fullName" required minlength="3" maxlength="150" placeholder="Nhập họ và tên bệnh nhân">
                </div>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="form-group">
                        <label class="form-label" for="dateOfBirth">Ngày sinh <span style="color: var(--error);">*</span></label>
                        <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="gender">Giới tính</label>
                        <select class="form-control" id="gender" name="gender">
                            <option value="Male">Nam</option>
                            <option value="Female">Nữ</option>
                            <option value="Other">Khác</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="phoneNumber">Số điện thoại <span style="color: var(--error);">*</span></label>
                    <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" required data-rule="phone" placeholder="Nhập số điện thoại">
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="email">Email</label>
                    <input type="email" class="form-control" id="email" name="email" data-rule="email" placeholder="Nhập địa chỉ email (tuỳ chọn)">
                </div>

                <div class="form-group">
                    <label class="form-label" for="address">Địa chỉ liên hệ</label>
                    <input type="text" class="form-control" id="address" name="address" maxlength="255" placeholder="Nhập địa chỉ đầy đủ">
                </div>
            </div>

            <!-- Cột 2: Tiền sử y tế -->
            <div>
                <h4 style="margin-bottom: 15px; color: var(--text-primary); font-size: 1.1rem;">Tiền sử y tế</h4>
                
                <div class="form-group">
                    <label class="form-label" for="medicalHistory">Tiền sử bệnh (Bệnh nền)</label>
                    <textarea class="form-control" id="medicalHistory" name="medicalHistory" rows="5" placeholder="Nhập các bệnh lý nền (VD: Huyết áp cao, tiểu đường, tim mạch...)" style="resize: vertical;"></textarea>
                    <small style="color: var(--text-secondary); margin-top: 5px; display: block;">Ghi chú rõ ràng để bác sĩ có phác đồ điều trị an toàn.</small>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="drugAllergies">Dị ứng thuốc</label>
                    <textarea class="form-control" id="drugAllergies" name="drugAllergies" rows="5" placeholder="Nhập tên các loại thuốc bệnh nhân từng bị dị ứng (VD: Penicillin, Aspirin...)" style="resize: vertical;"></textarea>
                    <small style="color: var(--error); margin-top: 5px; display: block;">* Vô cùng quan trọng. Hãy hỏi kỹ bệnh nhân!</small>
                </div>
            </div>
        </div>

        <div style="margin-top: 30px; display: flex; justify-content: flex-end; gap: 15px; border-top: 1px solid var(--border-color); padding-top: 20px;">
            <button type="reset" class="btn btn-secondary">Nhập Lại</button>
            <button type="submit" id="btnSubmitForm" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Tạo Hồ Sơ Mới</button>
        </div>
    </form>
</div>

<script>
    // Max date for dateOfBirth is today
    document.addEventListener('DOMContentLoaded', function() {
        const dateInput = document.getElementById('dateOfBirth');
        if (dateInput) {
            const today = new Date().toISOString().split('T')[0];
            dateInput.setAttribute('max', today);
        }
    });
</script>

<script>
    function checkPatientPhone() {
        const phoneInput = document.getElementById('searchPhone');
        const phone = phoneInput.value.trim();
        const btn = document.getElementById('btnSearchPhone');

        if(!phone) {
            showAlertModal('Vui lòng nhập số điện thoại để tra cứu.', 'warning');
            phoneInput.focus();
            return;
        }

        // Add loading state
        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang tra cứu...';
        btn.disabled = true;
        
        fetch('${pageContext.request.contextPath}/api/patient?phone=' + encodeURIComponent(phone))
            .then(res => res.json())
            .then(data => {
                const form = document.getElementById('patientForm');
                const submitBtn = document.getElementById('btnSubmitForm');
                
                // Unlock form
                form.style.opacity = '1';
                form.style.pointerEvents = 'auto';
                
                if(data.success && data.patient) {
                    // Populate data
                    document.getElementById('patientId').value = data.patient.patientId;
                    document.getElementById('fullName').value = data.patient.fullName;
                    document.getElementById('dateOfBirth').value = data.patient.dateOfBirth;
                    document.getElementById('gender').value = data.patient.gender;
                    document.getElementById('phoneNumber').value = data.patient.phoneNumber;
                    document.getElementById('email').value = data.patient.email || '';
                    document.getElementById('address').value = data.patient.address || '';
                    document.getElementById('medicalHistory').value = data.patient.medicalHistory || '';
                    document.getElementById('drugAllergies').value = data.patient.drugAllergies || '';
                    
                    // Change submit button
                    submitBtn.innerHTML = '<i class="fa-solid fa-floppy-disk"></i> Cập Nhật Hồ Sơ';
                    submitBtn.className = 'btn btn-primary'; 
                    
                    // Show notification
                    showAlertModal('Đã tìm thấy bệnh nhân! Thông tin đã được tự động điền. Bạn có thể cập nhật thông tin nếu cần.', 'success');
                } else {
                    // Clear form for new patient
                    form.reset();
                    document.getElementById('patientId').value = '';
                    document.getElementById('phoneNumber').value = phone; // keep the searched phone
                    
                    // Change submit button
                    submitBtn.innerHTML = '<i class="fa-solid fa-plus"></i> Tạo Hồ Sơ Mới';
                    submitBtn.className = 'btn btn-primary';
                    
                    showAlertModal('Không tìm thấy bệnh nhân. Form đã được mở khóa để bạn điền thông tin tạo mới.', 'info');
                }
            })
            .catch(err => {
                console.error(err);
                showAlertModal('Có lỗi xảy ra khi kiểm tra số điện thoại. Vui lòng thử lại.', 'error');
            })
            .finally(() => {
                // Restore button
                btn.innerHTML = '<i class="fa-solid fa-magnifying-glass"></i> Kiểm Tra';
                btn.disabled = false;
            });
    }
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
