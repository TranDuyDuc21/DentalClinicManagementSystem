<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDate" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Đổi Lịch Khám" />
</jsp:include>

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customer-premium.css">

<style>
    .reschedule-container {
        max-width: 650px;
        margin: 60px auto;
        background: #fff;
        padding: 50px;
        border-radius: 20px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
        border-top: 6px solid var(--primary);
    }
    .reschedule-header {
        text-align: center;
        margin-bottom: 40px;
    }
    .reschedule-header h2 {
        color: var(--color-primary-dark);
        font-weight: 800;
        font-size: 2rem;
        margin-bottom: 15px;
    }
    .reschedule-header p {
        color: var(--text-secondary);
        font-size: 1.1rem;
    }
    .form-label {
        font-weight: 600;
        color: var(--text-primary);
        margin-bottom: 10px;
        display: block;
        font-size: 1.05rem;
    }
    .form-input-sci {
        width: 100%;
        padding: 14px 20px;
        border: 2px solid #e2e8f0;
        border-radius: 12px;
        font-size: 1rem;
        transition: all 0.3s ease;
        background-color: #f8fafc;
    }
    .form-input-sci:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 4px rgba(2, 132, 199, 0.1);
        outline: none;
        background-color: #fff;
    }
    .btn-submit-sci {
        width: 100%;
        padding: 16px;
        background: linear-gradient(135deg, var(--primary) 0%, #0ea5e9 100%);
        color: white;
        border: none;
        border-radius: 12px;
        font-size: 1.1rem;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s ease;
        margin-top: 20px;
        box-shadow: 0 4px 15px rgba(2, 132, 199, 0.3);
    }
    .btn-submit-sci:hover:not(:disabled) {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(2, 132, 199, 0.4);
        background: linear-gradient(135deg, #0ea5e9 0%, var(--primary) 100%);
        filter: brightness(1.1);
    }
    .btn-submit-sci:disabled {
        background: #cbd5e1;
        box-shadow: none;
        cursor: not-allowed;
        transform: none;
    }
    .btn-cancel-link {
        display: block;
        text-align: center;
        margin-top: 25px;
        color: var(--text-secondary);
        text-decoration: none;
        font-weight: 500;
        font-size: 1.05rem;
        transition: color 0.3s;
    }
    .btn-cancel-link:hover {
        color: var(--error);
    }
</style>

<div class="reschedule-container">
    <div class="reschedule-header">
        <h2><i class="fa-solid fa-calendar-check"></i> Đổi Lịch Khám</h2>
        <p>Vui lòng chọn ngày và giờ khám mới phù hợp với bạn.</p>
    </div>

    <jsp:include page="/WEB-INF/views/components/messages.jsp" />
    <form id="rescheduleForm" action="${pageContext.request.contextPath}/appointment-action" method="POST" onsubmit="event.preventDefault(); const form = this; showConfirmModal('Bạn có chắc chắn muốn xác nhận đổi lịch khám này?', () => HTMLFormElement.prototype.submit.call(form), 'primary');">
        <input type="hidden" name="action" value="reschedule">
        <input type="hidden" id="rescheduleApptId" name="appointmentId" value="${param.appointmentId}">
        <input type="hidden" id="rescheduleServiceId" name="serviceId" value="${param.serviceId}">
        <input type="hidden" id="rescheduleDoctorId" name="doctorId" value="${param.doctorId}">
        
        <div class="mb-4" style="margin-bottom: 25px;">
            <label class="form-label">Chọn ngày muốn đổi đến:</label>
            <input type="date" id="rescheduleDate" name="newDate" class="form-input-sci" required min="<%= LocalDate.now() %>" onchange="fetchRescheduleSlots()">
        </div>
        
        <div class="mb-4">
            <label class="form-label" style="font-weight: 600; color: var(--color-text-main);">Chọn khung giờ rảnh:</label>
            <div id="rescheduleSlots" class="slots-grid-sci">
                <div style="grid-column: 1/-1; text-align: center; color: #94a3b8; font-style: italic;">
                    Vui lòng chọn ngày để xem giờ rảnh.
                </div>
            </div>
            <input type="hidden" id="rescheduleSlotTime" name="newTime" required>
        </div>
        
        <button type="submit" id="btnConfirmReschedule" class="btn-submit-sci" style="margin-top: 10px;" disabled>
            Xác Nhận Đổi Lịch
        </button>
        
        <a href="${pageContext.request.contextPath}/appointments" class="btn-cancel-link">Hủy và Quay Lại</a>
    </form>
</div>

<script>
    async function fetchRescheduleSlots() {
        const date = document.getElementById('rescheduleDate').value;
        const serviceId = document.getElementById('rescheduleServiceId').value;
        const doctorId = document.getElementById('rescheduleDoctorId').value;
        const slotsContainer = document.getElementById('rescheduleSlots');
        
        if (!date || !doctorId) return;
        
        slotsContainer.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 20px;"><i class="fa-solid fa-spinner fa-spin"></i> Đang tải...</div>';
        
        try {
            const params = new URLSearchParams({ date: date, doctorId: doctorId });
            if (serviceId) params.append('serviceId', serviceId);
            
            const response = await fetch('${pageContext.request.contextPath}/api/doctor/slots?' + params.toString());
            const data = await response.json();
            
            slotsContainer.innerHTML = '';
            
            if (data.status === 'success' && data.slots.length > 0) {
                data.slots.forEach(slot => {
                    const btn = document.createElement('button');
                    btn.type = 'button';
                    btn.className = 'slot-btn-sci';
                    btn.textContent = slot;
                    btn.onclick = () => selectRescheduleSlot(btn, slot);
                    slotsContainer.appendChild(btn);
                });
            } else {
                slotsContainer.innerHTML = '<div style="grid-column: 1/-1; text-align: center; color: #dc2626; padding: 10px;">Bác sĩ đã kín lịch hoặc không có lịch làm việc trong ngày này.</div>';
                document.getElementById('rescheduleSlotTime').value = '';
                document.getElementById('btnConfirmReschedule').disabled = true;
            }
        } catch (error) {
            console.error('Error fetching slots:', error);
            slotsContainer.innerHTML = '<div style="grid-column: 1/-1; text-align: center; color: #dc2626;">Lỗi tải dữ liệu.</div>';
        }
    }
    
    function selectRescheduleSlot(btn, time) {
        document.querySelectorAll('#rescheduleSlots .slot-btn-sci').forEach(b => b.classList.remove('selected'));
        btn.classList.add('selected');
        document.getElementById('rescheduleSlotTime').value = time;
        document.getElementById('btnConfirmReschedule').disabled = false;
    }
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
