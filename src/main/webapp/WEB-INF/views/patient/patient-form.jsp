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

    <form action="${pageContext.request.contextPath}/patients/create" method="POST" id="patientForm" class="validate-form">
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
                        <label class="form-label" for="dateOfBirth">Ngày sinh</label>
                        <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth">
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
                    <label class="form-label" for="phoneNumber">Số điện thoại</label>
                    <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" data-rule="phone" placeholder="Nhập số điện thoại">
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
            <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> Tạo Hồ Sơ Mới</button>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
