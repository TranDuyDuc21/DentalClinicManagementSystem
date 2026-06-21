<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="currentPage" value="booking" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Đặt Lịch Hẹn" />
</jsp:include>



<div class="container">
    
    <c:if test="${not empty sessionScope.errorMessage}">
        <div style="background: #fee2e2; color: #ef4444; padding: 15px; border-radius: 10px; margin: 20px 0; font-weight: 600; border-left: 4px solid #ef4444;">
            <i class="fa-solid fa-circle-exclamation"></i> ${sessionScope.errorMessage}
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <div class="booking-layout">
        <!-- Cột Trái: Form Điền Thông Tin -->
        <div class="booking-form-card">
            <h2 style="font-size: 2rem; font-weight: 800; color: #0f172a; margin-bottom: 40px;">Thông Tin Đặt Lịch</h2>
            
            <form id="bookingForm" action="${pageContext.request.contextPath}/booking" method="POST">
                <!-- Bước 1: Dịch Vụ -->
                <div class="booking-step-sci">
                    <div class="step-indicator">1</div>
                    <div class="step-content">
                        <h3>Chọn Dịch Vụ Nha Khoa</h3>
                        <select name="serviceId" id="serviceId" class="form-select-sci" required>
                            <option value="">-- Click để chọn dịch vụ --</option>
                            <c:forEach var="svc" items="${services}">
                                <option value="${svc.serviceId}" data-name="${svc.serviceName}" data-price="<fmt:formatNumber value="${svc.listedPrice}" type="number" maxFractionDigits="0"/> VNĐ" ${selectedService != null && selectedService.serviceId == svc.serviceId ? 'selected' : ''}>
                                    ${svc.serviceName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- Bước 2: Bác Sĩ -->
                <div class="booking-step-sci">
                    <div class="step-indicator">2</div>
                    <div class="step-content">
                        <h3>Chọn Chuyên Gia Phụ Trách</h3>
                        <select name="doctorId" id="doctorId" class="form-select-sci" required>
                            <option value="">-- Click để chọn bác sĩ --</option>
                            <c:forEach var="doc" items="${doctors}">
                                <option value="${doc.doctorId}" data-name="BS. ${doc.fullName}">BS. ${doc.fullName} - Chuyên khoa ${doc.specialty}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- Bước 3: Ngày Khám -->
                <div class="booking-step-sci">
                    <div class="step-indicator">3</div>
                    <div class="step-content">
                        <h3>Chọn Ngày Khám</h3>
                        <input type="date" name="bookingDate" id="bookingDate" class="form-input-sci" required min="<%= java.time.LocalDate.now().plusDays(1).toString() %>">
                    </div>
                </div>

                <!-- Bước 4: Giờ Khám -->
                <div class="booking-step-sci">
                    <div class="step-indicator">4</div>
                    <div class="step-content">
                        <h3>Khung Giờ Trống</h3>
                        <div id="loadingSlots" class="loading-spinner">
                            <i class="fa-solid fa-spinner fa-spin fa-2x"></i>
                            <p style="margin-top: 10px; font-weight: 500;">Đang tính toán giờ trống theo thời lượng dịch vụ...</p>
                        </div>
                        <div id="slotsContainer" class="slots-grid-sci">
                            <div style="grid-column: 1 / -1; color: #94a3b8; padding: 10px 0; font-style: italic;">
                                Vui lòng hoàn tất Bước 1, 2 và 3 để hệ thống hiển thị giờ khám phù hợp.
                            </div>
                        </div>
                        <input type="hidden" name="bookingTime" id="bookingTime" required>
                    </div>
                </div>
            </form>
        </div>

        <!-- Cột Phải: Bảng Tóm Tắt (Summary) -->
        <div class="booking-summary-card">
            <h3 class="summary-title"><i class="fa-regular fa-calendar-check"></i> Phiếu Tóm Tắt</h3>
            
            <div class="summary-item">
                <div class="summary-label">Dịch Vụ Đã Chọn</div>
                <div class="summary-value" id="sumService">Chưa chọn</div>
                <div style="font-size: 0.95rem; color: #fde047; margin-top: 5px; font-weight: 700;" id="sumPrice"></div>
            </div>
            
            <div class="summary-item">
                <div class="summary-label">Chuyên Gia</div>
                <div class="summary-value" id="sumDoctor">Chưa chọn</div>
            </div>
            
            <div class="summary-item">
                <div class="summary-label">Thời Gian Khám</div>
                <div class="summary-value" id="sumDateTime">Chưa chọn</div>
            </div>
            
            <div style="margin-top: 40px; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.2);">
                <button type="button" id="btnSubmitFake" class="btn-submit-sci" disabled>
                    Xác Nhận Đặt Lịch
                </button>
            </div>
        </div>
    </div>
</div>

<!-- SweetAlert2 cho Popup Confirm -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    const serviceSelect = document.getElementById('serviceId');
    const doctorSelect = document.getElementById('doctorId');
    const dateInput = document.getElementById('bookingDate');
    const slotsContainer = document.getElementById('slotsContainer');
    const loadingSlots = document.getElementById('loadingSlots');
    const timeInput = document.getElementById('bookingTime');
    const btnSubmitFake = document.getElementById('btnSubmitFake');
    const bookingForm = document.getElementById('bookingForm');

    // Summary Elements
    const sumService = document.getElementById('sumService');
    const sumPrice = document.getElementById('sumPrice');
    const sumDoctor = document.getElementById('sumDoctor');
    const sumDateTime = document.getElementById('sumDateTime');

    function updateSummary() {
        // Service
        if (serviceSelect.selectedIndex > 0) {
            const opt = serviceSelect.options[serviceSelect.selectedIndex];
            sumService.textContent = opt.getAttribute('data-name');
            sumPrice.textContent = "Giá: " + opt.getAttribute('data-price');
        } else {
            sumService.textContent = "Chưa chọn";
            sumPrice.textContent = "";
        }

        // Doctor
        if (doctorSelect.selectedIndex > 0) {
            const opt = doctorSelect.options[doctorSelect.selectedIndex];
            sumDoctor.textContent = opt.getAttribute('data-name');
        } else {
            sumDoctor.textContent = "Chưa chọn";
        }

        // DateTime
        const d = dateInput.value;
        const t = timeInput.value;
        if (d && t) {
            const parts = d.split('-');
            sumDateTime.textContent = t + " | " + parts[2] + "/" + parts[1] + "/" + parts[0];
        } else if (d) {
            const parts = d.split('-');
            sumDateTime.textContent = "Ngày " + parts[2] + "/" + parts[1] + "/" + parts[0] + " (Chưa chọn giờ)";
        } else {
            sumDateTime.textContent = "Chưa chọn";
        }
    }

    function fetchSlots() {
        const serviceId = serviceSelect.value;
        const doctorId = doctorSelect.value;
        const date = dateInput.value;

        // Reset
        timeInput.value = '';
        btnSubmitFake.disabled = true;
        updateSummary();

        if (serviceId && doctorId && date) {
            slotsContainer.innerHTML = '';
            loadingSlots.style.display = 'block';

            fetch(`${pageContext.request.contextPath}/api/doctor/slots?doctorId=\${doctorId}&serviceId=\${serviceId}&date=\${date}`)
                .then(response => response.json())
                .then(slots => {
                    loadingSlots.style.display = 'none';
                    if (slots.length === 0) {
                        slotsContainer.innerHTML = '<div style="grid-column: 1 / -1; color: #ef4444; font-weight: 600;">Không có khung giờ trống. Vui lòng chọn ngày khác.</div>';
                    } else {
                        slots.forEach(time => {
                            const btn = document.createElement('button');
                            btn.type = 'button';
                            btn.className = 'slot-btn-sci';
                            btn.textContent = time;
                            btn.onclick = function() {
                                document.querySelectorAll('.slot-btn-sci').forEach(b => b.classList.remove('selected'));
                                this.classList.add('selected');
                                timeInput.value = time;
                                btnSubmitFake.disabled = false;
                                updateSummary();
                            };
                            slotsContainer.appendChild(btn);
                        });
                    }
                })
                .catch(error => {
                    console.error('Error fetching slots:', error);
                    loadingSlots.style.display = 'none';
                    slotsContainer.innerHTML = '<div style="grid-column: 1 / -1; color: #ef4444; font-weight: 600;">Lỗi tải khung giờ.</div>';
                });
        } else {
            slotsContainer.innerHTML = '<div style="grid-column: 1 / -1; color: #94a3b8; font-style: italic;">Vui lòng hoàn tất Bước 1, 2 và 3 để xem khung giờ.</div>';
        }
    }

    serviceSelect.addEventListener('change', fetchSlots);
    doctorSelect.addEventListener('change', fetchSlots);
    dateInput.addEventListener('change', fetchSlots);

    // Xử lý Popup Confirm
    btnSubmitFake.addEventListener('click', function() {
        const isGuest = ${sessionScope.loggedUser == null};
        
        if (isGuest) {
            Swal.fire({
                title: 'Yêu Cầu Đăng Nhập',
                text: 'Bạn cần đăng nhập tài khoản để hệ thống lưu trữ và quản lý lịch hẹn của bạn.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#0ea5e9',
                cancelButtonColor: '#cbd5e1',
                confirmButtonText: 'Đăng Nhập Ngay',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = '${pageContext.request.contextPath}/login';
                }
            });
            return;
        }

        const serviceName = sumService.textContent;
        const doctorName = sumDoctor.textContent;
        const dt = sumDateTime.textContent;

        Swal.fire({
            title: 'Hoàn Tất Đặt Lịch',
            html: `
                <div style="text-align: left; margin-top: 15px; padding: 15px; background: #f8fafc; border-radius: 10px; border: 1px solid #e2e8f0;">
                    <p style="margin-bottom: 10px;"><strong><i class="fa-solid fa-tooth" style="color: #0ea5e9; width: 20px;"></i> Dịch vụ:</strong> \${serviceName}</p>
                    <p style="margin-bottom: 10px;"><strong><i class="fa-solid fa-user-doctor" style="color: #0ea5e9; width: 20px;"></i> Chuyên gia:</strong> \${doctorName}</p>
                    <p style="margin-bottom: 0;"><strong><i class="fa-regular fa-clock" style="color: #0ea5e9; width: 20px;"></i> Thời gian:</strong> \${dt}</p>
                </div>
            `,
            icon: 'success',
            showCancelButton: true,
            confirmButtonColor: '#0ea5e9',
            cancelButtonColor: '#cbd5e1',
            confirmButtonText: 'Xác Nhận Đặt',
            cancelButtonText: 'Hủy Bỏ'
        }).then((result) => {
            if (result.isConfirmed) {
                bookingForm.submit();
            }
        });
    });
    
    // Init summary on load if already selected
    if(serviceSelect.value) {
        updateSummary();
    }
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
