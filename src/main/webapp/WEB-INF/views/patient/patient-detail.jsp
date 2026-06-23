<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="currentPage" value="patients" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Chi Tiết Bệnh Nhân - Dental Clinic" />
</jsp:include>

<div style="margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center;">
    <a href="${pageContext.request.contextPath}/patients" style="color: var(--text-secondary); text-decoration: none; display: flex; align-items: center; gap: 8px;">
        <i class="fa-solid fa-arrow-left"></i> Quay lại danh sách
    </a>
    
    <div style="display: flex; gap: 10px;">
        <a href="${pageContext.request.contextPath}/patients/update?id=${patient.patientId}" class="btn btn-primary" style="width: auto;">
            <i class="fa-solid fa-pen"></i> Chỉnh Sửa
        </a>
        <c:if test="${sessionScope.loggedUser.roleName == 'Admin' || sessionScope.loggedUser.roleName == 'Receptionist'}">
            <form action="${pageContext.request.contextPath}/patients/delete" method="POST" style="margin: 0;" onsubmit="event.preventDefault(); const form = this; showConfirmModal('Bạn có chắc chắn muốn xoá hồ sơ bệnh nhân này không? Dữ liệu không thể khôi phục.', () => form.submit(), 'danger');">
                <input type="hidden" name="id" value="${patient.patientId}">
                <button type="submit" class="btn" style="background-color: var(--error); color: white; width: auto; border: none;">
                    <i class="fa-solid fa-trash"></i> Xoá
                </button>
            </form>
        </c:if>
    </div>
</div>

