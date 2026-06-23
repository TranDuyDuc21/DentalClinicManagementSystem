<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="currentPage" value="appointments" scope="request" />

        <jsp:include page="/WEB-INF/views/layout/header.jsp">
            <jsp:param name="pageTitle" value="Đặt Lịch Hẹn (Lễ Tân)" />
        </jsp:include>

        <!-- Sử dụng bộ style cao cấp dùng chung -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer-premium.css">

        <div class="page-header mb-4" style="margin-bottom: 20px;">
            <h2 class="fw-bold mb-1" style="color: var(--primary);"><i class="fa-solid fa-calendar-plus me-2"></i>Tạo
                Lịch Hẹn Mới</h2>
            <p class="text-muted small mb-0">Dành cho Lễ tân / Quản trị viên đặt lịch hộ khách hàng</p>
        </div>

        <jsp:include page="/WEB-INF/views/components/messages.jsp" />

        <div class="card" style="padding: 30px; border-radius: var(--radius-xl); box-shadow: var(--shadow-md);">
            <form action="${pageContext.request.contextPath}/appointment-form" method="POST" class="validate-form"
                novalidate onsubmit="return validateForm()">

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px;">
                    <div>
                        <c:if test="${sessionScope.loggedUser.roleName != 'Customer'}">
                            <div class="form-group" style="margin-bottom: 25px;">
                                <label for="searchPhone" class="form-label"
                                    style="font-weight: 600; display: block; margin-bottom: 8px;">Tra Cứu Bệnh Nhân Bằng
                                    SĐT <span style="color: var(--error);">*</span></label>
                                <div style="display: flex; gap: 10px; align-items: stretch;">
                                    <input type="tel" id="searchPhone" class="form-input-sci"
                                        placeholder="Nhập số điện thoại bệnh nhân..." style="flex: 1; min-width: 0;"
                                        onkeypress="if(event.key === 'Enter') { event.preventDefault(); checkPatientPhone(); }">
                                    <button type="button" id="btnSearchPhone" class="btn btn-primary"
                                        onclick="checkPatientPhone()"
                                        style="width: auto !important; flex-shrink: 0; border-radius: 12px; padding: 0 20px; white-space: nowrap; display: flex; align-items: center; justify-content: center;">
                                        <i class="fa-solid fa-magnifying-glass" style="margin-right: 6px;"></i> Tra Cứu
                                    </button>
                                </div>

                                <!-- Selected Patient Info Display -->
                                <div id="selectedPatientInfo"
                                    style="display: none; margin-top: 15px; padding: 15px; background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 12px; align-items: center; gap: 10px;">
                                    <i class="fa-solid fa-circle-check" style="color: #16a34a; font-size: 1.5rem;"></i>
                                    <div>
                                        <strong id="displayPatientName"
                                            style="color: #166534; display: block; font-size: 1.05rem;"></strong>
                                        <span id="displayPatientCode" style="color: #15803d; font-size: 0.9rem;"></span>
                                    </div>
                                    <button type="button" onclick="clearPatientSelection()"
                                        style="margin-left: auto; background: none; border: none; color: #dc2626; cursor: pointer; padding: 5px;"
                                        title="Chọn lại">
                                        <i class="fa-solid fa-xmark"></i>
                                    </button>
                                </div>

                                <!-- Hidden patientId -->
                                <input type="hidden" id="patientId" name="patientId" required>
                            </div>
                        </c:if>

                        <div class="form-group" style="margin-bottom: 25px;">
                            <label for="serviceId" class="form-label"
                                style="font-weight: 600; display: block; margin-bottom: 8px;">Dịch Vụ (Tùy chọn)</label>
                            <select id="serviceId" name="serviceId" class="form-select-sci"
                                onchange="fetchAvailableSlots()">
                                <option value="">-- Khám Tổng Quát / Tư Vấn --</option>
                                <c:forEach var="svc" items="${services}">
                                    <option value="${svc.serviceId}" ${param.serviceId==svc.serviceId ? 'selected' : ''
                                        }>${svc.serviceName} (${svc.estimatedMinutes} phút)</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group" style="margin-bottom: 25px;">
                            <label for="doctorId" class="form-label"
                                style="font-weight: 600; display: block; margin-bottom: 8px;">Chọn Bác Sĩ <span
                                    style="color: var(--error);">*</span></label>
                            <select id="doctorId" name="doctorId" class="form-select-sci" required
                                onchange="fetchAvailableSlots()">
                                <option value="">-- Vui lòng chọn bác sĩ --</option>
                                <c:forEach var="doc" items="${doctors}">
                                    <option value="${doc.doctorId}" ${param.doctorId==doc.doctorId ? 'selected' : '' }>
                                        ${doc.fullName} - ${doc.specialty}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div>
                        <div class="form-group" style="margin-bottom: 25px;">
                            <label for="bookingDate" class="form-label"
                                style="font-weight: 600; display: block; margin-bottom: 8px;">Ngày Khám <span
                                    style="color: var(--error);">*</span></label>
                            <input type="date" id="bookingDate" class="form-input-sci" required
                                min="${java.time.LocalDate.now()}" onchange="fetchAvailableSlots()">
                        </div>

                        <div class="form-group" style="margin-bottom: 25px;">
                            <label class="form-label" style="font-weight: 600; display: block; margin-bottom: 8px;">Giờ
                                Khám (Chọn ngày & bác sĩ để xem giờ rảnh) <span
                                    style="color: var(--error);">*</span></label>
                            <div id="slotsContainer" class="slots-grid-sci"
                                style="min-height: 100px; padding: 15px; border: 2px dashed #e2e8f0; border-radius: 12px;">
                                <div style="grid-column: 1/-1; text-align: center; color: var(--color-text-muted);">
                                    Vui lòng chọn Bác sĩ và Ngày khám trước.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <input type="hidden" id="scheduledDatetime" name="scheduledDatetime" required>

                <div
                    style="margin-top: 30px; display: flex; justify-content: flex-end; gap: 15px; padding-top: 20px; border-top: 1px solid #e2e8f0;">
                    <a href="${pageContext.request.contextPath}/appointments" class="btn btn-outline-secondary"
                        style="padding: 12px 25px; border-radius: 50px;">Hủy</a>
                    <button type="submit" id="btnSubmitForm" class="btn btn-primary"
                        style="padding: 12px 30px; border-radius: 50px;" disabled>
                        <i class="fa-solid fa-check me-2"></i> Xác Nhận Tạo Lịch
                    </button>
                </div>
            </form>
        </div>

        <script>
            let selectedTime = null;

            async function fetchAvailableSlots() {
                const doctorId = document.getElementById('doctorId').value;
                const date = document.getElementById('bookingDate').value;
                const serviceId = document.getElementById('serviceId').value;
                const slotsContainer = document.getElementById('slotsContainer');
                const submitBtn = document.getElementById('btnSubmitForm');

                selectedTime = null;
                document.getElementById('scheduledDatetime').value = '';
                submitBtn.disabled = true;

                if (!doctorId || !date) {
                    slotsContainer.innerHTML = '<div style="grid-column: 1/-1; text-align: center; color: var(--color-text-muted);">Vui lòng chọn Bác sĩ và Ngày khám trước.</div>';
                    return;
                }

                slotsContainer.innerHTML = '<div style="grid-column: 1/-1; text-align: center; color: var(--color-primary); padding: 20px;"><i class="fa-solid fa-spinner fa-spin fa-2x"></i></div>';

                try {
                    const params = new URLSearchParams({ doctorId, date });
                    if (serviceId) params.append('serviceId', serviceId);

                    const response = await fetch('${pageContext.request.contextPath}/api/doctor/slots?' + params.toString());
                    const data = await response.json();

                    slotsContainer.innerHTML = '';

                    if (data.status === 'success' && data.slots.length > 0) {
                        data.slots.forEach(time => {
                            const btn = document.createElement('button');
                            btn.type = 'button';
                            btn.className = 'slot-btn-sci';
                            btn.textContent = time;
                            btn.onclick = () => selectSlot(btn, time, date);
                            slotsContainer.appendChild(btn);
                        });
                    } else {
                        slotsContainer.innerHTML = '<div style="grid-column: 1/-1; text-align: center; color: var(--error); padding: 20px; font-weight: 500;">Bác sĩ đã kín lịch hoặc không có ca làm việc trong ngày này.</div>';
                    }
                } catch (error) {
                    console.error("Error fetching slots:", error);
                    slotsContainer.innerHTML = '<div style="grid-column: 1/-1; text-align: center; color: var(--error); padding: 20px;">Lỗi kết nối. Vui lòng thử lại.</div>';
                }
            }

            function selectSlot(btn, time, date) {
                document.querySelectorAll('#slotsContainer .slot-btn-sci').forEach(b => b.classList.remove('selected'));
                btn.classList.add('selected');
                selectedTime = time;

                // Cập nhật giá trị ẩn theo định dạng backend cần (YYYY-MM-DDTHH:mm)
                document.getElementById('scheduledDatetime').value = date + 'T' + time;
                document.getElementById('btnSubmitForm').disabled = false;
            }

            function validateForm() {
                try {
                    if (document.getElementById('patientId') && !document.getElementById('patientId').value && '${sessionScope.loggedUser.roleName}' !== 'Customer') {
                        showAlertModal('Vui lòng tra cứu và chọn bệnh nhân!', 'warning');
                        return false;
                    }

                    if (!selectedTime) {
                        showAlertModal('Vui lòng chọn khung giờ khám!', 'warning');
                        return false;
                    }

                    const dateStr = document.getElementById('bookingDate').value;
                    // Format for datetime-local: YYYY-MM-DDTHH:mm
                    document.getElementById('scheduledDatetime').value = dateStr + 'T' + selectedTime;

                    return true;
                } catch (e) {
                    console.error(e);
                    return false;
                }
            }

            function checkPatientPhone() {
                const phoneInput = document.getElementById('searchPhone');
                const phone = phoneInput.value.trim();
                const btn = document.getElementById('btnSearchPhone');

                if (!phone) {
                    showAlertModal('Vui lòng nhập số điện thoại để tra cứu.', 'warning');
                    return;
                }

                btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Tra cứu...';
                btn.disabled = true;

                fetch('${pageContext.request.contextPath}/api/patient?phone=' + encodeURIComponent(phone))
                    .then(res => res.json())
                    .then(data => {
                        if (data.success && data.patients && data.patients.length > 0) {
                            if (data.patients.length === 1) {
                                selectPatient(data.patients[0]);
                            } else {
                                showPatientSelectionModal(data.patients);
                            }
                        } else {
                            showQuickCreateModal(phone);
                        }
                    })
                    .catch(err => {
                        console.error(err);
                        showAlertModal('Có lỗi xảy ra khi tra cứu.', 'error');
                    })
                    .finally(() => {
                        btn.innerHTML = '<i class="fa-solid fa-magnifying-glass"></i> Tra Cứu';
                        btn.disabled = false;
                    });
            }

            function selectPatient(patient) {
                document.getElementById('patientId').value = patient.patientId;

                // Hide search input, show selected info
                document.getElementById('searchPhone').parentElement.style.display = 'none';
                document.getElementById('searchPhone').value = '';

                const infoDiv = document.getElementById('selectedPatientInfo');
                infoDiv.style.display = 'flex';
                document.getElementById('displayPatientName').textContent = patient.fullName;
                document.getElementById('displayPatientCode').textContent = `Mã BN: ${patient.patientCode} - SĐT: ${patient.phoneNumber}`;
            }

            function clearPatientSelection() {
                document.getElementById('patientId').value = '';
                document.getElementById('selectedPatientInfo').style.display = 'none';
                document.getElementById('searchPhone').parentElement.style.display = 'flex';
            }

            function showPatientSelectionModal(patients) {
                const container = document.getElementById('patientListContainer');
                container.innerHTML = '';

                patients.forEach((p) => {
                    const div = document.createElement('div');
                    div.style.padding = '12px 15px';
                    div.style.border = '1px solid var(--border-color)';
                    div.style.marginBottom = '10px';
                    div.style.borderRadius = '8px';
                    div.style.cursor = 'pointer';
                    div.style.display = 'flex';
                    div.style.justifyContent = 'space-between';
                    div.style.alignItems = 'center';
                    div.style.transition = 'all 0.2s ease';

                    div.onmouseover = () => { div.style.backgroundColor = '#f0fdf4'; div.style.borderColor = '#bbf7d0'; };
                    div.onmouseout = () => { div.style.backgroundColor = 'transparent'; div.style.borderColor = 'var(--border-color)'; };

                    div.onclick = () => {
                        selectPatient(p);
                        closePatientModal();
                    };

                    const dob = p.dateOfBirth ? p.dateOfBirth : 'Chưa cập nhật';

                    div.innerHTML = `
                <div>
                    <strong style="color: var(--primary); font-size: 1.05rem;">${p.fullName}</strong>
                    <div style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 4px;">Mã BN: ${p.patientCode} | Ngày sinh: ${dob}</div>
                </div>
                <i class="fa-solid fa-chevron-right" style="color: #cbd5e1;"></i>
            `;
                    container.appendChild(div);
                });

                document.getElementById('patientSelectionModal').style.display = 'flex';
            }

            function closePatientModal() {
                document.getElementById('patientSelectionModal').style.display = 'none';
            }

            function showQuickCreateModal(phone) {
                document.getElementById('qcPhone').value = phone;
                document.getElementById('qcFullName').value = '';
                document.getElementById('qcDob').value = '';
                document.getElementById('quickCreatePatientModal').style.display = 'flex';
            }

            function closeQuickCreateModal() {
                document.getElementById('quickCreatePatientModal').style.display = 'none';
            }

            function submitQuickCreatePatient() {
                const btn = document.getElementById('btnSubmitQC');
                btn.disabled = true;
                btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang lưu...';

                const formData = new URLSearchParams();
                formData.append('phone', document.getElementById('qcPhone').value);
                formData.append('fullName', document.getElementById('qcFullName').value);
                formData.append('dateOfBirth', document.getElementById('qcDob').value);
                formData.append('gender', document.getElementById('qcGender').value);

                fetch('${pageContext.request.contextPath}/api/patient', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData.toString()
                })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        closeQuickCreateModal();
                        selectPatient(data.patient);
                        if (typeof showAlertModal === 'function') {
                            showAlertModal('Tạo hồ sơ thành công!', 'success');
                        } else {
                            alert('Tạo hồ sơ thành công!');
                        }
                    } else {
                        if (typeof showAlertModal === 'function') {
                            showAlertModal(data.message, 'error');
                        } else {
                            alert(data.message);
                        }
                    }
                })
                .catch(err => {
                    console.error(err);
                    if (typeof showAlertModal === 'function') {
                        showAlertModal('Có lỗi xảy ra khi tạo hồ sơ.', 'error');
                    } else {
                        alert('Có lỗi xảy ra khi tạo hồ sơ.');
                    }
                })
                .finally(() => {
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fa-solid fa-check"></i> Lưu & Chọn';
                });
            }
        </script>

        <!-- Modal chọn bệnh nhân -->
        <div id="patientSelectionModal"
            style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center;">
            <div
                style="background: white; padding: 25px; border-radius: 12px; max-width: 500px; width: 90%; box-shadow: 0 10px 25px rgba(0,0,0,0.2);">
                <h4 style="margin-top: 0; color: var(--primary);"><i class="fa-solid fa-users"></i> Chọn Hồ Sơ Bệnh Nhân
                </h4>
                <p style="color: var(--text-secondary); margin-bottom: 20px;">Tìm thấy nhiều hồ sơ dùng chung số điện
                    thoại này. Vui lòng chọn:</p>

                <div id="patientListContainer" style="max-height: 300px; overflow-y: auto; margin-bottom: 20px;">
                    <!-- Danh sách bệnh nhân sẽ được render ở đây -->
                </div>

                <div
                    style="display: flex; justify-content: flex-end; gap: 10px; border-top: 1px solid var(--border-color); padding-top: 15px;">
                    <button type="button" class="btn btn-outline-secondary" onclick="closePatientModal()">Hủy</button>
                    <a href="${pageContext.request.contextPath}/patient-form" target="_blank" class="btn btn-primary"><i
                            class="fa-solid fa-plus"></i> Tạo hồ sơ chi tiết</a>
                </div>
            </div>
        </div>

        <!-- Modal tạo nhanh bệnh nhân -->
        <div id="quickCreatePatientModal"
            style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center;">
            <div
                style="background: white; padding: 25px; border-radius: 12px; max-width: 500px; width: 90%; box-shadow: 0 10px 25px rgba(0,0,0,0.2);">
                <h4 style="margin-top: 0; color: var(--primary);"><i class="fa-solid fa-user-plus"></i> Tạo Nhanh Hồ Sơ Bệnh Nhân</h4>
                <p style="color: var(--text-secondary); margin-bottom: 20px;">Không tìm thấy bệnh nhân. Vui lòng điền thông tin để tạo nhanh hồ sơ và tiếp tục đặt lịch.</p>

                <form id="quickCreatePatientForm" onsubmit="event.preventDefault(); submitQuickCreatePatient();">
                    <div class="form-group" style="margin-bottom: 15px;">
                        <label class="form-label" style="font-weight: 600;">Số Điện Thoại</label>
                        <input type="text" id="qcPhone" name="phone" class="form-input-sci" readonly style="background-color: #f8fafc;">
                    </div>
                    <div class="form-group" style="margin-bottom: 15px;">
                        <label class="form-label" style="font-weight: 600;">Họ và Tên <span style="color: red;">*</span></label>
                        <input type="text" id="qcFullName" name="fullName" class="form-input-sci" required placeholder="Nhập họ tên bệnh nhân">
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 20px;">
                        <div class="form-group">
                            <label class="form-label" style="font-weight: 600;">Ngày Sinh</label>
                            <input type="date" id="qcDob" name="dateOfBirth" class="form-input-sci">
                        </div>
                        <div class="form-group">
                            <label class="form-label" style="font-weight: 600;">Giới Tính</label>
                            <select id="qcGender" name="gender" class="form-select-sci">
                                <option value="Male">Nam</option>
                                <option value="Female">Nữ</option>
                                <option value="Other">Khác</option>
                            </select>
                        </div>
                    </div>
                    
                    <div style="display: flex; justify-content: flex-end; gap: 10px; border-top: 1px solid var(--border-color); padding-top: 15px;">
                        <button type="button" class="btn btn-outline-secondary" onclick="closeQuickCreateModal()">Hủy</button>
                        <button type="submit" id="btnSubmitQC" class="btn btn-primary"><i class="fa-solid fa-check"></i> Lưu & Chọn</button>
                    </div>
                </form>
            </div>
        </div>

        <jsp:include page="/WEB-INF/views/layout/footer.jsp" />