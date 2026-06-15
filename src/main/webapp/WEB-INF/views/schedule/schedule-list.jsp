<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="currentPage" value="schedules" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Lịch Làm Việc" />
</jsp:include>

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
    <h2 style="color: var(--primary); margin: 0;"><i class="fa-solid fa-calendar-days"></i> Lịch Làm Việc</h2>
    <c:if test="${sessionScope.loggedUser.roleName == 'Admin'}">
        <button class="btn btn-primary" style="width: auto;" onclick="openAddModal()">
            <i class="fa-solid fa-plus"></i> Phân Công Lịch
        </button>
    </c:if>
</div>

<jsp:include page="/WEB-INF/views/components/messages.jsp" />

<div class="card mb-4" style="padding: 20px;">
    <form action="${pageContext.request.contextPath}/schedules" method="GET" style="display: flex; gap: 15px; flex-wrap: wrap; align-items: flex-end;">
        <c:if test="${sessionScope.loggedUser.roleName != 'Doctor' && sessionScope.loggedUser.roleName != 'Technician'}">
            <div class="form-group" style="flex: 1; min-width: 200px; margin-bottom: 0;">
                <label class="form-label">Chọn Nhân Viên</label>
                <select name="userId" class="form-control">
                    <option value="">-- Tất cả nhân viên --</option>
                    <c:forEach var="emp" items="${employees}">
                        <option value="${emp.userId}" ${filterUserId == emp.userId ? 'selected' : ''}>${emp.fullName} - ${emp.roleName}</option>
                    </c:forEach>
                </select>
            </div>
        </c:if>
        <div class="form-group" style="flex: 1; min-width: 150px; margin-bottom: 0;">
            <label class="form-label">Từ ngày</label>
            <input type="date" name="startDate" class="form-control" value="${startDate}">
        </div>
        <div class="form-group" style="flex: 1; min-width: 150px; margin-bottom: 0;">
            <label class="form-label">Đến ngày</label>
            <input type="date" name="endDate" class="form-control" value="${endDate}">
        </div>
        <button type="submit" class="btn btn-outline-primary" style="width: auto; height: 42px;"><i class="fa-solid fa-filter"></i> Lọc</button>
    </form>
</div>

<div class="card" style="padding: 0;">
    <div style="overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse; min-width: 800px;">
            <thead>
                <tr style="border-bottom: 2px solid var(--border-color); text-align: left; background: #f8fafc;">
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Nhân Viên</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Chức Vụ</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Ngày Làm Việc</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Ca Trực</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Giờ Làm Việc</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Giới Hạn Khách</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Trạng Thái</th>
                    <c:if test="${sessionScope.loggedUser.roleName == 'Admin'}">
                        <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); text-align: right;">Thao Tác</th>
                    </c:if>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty schedules}">
                        <tr>
                            <td colspan="7" style="padding: 30px; text-align: center; color: #64748b;">
                                Không tìm thấy lịch làm việc nào trong khoảng thời gian này.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${schedules}">
                            <tr style="border-bottom: 1px solid var(--border-color); transition: background 0.2s;">
                                <td style="padding: 15px 12px;">
                                    <strong>${item.employeeName}</strong>
                                </td>
                                <td style="padding: 15px 12px;">
                                    <span style="font-size: 0.85rem; color: #64748b;">${item.roleName}</span>
                                </td>
                                <td style="padding: 15px 12px;">
                                    <fmt:formatDate value="${item.workDate}" pattern="dd/MM/yyyy" />
                                </td>
                                <td style="padding: 15px 12px;">
                                    <c:choose>
                                        <c:when test="${item.shift == 'Morning'}"><span class="badge badge-info">Sáng</span></c:when>
                                        <c:when test="${item.shift == 'Afternoon'}"><span class="badge badge-warning">Chiều</span></c:when>
                                    </c:choose>
                                </td>
                                <td style="padding: 15px 12px;">
                                    <c:choose>
                                        <c:when test="${item.isDayOff}">-</c:when>
                                        <c:otherwise>
                                            <fmt:formatDate value="${item.startTime}" pattern="HH:mm" /> - <fmt:formatDate value="${item.endTime}" pattern="HH:mm" />
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="padding: 15px 12px;">
                                    ${item.maxPatients > 0 ? item.maxPatients : 'Không giới hạn'}
                                </td>
                                <td style="padding: 15px 12px;">
                                    <c:choose>
                                        <c:when test="${item.isDayOff}">
                                            <span class="badge badge-error">Ngày nghỉ</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-success">Làm việc</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <c:if test="${sessionScope.loggedUser.roleName == 'Admin'}">
                                    <td style="padding: 15px 12px; text-align: right;">
                                        <button class="btn btn-outline-primary" style="padding: 6px 12px; font-size: 0.85rem;" 
                                                onclick="openEditModal(${item.scheduleId}, ${item.userId}, '${item.workDate}', '${item.shift}', '${item.startTime}', '${item.endTime}', ${item.maxPatients}, ${item.isDayOff})">
                                            Sửa
                                        </button>
                                        <form action="${pageContext.request.contextPath}/schedules" method="POST" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa lịch trực này?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="scheduleId" value="${item.scheduleId}">
                                            <button type="submit" class="btn" style="background: none; border: none; color: var(--error); cursor: pointer; padding: 6px 12px;"><i class="fa-solid fa-trash"></i></button>
                                        </form>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<c:if test="${sessionScope.loggedUser.roleName == 'Admin'}">