<div class="card" style="padding: 30px;">
    <div style="display: flex; align-items: flex-start; gap: 20px; border-bottom: 1px solid var(--border-color); padding-bottom: 20px; margin-bottom: 25px;">
        <div style="width: 80px; height: 80px; border-radius: 50%; background-color: var(--primary-light); color: var(--primary); display: flex; align-items: center; justify-content: center; font-size: 2rem;">
            <i class="fa-solid ${patient.gender == 'Female' ? 'fa-person-dress' : 'fa-person'}"></i>
        </div>
        <div>
            <h2 style="color: var(--text-primary); margin: 0 0 10px 0; font-size: 1.8rem;">
                ${patient.fullName}
                <c:if test="${not empty patient.drugAllergies && patient.drugAllergies != 'Không' && patient.drugAllergies != 'không'}">
                    <i class="fa-solid fa-triangle-exclamation" style="color: var(--error); font-size: 1.2rem; margin-left: 10px;" title="Cảnh báo dị ứng thuốc"></i>
                </c:if>
            </h2>
            <div style="display: flex; gap: 15px; color: var(--text-secondary); font-size: 0.95rem;">
                <span><i class="fa-solid fa-hashtag" style="width: 20px;"></i> ${patient.patientCode}</span>
                <span><i class="fa-solid fa-phone" style="width: 20px;"></i> ${patient.phoneNumber}</span>
                <c:if test="${not empty patient.email}">
                    <span><i class="fa-solid fa-envelope" style="width: 20px;"></i> ${patient.email}</span>
                </c:if>
            </div>
        </div>
    </div>

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px;">
        <!-- Thông tin cá nhân -->
        <div>
            <h4 style="margin-bottom: 20px; color: var(--text-primary); font-size: 1.2rem; border-left: 4px solid var(--primary); padding-left: 10px;">Thông Tin Cá Nhân</h4>
            
            <table style="width: 100%; border-collapse: collapse;">
                <tr>
                    <td style="padding: 12px 0; border-bottom: 1px solid #f1f5f9; color: var(--text-secondary); width: 150px;">Ngày sinh:</td>
                    <td style="padding: 12px 0; border-bottom: 1px solid #f1f5f9; font-weight: 500;">
                        <fmt:formatDate value="${patient.dateOfBirth}" pattern="dd/MM/yyyy" />
                    </td>
                </tr>
                <tr>
                    <td style="padding: 12px 0; border-bottom: 1px solid #f1f5f9; color: var(--text-secondary);">Giới tính:</td>
                    <td style="padding: 12px 0; border-bottom: 1px solid #f1f5f9; font-weight: 500;">
                        <c:choose>
                            <c:when test="${patient.gender == 'Male'}">Nam</c:when>
                            <c:when test="${patient.gender == 'Female'}">Nữ</c:when>
                            <c:otherwise>Khác</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 12px 0; border-bottom: 1px solid #f1f5f9; color: var(--text-secondary);">Tài khoản liên kết:</td>
                    <td style="padding: 12px 0; border-bottom: 1px solid #f1f5f9; font-weight: 500;">
                        <c:choose>
                            <c:when test="${not empty patient.userId}">
                                <span style="background-color: var(--success); color: white; padding: 4px 8px; border-radius: 4px; font-size: 0.8rem;">Đã liên kết</span>
                            </c:when>
                            <c:otherwise>
                                <span style="background-color: var(--text-secondary); color: white; padding: 4px 8px; border-radius: 4px; font-size: 0.8rem;">Khách vãng lai</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 12px 0; border-bottom: 1px solid #f1f5f9; color: var(--text-secondary);">Địa chỉ:</td>
                    <td style="padding: 12px 0; border-bottom: 1px solid #f1f5f9; font-weight: 500;">
                        ${empty patient.address ? '<em>Chưa cập nhật</em>' : patient.address}
                    </td>
                </tr>
                <tr>
                    <td style="padding: 12px 0; border-bottom: 1px solid #f1f5f9; color: var(--text-secondary);">Ngày tạo hồ sơ:</td>
                    <td style="padding: 12px 0; border-bottom: 1px solid #f1f5f9; font-weight: 500;">
                        <fmt:formatDate value="${patient.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                    </td>
                </tr>
            </table>
        </div>

        <!-- Thông tin y tế lâm sàng -->
        <div>
            <h4 style="margin-bottom: 20px; color: var(--text-primary); font-size: 1.2rem; border-left: 4px solid var(--error); padding-left: 10px;">Tiền sử y tế</h4>
            
            <c:choose>
                <c:when test="${sessionScope.loggedUser.roleName == 'Receptionist'}">
                    <div style="background-color: #f8fafc; padding: 20px; border-radius: 8px; border: 1px dashed var(--border-color); text-align: center; color: var(--text-secondary);">
                        <i class="fa-solid fa-lock" style="font-size: 2rem; margin-bottom: 10px; color: #cbd5e1;"></i>
                        <p style="margin: 0;">Thông tin y tế và tiền sử lâm sàng chỉ được hiển thị cho Bác sĩ điều trị và Quản trị viên do yêu cầu bảo mật.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="margin-bottom: 25px;">
                        <div style="color: var(--text-secondary); margin-bottom: 8px; font-weight: 500;">Dị ứng thuốc:</div>
                        <div style="background-color: ${not empty patient.drugAllergies && patient.drugAllergies != 'Không' && patient.drugAllergies != 'không' ? '#fee2e2' : '#f8fafc'}; 
                                    color: ${not empty patient.drugAllergies && patient.drugAllergies != 'Không' && patient.drugAllergies != 'không' ? 'var(--error)' : 'var(--text-primary)'}; 
                                    padding: 15px; border-radius: 8px; font-weight: ${not empty patient.drugAllergies && patient.drugAllergies != 'Không' && patient.drugAllergies != 'không' ? '600' : '400'};">
                            <c:choose>
                                <c:when test="${empty patient.drugAllergies}"><em>Chưa cập nhật</em></c:when>
                                <c:otherwise>${patient.drugAllergies}</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div>
                        <div style="color: var(--text-secondary); margin-bottom: 8px; font-weight: 500;">Tiền sử bệnh (Bệnh nền):</div>
                        <div style="background-color: #f8fafc; padding: 15px; border-radius: 8px; min-height: 100px; line-height: 1.6;">
                            <c:choose>
                                <c:when test="${empty patient.medicalHistory}"><em>Chưa cập nhật</em></c:when>
                                <c:otherwise>${patient.medicalHistory}</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
