<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="currentPage" value="patients" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Tạo Hồ Sơ Bệnh Nhân - Admin" />
</jsp:include>

<div style="margin-bottom: 20px;">
    <a href="${pageContext.request.contextPath}/patients" style="color: var(--text-secondary); text-decoration: none;">
        <i class="fa-solid fa-arrow-left"></i> Quay lại
    </a>
</div>

<div class="card" style="padding: 30px;">
    <h3 style="margin-bottom: 25px; color: var(--primary); border-bottom: 1px solid var(--border-color); padding-bottom: 15px;">
        <i class="fa-solid fa-file-medical"></i> Tạo Hồ Sơ Bệnh Nhân
    </h3>

    <jsp:include page="/WEB-INF/views/components/messages.jsp" />

    <!-- Tìm kiếm số điện thoại trước -->
    <form id="searchPatientForm" class="validate-form" data-ajax="true">
        <div id="searchPhoneBox" style="background: #f8fafc; padding: 20px; border-radius: 8px; margin-bottom: 25px; border: 1px solid var(--border-color); display: grid; grid-template-columns: 1fr auto; gap: 15px; align-items: flex-end;">
            <div>
                <label class="form-label" for="searchPhone" style="display: block; margin-bottom: 8px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">Tra cứu số điện thoại trước khi tạo mới <span style="color: var(--error);">*</span></label>
                <input type="tel" class="form-control" id="searchPhone" data-rule="phone" required placeholder="Nhập số điện thoại bệnh nhân..." style="width: 100%;">
            </div>
            <button type="submit" class="btn btn-primary" id="btnSearchPhone" style="width: auto; min-width: 150px; white-space: nowrap;">
                <i class="fa-solid fa-magnifying-glass"></i> Kiểm Tra
            </button>
        </div>
    </form>

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
    document.addEventListener('DOMContentLoaded', () => {
        const dateInput = document.getElementById('dateOfBirth');
        if (dateInput) {
            const today = new Date().toISOString().split('T')[0];
            dateInput.setAttribute('max', today);
        }

        const searchForm = document.getElementById('searchPatientForm');
        if (searchForm) {
            searchForm.addEventListener('validSubmit', () => {
                checkPatientPhone();
            });
        }
    });
</script>

<!-- Modal chọn bệnh nhân -->
<div id="patientSelectionModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center;">
    <div style="background: white; padding: 25px; border-radius: 8px; max-width: 500px; width: 90%;">
        <h4 style="margin-top: 0; color: var(--primary);">Chọn Hồ Sơ Bệnh Nhân</h4>
        <p style="color: var(--text-secondary); margin-bottom: 20px;">Tìm thấy nhiều hồ sơ dùng chung số điện thoại này. Vui lòng chọn:</p>
        
        <div id="patientListContainer" style="max-height: 300px; overflow-y: auto; margin-bottom: 20px;">
            <!-- Danh sách bệnh nhân sẽ được render ở đây -->
        </div>
        
        <div style="display: flex; justify-content: flex-end; gap: 10px; border-top: 1px solid var(--border-color); padding-top: 15px;">
            <button type="button" class="btn btn-secondary" onclick="closePatientModal()">Hủy</button>
            <button type="button" class="btn btn-primary" onclick="createNewPatientFromModal()"><i class="fa-solid fa-plus"></i> Tạo hồ sơ mới</button>
        </div>
    </div>
</div>

<script>
    function checkPatientPhone() {
        const phoneInput = document.getElementById('searchPhone');
        const phone = phoneInput.value.trim();
        const btn = document.getElementById('btnSearchPhone');

        // Add loading state
        btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang tra cứu...';
        btn.disabled = true;
        
        fetch('${pageContext.request.contextPath}/api/patient?phone=' + encodeURIComponent(phone))
            .then(res => res.json())
            .then(data => {
                const form = document.getElementById('patientForm');
                
                // Unlock form
                form.style.opacity = '1';
                form.style.pointerEvents = 'auto';
                
                if(data.success && data.patients && data.patients.length > 0) {
                    if (data.patients.length === 1) {
                        loadPatientData(data.patients[0]);
                    } else {
                        showPatientSelectionModal(data.patients);
                    }
                } else {
                    prepareNewPatientForm(phone);
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

    function loadPatientData(patient) {
        document.getElementById('patientId').value = patient.patientId;
        document.getElementById('fullName').value = patient.fullName;
        document.getElementById('dateOfBirth').value = patient.dateOfBirth;
        document.getElementById('gender').value = patient.gender;
        document.getElementById('phoneNumber').value = patient.phoneNumber;
        document.getElementById('email').value = patient.email || '';
        document.getElementById('address').value = patient.address || '';
        document.getElementById('medicalHistory').value = patient.medicalHistory || '';
        document.getElementById('drugAllergies').value = patient.drugAllergies || '';
        
        const submitBtn = document.getElementById('btnSubmitForm');
        submitBtn.innerHTML = '<i class="fa-solid fa-floppy-disk"></i> Cập Nhật Hồ Sơ';
        submitBtn.className = 'btn btn-primary'; 
        
        showAlertModal('Đã tìm thấy bệnh nhân! Thông tin đã được tự động điền.', 'success');
    }

    function prepareNewPatientForm(phone) {
        const form = document.getElementById('patientForm');
        form.reset();
        document.getElementById('patientId').value = '';
        document.getElementById('phoneNumber').value = phone; // keep the searched phone
        
        const submitBtn = document.getElementById('btnSubmitForm');
        submitBtn.innerHTML = '<i class="fa-solid fa-plus"></i> Tạo Hồ Sơ Mới';
        submitBtn.className = 'btn btn-primary';
    }

    function showPatientSelectionModal(patients) {
        const container = document.getElementById('patientListContainer');
        container.innerHTML = '';
        
        patients.forEach((p) => {
            const div = document.createElement('div');
            div.style.padding = '10px';
            div.style.border = '1px solid var(--border-color)';
            div.style.marginBottom = '10px';
            div.style.borderRadius = '5px';
            div.style.cursor = 'pointer';
            div.style.display = 'flex';
            div.style.justifyContent = 'space-between';
            div.style.alignItems = 'center';
            div.onmouseover = () => div.style.backgroundColor = '#f8fafc';
            div.onmouseout = () => div.style.backgroundColor = 'transparent';
            
            div.onclick = () => {
                loadPatientData(p);
                closePatientModal();
            };
            
            div.innerHTML = `
                <div>
                    <strong>` + p.fullName + `</strong> (` + p.patientCode + `)<br>
                    <small style="color: var(--text-secondary);">NS: ` + (p.dateOfBirth ? p.dateOfBirth : 'N/A') + ` - ` + (p.gender === 'Male' ? 'Nam' : (p.gender === 'Female' ? 'Nữ' : 'Khác')) + `</small>
                </div>
                <div>
                    <button type="button" class="btn btn-secondary" style="padding: 4px 10px; font-size: 0.85rem;">Chọn</button>
                </div>
            `;
            container.appendChild(div);
        });
        
        document.getElementById('patientSelectionModal').style.display = 'flex';
    }

    function closePatientModal() {
        document.getElementById('patientSelectionModal').style.display = 'none';
    }

    function createNewPatientFromModal() {
        closePatientModal();
        const phone = document.getElementById('searchPhone').value.trim();
        prepareNewPatientForm(phone);
        showAlertModal('Form đã được mở khóa để tạo hồ sơ mới cùng số điện thoại.', 'info');
    }
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