<!-- Modal Schedule -->
<div id="scheduleModal" class="modal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center;">
    <div class="card" style="width: 100%; max-width: 500px; padding: 30px; animation: slideUp 0.3s ease;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h3 id="modalTitle" style="margin: 0; color: var(--primary);">Thêm Lịch Làm Việc</h3>
            <button onclick="closeModal()" style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #64748b;">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/schedules" method="POST" class="validate-form" novalidate>
            <input type="hidden" name="action" id="modalAction" value="add">
            <input type="hidden" name="scheduleId" id="modalScheduleId" value="">

            <div class="form-group mb-3">
                <label class="form-label">Nhân Viên <span style="color: var(--error);">*</span></label>
                <select name="userId" id="modalUserId" class="form-control" required>
                    <option value="">-- Chọn nhân viên --</option>
                    <c:forEach var="emp" items="${employees}">
                        <option value="${emp.userId}">${emp.fullName} - ${emp.roleName}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group mb-3">
                <label class="form-label">Ngày Làm Việc <span style="color: var(--error);">*</span></label>
                <input type="date" name="workDate" id="modalWorkDate" class="form-control" required>
            </div>

            <div class="form-group mb-3">
                <label class="form-label">Ca Trực <span style="color: var(--error);">*</span></label>
                <select name="shift" id="modalShift" class="form-control" required>
                    <option value="Morning">Sáng</option>
                    <option value="Afternoon">Chiều</option>
                </select>
            </div>

            <div style="display: flex; gap: 15px;">
                <div class="form-group mb-3" style="flex: 1;">
                    <label class="form-label">Giờ Bắt Đầu <span style="color: var(--error);">*</span></label>
                    <input type="time" name="startTime" id="modalStartTime" class="form-control" required value="08:00">
                </div>
                <div class="form-group mb-3" style="flex: 1;">
                    <label class="form-label">Giờ Kết Thúc <span style="color: var(--error);">*</span></label>
                    <input type="time" name="endTime" id="modalEndTime" class="form-control" required value="12:00">
                </div>
            </div>

            <div class="form-group mb-3">
                <label class="form-label">Số Lượng Bệnh Nhân Tối Đa</label>
                <input type="number" name="maxPatients" id="modalMaxPatients" class="form-control" min="0" value="0" placeholder="0 = không giới hạn">
            </div>

            <div class="form-group mb-4" style="display: flex; flex-direction: row; align-items: center; justify-content: flex-start; gap: 10px;">
                <input type="checkbox" name="isDayOff" id="modalIsDayOff" value="true" style="width: 20px; height: 20px; cursor: pointer; margin: 0;">
                <label for="modalIsDayOff" style="cursor: pointer; margin: 0; font-weight: 500; color: var(--text-main);">Đánh dấu là Ngày nghỉ</label>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px;">
                <button type="button" class="btn btn-outline-secondary" onclick="closeModal()">Hủy</button>
                <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddModal() {
        document.getElementById('modalTitle').innerText = 'Phân Công Lịch Mới';
        document.getElementById('modalAction').value = 'add';
        document.getElementById('modalScheduleId').value = '';
        
        document.getElementById('modalUserId').value = '';
        document.getElementById('modalWorkDate').value = '';
        document.getElementById('modalShift').value = 'Morning';
        document.getElementById('modalStartTime').value = '08:00';
        document.getElementById('modalEndTime').value = '12:00';
        document.getElementById('modalMaxPatients').value = '0';
        document.getElementById('modalIsDayOff').checked = false;
        
        document.getElementById('scheduleModal').style.display = 'flex';
    }

    function openEditModal(id, userId, workDate, shift, startTime, endTime, maxPatients, isDayOff) {
        document.getElementById('modalTitle').innerText = 'Cập Nhật Lịch Trực';
        document.getElementById('modalAction').value = 'update';
        document.getElementById('modalScheduleId').value = id;
        
        document.getElementById('modalUserId').value = userId;
        // Edit mode doesn't allow changing doctor/date/shift easily if we want to keep it strict, 
        // but let's allow it as form supports it. Or disable them:
        document.getElementById('modalWorkDate').value = workDate;
        document.getElementById('modalShift').value = shift;
        
        document.getElementById('modalStartTime').value = startTime.substring(0,5);
        document.getElementById('modalEndTime').value = endTime.substring(0,5);
        document.getElementById('modalMaxPatients').value = maxPatients;
        document.getElementById('modalIsDayOff').checked = isDayOff;
        
        document.getElementById('scheduleModal').style.display = 'flex';
    }

    function closeModal() {
        document.getElementById('scheduleModal').style.display = 'none';
    }

    // Lắng nghe sự kiện submit form để validate
    document.querySelector('.validate-form').addEventListener('submit', function(e) {
        let isValid = true;
        
        // Xóa thông báo lỗi cũ
        document.querySelectorAll('.error-message').forEach(el => el.remove());

        // Validate ngày làm việc phải >= hôm nay
        const workDateStr = document.getElementById('modalWorkDate').value;
        if (workDateStr) {
            const selectedDate = new Date(workDateStr);
            selectedDate.setHours(0, 0, 0, 0);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            if (selectedDate < today) {
                showError('modalWorkDate', 'Ngày làm việc không được ở trong quá khứ.');
                isValid = false;
            }
        }

        // Validate giờ nếu không phải ngày nghỉ
        const isDayOff = document.getElementById('modalIsDayOff').checked;
        if (!isDayOff) {
            const startTime = document.getElementById('modalStartTime').value;
            const endTime = document.getElementById('modalEndTime').value;
            if (startTime && endTime) {
                if (startTime >= endTime) {
                    showError('modalEndTime', 'Giờ kết thúc phải lớn hơn Giờ bắt đầu.');
                    isValid = false;
                }
            }
        }

        if (!isValid) {
            e.preventDefault(); // Ngăn form submit nếu có lỗi
        }
    });

    function showError(inputId, message) {
        const inputEl = document.getElementById(inputId);
        const errorEl = document.createElement('div');
        errorEl.className = 'error-message';
        errorEl.style.color = 'var(--error, #ef4444)';
        errorEl.style.fontSize = '0.85rem';
        errorEl.style.marginTop = '5px';
        errorEl.innerText = message;
        inputEl.parentNode.appendChild(errorEl);
    }
</script>
</c:if>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
