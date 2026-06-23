<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="currentPage" value="appointments" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Hồ Sơ Bệnh Án" />
</jsp:include>

<style>
    .record-container {
        max-width: 1000px;
        margin: 40px auto;
        padding: 0 20px;
    }
    
    .record-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        border-bottom: 2px solid var(--primary-light);
        padding-bottom: 15px;
    }
    
    .record-title {
        font-size: 2rem;
        font-weight: 700;
        color: var(--primary-dark);
        margin: 0;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .section-card {
        background: #fff;
        border-radius: var(--radius-xl);
        box-shadow: var(--shadow-md);
        padding: 30px;
        margin-bottom: 30px;
        border: 1px solid #e2e8f0;
    }
    
    .section-title {
        font-size: 1.4rem;
        font-weight: 600;
        color: var(--primary);
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 20px;
    }
    
    .info-group {
        margin-bottom: 15px;
    }
    
    .info-label {
        font-size: 0.9rem;
        color: var(--text-muted);
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 5px;
    }
    
    .info-value {
        font-size: 1.1rem;
        color: var(--text-main);
        font-weight: 500;
        background: #f8fafc;
        padding: 12px 15px;
        border-radius: 8px;
        border-left: 4px solid var(--primary);
    }
    
    .data-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
    }
    
    .data-table th {
        background: #f1f5f9;
        padding: 12px 15px;
        text-align: left;
        font-weight: 600;
        color: var(--text-secondary);
        border-bottom: 2px solid #e2e8f0;
    }
    
    .data-table td {
        padding: 15px;
        border-bottom: 1px solid #e2e8f0;
        color: var(--text-main);
        vertical-align: middle;
    }
    
    .data-table tr:last-child td {
        border-bottom: none;
    }
    
    .status-badge {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: 600;
    }
    
    .status-done {
        background: #dcfce7;
        color: #166534;
    }
    
    .status-pending {
        background: #fef3c7;
        color: #b45309;
    }
</style>

<div class="record-container">
    <div class="record-header">
        <h1 class="record-title"><i class="fa-solid fa-notes-medical"></i> Hồ Sơ Bệnh Án</h1>
        <a href="${pageContext.request.contextPath}/appointments" class="btn btn-outline">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>
    </div>

    <!-- 1. Thông tin Lâm sàng -->
    <div class="section-card">
        <h2 class="section-title"><i class="fa-solid fa-stethoscope"></i> Khám Lâm Sàng & Chẩn Đoán</h2>
        <div class="info-grid">
            <div>
                <div class="info-group">
                    <div class="info-label">Bác sĩ phụ trách</div>
                    <div class="info-value"><i class="fa-solid fa-user-doctor" style="color: var(--primary); margin-right: 8px;"></i> ${visit.doctorName}</div>
                </div>
                <div class="info-group">
                    <div class="info-label">Ngày khám</div>
                    <div class="info-value"><i class="fa-regular fa-calendar-check" style="color: var(--primary); margin-right: 8px;"></i> <fmt:formatDate value="${visit.visitDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                </div>
                <div class="info-group">
                    <div class="info-label">Dịch vụ</div>
                    <div class="info-value"><i class="fa-solid fa-tooth" style="color: var(--primary); margin-right: 8px;"></i> ${not empty visit.serviceName ? visit.serviceName : 'Khám & Tư Vấn'}</div>
                </div>
            </div>
            <div>
                <div class="info-group">
                    <div class="info-label">Triệu chứng (Bệnh nhân mô tả)</div>
                    <div class="info-value" style="border-left-color: #f59e0b;">${not empty visit.symptoms ? visit.symptoms : 'Không có ghi nhận'}</div>
                </div>
                <div class="info-group">
                    <div class="info-label">Chẩn đoán của Bác sĩ</div>
                    <div class="info-value" style="border-left-color: #ef4444; font-weight: 600;">${not empty visit.diagnosis ? visit.diagnosis : 'Đang cập nhật'}</div>
                </div>
                <div class="info-group">
                    <div class="info-label">Ghi chú lâm sàng</div>
                    <div class="info-value" style="border-left-color: #8b5cf6;">${not empty visit.clinicalNotes ? visit.clinicalNotes : 'Không có ghi chú'}</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 2. Kế hoạch điều trị -->
    <div class="section-card">
        <h2 class="section-title"><i class="fa-solid fa-list-check"></i> Kế Hoạch Điều Trị</h2>
        <c:choose>
            <c:when test="${not empty treatmentPlan && not empty treatmentSteps}">
                <div style="margin-bottom: 20px; padding: 15px; background: #f8fafc; border-radius: 12px; border: 1px solid #e2e8f0;">
                    <strong style="color: var(--primary-dark); font-size: 1.1rem;">${treatmentPlan.title}</strong>
                    <div style="color: var(--text-muted); font-size: 0.9rem; margin-top: 5px;">
                        Ngày lập: <fmt:formatDate value="${treatmentPlan.createdAt}" pattern="dd/MM/yyyy"/>
                    </div>
                </div>
                
                <div style="overflow-x: auto;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 80px; text-align: center;">Bước</th>
                                <th>Nội dung thực hiện</th>
                                <th>Chi phí dự kiến</th>
                                <th>Hẹn lần tới</th>
                                <th style="text-align: center;">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="step" items="${treatmentSteps}">
                                <tr>
                                    <td style="text-align: center; font-weight: bold; color: var(--primary);">#${step.stepOrder}</td>
                                    <td>${step.description}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${step.estimatedCost > 0}">
                                                <fmt:formatNumber value="${step.estimatedCost}" pattern="#,###"/> VND
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: var(--text-muted);">Theo tình tế</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty step.nextAppointmentDate}">
                                                <fmt:formatDate value="${step.nextAppointmentDate}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${step.status == 'Done'}">
                                                <span class="status-badge status-done"><i class="fa-solid fa-check"></i> Hoàn tất</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-pending"><i class="fa-regular fa-clock"></i> Chờ xử lý</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 30px; color: var(--text-muted); background: #f8fafc; border-radius: 12px; border: 1px dashed #cbd5e1;">
                    <i class="fa-solid fa-file-medical" style="font-size: 3rem; color: #e2e8f0; margin-bottom: 15px; display: block;"></i>
                    Không có kế hoạch điều trị nào được lập cho buổi khám này.
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 3. Đơn thuốc -->
    <div class="section-card">
        <h2 class="section-title"><i class="fa-solid fa-pills"></i> Đơn Thuốc Bác Sĩ Kê</h2>
        <c:choose>
            <c:when test="${not empty prescriptions}">
                <div style="overflow-x: auto;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Tên Thuốc</th>
                                <th>Liều Lượng</th>
                                <th>Thời Gian Dùng</th>
                                <th>Hướng Dẫn / Lưu Ý</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${prescriptions}">
                                <tr>
                                    <td style="font-weight: 600; color: var(--primary-dark);">${item.medicationName}</td>
                                    <td>${item.dosage}</td>
                                    <td>${item.duration}</td>
                                    <td>${item.usageInstruction}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 30px; color: var(--text-muted); background: #f8fafc; border-radius: 12px; border: 1px dashed #cbd5e1;">
                    <i class="fa-solid fa-prescription-bottle-medical" style="font-size: 3rem; color: #e2e8f0; margin-bottom: 15px; display: block;"></i>
                    Không có đơn thuốc nào được kê.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
