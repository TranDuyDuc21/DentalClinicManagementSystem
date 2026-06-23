<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="currentPage" value="appointments" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Hồ Sơ Bệnh Án" />
</jsp:include>

<style>
    :root {
        --primary-gradient: linear-gradient(135deg, #0ea5e9, #2563eb);
        --secondary-gradient: linear-gradient(135deg, #10b981, #059669);
        --accent-gradient: linear-gradient(135deg, #8b5cf6, #6d28d9);
        --glass-bg: rgba(255, 255, 255, 0.95);
        --glass-border: rgba(255, 255, 255, 0.4);
        --glass-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.05);
    }
    
    body {
        background-color: #f8fafc;
    }

    .record-container {
        width: 100%;
        margin: 40px 0;
        padding: 0;
        animation: fadeIn 0.6s ease-out forwards;
    }
    
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    .record-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        background: var(--glass-bg);
        padding: 20px 30px;
        border-radius: 20px;
        box-shadow: var(--glass-shadow);
        border: 1px solid var(--glass-border);
    }
    
    .record-title {
        font-size: 2.2rem;
        font-weight: 700;
        color: #1e293b;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 15px;
    }
    
    .btn-outline {
        border: 2px solid #e2e8f0;
        background: #ffffff;
        color: #475569;
        border-radius: 50px;
        padding: 10px 25px;
        font-weight: 600;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }
    
    .btn-outline:hover {
        border-color: #2563eb;
        color: #2563eb;
        background: #eff6ff;
        transform: translateX(-5px);
    }
    
    .main-grid {
        display: grid;
        grid-template-columns: 35% 1fr;
        gap: 30px;
        align-items: start;
    }
    
    .right-column {
        display: flex;
        flex-direction: column;
        gap: 30px;
    }
    
    .section-card {
        background: var(--glass-bg);
        border-radius: 20px;
        box-shadow: var(--glass-shadow);
        padding: 30px;
        border: 1px solid var(--glass-border);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        position: relative;
        overflow: hidden;
    }
    
    .section-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 40px 0 rgba(31, 38, 135, 0.08);
    }
    
    .section-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 5px;
    }
    
    .card-primary::before { background: var(--primary-gradient); }
    .card-secondary::before { background: var(--secondary-gradient); }
    .card-accent::before { background: var(--accent-gradient); }
    
    .section-title {
        font-size: 1.4rem;
        font-weight: 700;
        color: #1e293b;
        margin-bottom: 25px;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .section-title i {
        background: #f1f5f9;
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 10px;
        font-size: 1.1rem;
    }
    
    .info-grid {
        display: flex;
        flex-direction: column;
        gap: 20px;
    }
    
    .info-item {
        background: #ffffff;
        border-radius: 12px;
        padding: 18px;
        border: 1px solid #e2e8f0;
    }
    
    .info-label {
        font-size: 0.85rem;
        color: #64748b;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 6px;
    }
    
    .info-value {
        font-size: 1.1rem;
        color: #0f172a;
        font-weight: 500;
        line-height: 1.5;
    }
    
    .data-table-wrapper {
        border-radius: 12px;
        overflow: hidden;
        border: 1px solid #e2e8f0;
        background: #ffffff;
    }
    
    .data-table {
        width: 100%;
        border-collapse: collapse;
    }
    
    .data-table th {
        background: #f8fafc;
        padding: 15px;
        text-align: left;
        font-weight: 700;
        color: #475569;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        border-bottom: 2px solid #e2e8f0;
    }
    
    .data-table td {
        padding: 15px;
        border-bottom: 1px solid #f1f5f9;
        color: #334155;
        vertical-align: middle;
    }
    
    .data-table tbody tr:hover td {
        background-color: #f8fafc;
    }
    
    .data-table tr:last-child td {
        border-bottom: none;
    }
    
    .status-badge {
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 0.85rem;
        font-weight: 700;
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }
    
    .status-done {
        background: #dcfce7;
        color: #15803d;
        border: 1px solid #bbf7d0;
    }
    
    .status-pending {
        background: #fef3c7;
        color: #b45309;
        border: 1px solid #fde68a;
    }
    
    .empty-state {
        text-align: center;
        padding: 40px 20px;
        background: #f8fafc;
        border-radius: 12px;
        border: 2px dashed #cbd5e1;
    }
    
    .empty-state i {
        font-size: 3.5rem;
        color: #cbd5e1;
        margin-bottom: 15px;
    }
    
    .empty-state p {
        font-size: 1.05rem;
        color: #64748b;
        font-weight: 500;
        margin: 0;
    }
    
    .highlight-box {
        background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
        border: 1px solid #bbf7d0;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .highlight-box strong {
        color: #166534;
        font-size: 1.2rem;
        display: block;
        margin-bottom: 5px;
    }
    
    @media (max-width: 992px) {
        .main-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="record-container">
    <div class="record-header">
        <h1 class="record-title"><i class="fa-solid fa-file-medical-alt" style="color: #2563eb;"></i> Hồ Sơ Bệnh Án</h1>
        <a href="${pageContext.request.contextPath}/appointments" class="btn-outline">
            <i class="fa-solid fa-arrow-left"></i> Lịch Hẹn Của Tôi
        </a>
    </div>

    <div class="main-grid">
        <!-- Cột trái: 1. Thông tin Lâm sàng -->
        <div class="section-card card-primary">
            <h2 class="section-title"><i class="fa-solid fa-stethoscope" style="color: #2563eb;"></i> Thông Tin Lâm Sàng</h2>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label"><i class="fa-solid fa-user-doctor"></i> Bác sĩ phụ trách</div>
                    <div class="info-value" style="color: #2563eb; font-weight: 700;">${visit.doctorName}</div>
                </div>
                <div class="info-item">
                    <div class="info-label"><i class="fa-regular fa-calendar-check"></i> Ngày khám</div>
                    <div class="info-value"><fmt:formatDate value="${visit.visitDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                </div>
                <div class="info-item">
                    <div class="info-label"><i class="fa-solid fa-tooth"></i> Dịch vụ</div>
                    <div class="info-value">${not empty visit.serviceName ? visit.serviceName : 'Khám tổng quát'}</div>
                </div>
                
                <div class="info-item" style="border-left: 4px solid #f59e0b;">
                    <div class="info-label" style="color: #d97706;"><i class="fa-solid fa-comment-medical"></i> Triệu chứng</div>
                    <div class="info-value">${not empty visit.symptoms ? visit.symptoms : '<span style="color: #94a3b8; font-style: italic;">Không ghi nhận</span>'}</div>
                </div>
                
                <div class="info-item" style="border-left: 4px solid #ef4444; background: #fef2f2;">
                    <div class="info-label" style="color: #b91c1c;"><i class="fa-solid fa-microscope"></i> Chẩn đoán của Bác sĩ</div>
                    <div class="info-value" style="font-weight: 700; color: #7f1d1d;">${not empty visit.diagnosis ? visit.diagnosis : '<span style="color: #fca5a5; font-style: italic;">Đang chờ cập nhật</span>'}</div>
                </div>
                
                <div class="info-item" style="border-left: 4px solid #8b5cf6;">
                    <div class="info-label" style="color: #6d28d9;"><i class="fa-solid fa-notes-medical"></i> Ghi chú lâm sàng</div>
                    <div class="info-value">${not empty visit.clinicalNotes ? visit.clinicalNotes : '<span style="color: #94a3b8; font-style: italic;">Không có ghi chú</span>'}</div>
                </div>
            </div>
        </div>

        <!-- Cột phải: 2. Kế hoạch điều trị & 3. Đơn thuốc -->
        <div class="right-column">
            
            <!-- 2. Kế hoạch điều trị -->
            <div class="section-card card-secondary">
                <h2 class="section-title"><i class="fa-solid fa-list-check" style="color: #059669; background: #d1fae5;"></i> Kế Hoạch Điều Trị</h2>
                <c:choose>
                    <c:when test="${not empty treatmentPlan && not empty treatmentSteps}">
                        <div class="highlight-box">
                            <div>
                                <strong>${treatmentPlan.title}</strong>
                                <span style="color: #15803d; font-size: 0.95rem; font-weight: 500;">
                                    <i class="fa-regular fa-calendar"></i> Ngày lập: <fmt:formatDate value="${treatmentPlan.createdAt}" pattern="dd/MM/yyyy"/>
                                </span>
                            </div>
                            <i class="fa-solid fa-shield-heart" style="font-size: 2.2rem; color: #86efac; opacity: 0.5;"></i>
                        </div>
                        
                        <div class="data-table-wrapper">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th style="width: 60px; text-align: center;">Bước</th>
                                        <th>Nội dung</th>
                                        <th>Chi phí</th>
                                        <th>Hẹn tới</th>
                                        <th style="text-align: center;">Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="step" items="${treatmentSteps}">
                                        <tr>
                                            <td style="text-align: center; font-weight: 900; color: #10b981; font-size: 1.1rem;">#${step.stepOrder}</td>
                                            <td style="font-weight: 600; color: #1e293b;">${step.description}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${step.estimatedCost > 0}">
                                                        <span style="color: #ef4444; font-weight: 700;"><fmt:formatNumber value="${step.estimatedCost}" pattern="#,###"/> ₫</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #94a3b8; font-style: italic;">Thực tế</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty step.nextAppointmentDate}">
                                                        <span style="background: #f1f5f9; padding: 4px 10px; border-radius: 6px; font-weight: 600; color: #475569; font-size: 0.9rem;">
                                                            <i class="fa-regular fa-calendar-check" style="color: #3b82f6;"></i> 
                                                            <fmt:formatDate value="${step.nextAppointmentDate}" pattern="dd/MM/yyyy"/>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #94a3b8;">-</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: center;">
                                                <c:choose>
                                                    <c:when test="${step.status == 'Done'}">
                                                        <span class="status-badge status-done"><i class="fa-solid fa-check-circle"></i> Xong</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-pending"><i class="fa-solid fa-hourglass-half"></i> Chờ</span>
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
                        <div class="empty-state">
                            <i class="fa-solid fa-clipboard-check"></i>
                            <p>Không có Kế hoạch điều trị dài hạn.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 3. Đơn thuốc -->
            <div class="section-card card-accent">
                <h2 class="section-title"><i class="fa-solid fa-pills" style="color: #6d28d9; background: #ede9fe;"></i> Đơn Thuốc Bác Sĩ Kê</h2>
                <c:choose>
                    <c:when test="${not empty prescriptions}">
                        <div class="data-table-wrapper">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th style="width: 50px; text-align: center;">STT</th>
                                        <th>Tên Thuốc</th>
                                        <th>Liều Lượng</th>
                                        <th>Thời Gian</th>
                                        <th>Hướng Dẫn / Lưu Ý</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${prescriptions}" varStatus="status">
                                        <tr>
                                            <td style="text-align: center; font-weight: 700; color: #94a3b8;">${status.index + 1}</td>
                                            <td>
                                                <div style="font-weight: 700; color: #4338ca; font-size: 1.05rem; display: flex; align-items: center; gap: 8px;">
                                                    <i class="fa-solid fa-capsules" style="color: #818cf8;"></i> ${item.medicationName}
                                                </div>
                                            </td>
                                            <td style="font-weight: 600; color: #334155;">${item.dosage}</td>
                                            <td><span style="background: #fef2f2; color: #b91c1c; padding: 4px 8px; border-radius: 6px; font-weight: 600; font-size: 0.9rem;">${item.duration}</span></td>
                                            <td style="color: #475569; font-size: 0.95rem;"><i class="fa-solid fa-circle-info" style="color: #94a3b8;"></i> ${item.usageInstruction}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="fa-solid fa-prescription-bottle"></i>
                            <p>Không có đơn thuốc nào được kê.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
