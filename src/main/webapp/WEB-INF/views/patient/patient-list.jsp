<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="currentPage" value="patients" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Hồ Sơ Bệnh Nhân - Dental Clinic" />
</jsp:include>

<div class="d-flex justify-content-between align-items-center" style="margin-bottom: 24px;">
    <div>
        <h2 style="color: var(--text-primary); margin-bottom: 8px;">Hồ Sơ Bệnh Nhân</h2>
        <p style="color: var(--text-secondary); margin: 0;">Quản lý và tra cứu hồ sơ y tế của bệnh nhân</p>
    </div>
    <a href="${pageContext.request.contextPath}/patients/create" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
        <i class="fa-solid fa-plus"></i> Thêm Hồ Sơ Mới
    </a>
</div>

<jsp:include page="/WEB-INF/views/components/messages.jsp" />

<t:searchFilter actionUrl="${pageContext.request.contextPath}/patients" searchPlaceholder="Tìm theo tên, mã bệnh nhân, số điện thoại..." searchValue="${param.search}">
    <!-- Hiện tại chỉ có search đơn giản, sau này nâng cấp ở UC18 có thể thêm filter theo giới tính, năm sinh... -->
</t:searchFilter>

<div class="card">
    <div style="overflow-x: auto;">
        <table class="table">
            <thead>
                <tr>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); border-bottom: 2px solid var(--border-color); width: 120px;">Mã BN</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); border-bottom: 2px solid var(--border-color);">Họ và tên</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); border-bottom: 2px solid var(--border-color);">Giới tính</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); border-bottom: 2px solid var(--border-color);">Ngày sinh</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); border-bottom: 2px solid var(--border-color);">Số điện thoại</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); border-bottom: 2px solid var(--border-color); text-align: left;">Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty patients}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 30px; color: var(--text-secondary);">
                                Không tìm thấy hồ sơ bệnh nhân nào.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="patient" items="${patients}">
                            <tr style="border-bottom: 1px solid var(--border-color); transition: background-color 0.2s;">
                                <td style="padding: 12px; font-weight: 500; color: var(--primary);">${patient.patientCode}</td>
                                <td style="padding: 12px; font-weight: 500;">
                                    ${patient.fullName}
                                    <c:if test="${not empty patient.drugAllergies}">
                                        <i class="fa-solid fa-triangle-exclamation" style="color: var(--error); margin-left: 5px;" title="Có dị ứng thuốc"></i>
                                    </c:if>
                                </td>
                                <td style="padding: 12px;">
                                    <c:choose>
                                        <c:when test="${patient.gender == 'Male'}">Nam</c:when>
                                        <c:when test="${patient.gender == 'Female'}">Nữ</c:when>
                                        <c:otherwise>Khác</c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="padding: 12px;">
                                    <fmt:formatDate value="${patient.dateOfBirth}" pattern="dd/MM/yyyy" />
                                </td>
                                <td style="padding: 12px;">${patient.phoneNumber}</td>
                                <td style="padding: 12px;">
                                    <div style="display: flex; gap: 15px; justify-content: flex-start; align-items: center;">
                                        <!-- Tạm thời trỏ tới trang tạo, sau này ở UC18 sẽ trỏ tới trang chi tiết -->
                                        <a href="${pageContext.request.contextPath}/patients/detail?id=${patient.patientId}" style="color: var(--primary); text-decoration: none; font-weight: 500; display: inline-flex; align-items: center; gap: 4px;" title="Xem chi tiết">
                                            <i class="fa-solid fa-eye"></i> Xem
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
