<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="dashboard-sidebar">
    <div class="sidebar-header">
        <a href="${sessionScope.loggedUser.roleName == 'Customer' ? pageContext.request.contextPath.concat('/home') : pageContext.request.contextPath.concat('/dashboard')}" class="logo">
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                <circle cx="9" cy="7" r="4"></circle>
                <line x1="19" y1="8" x2="19" y2="14"></line>
                <line x1="22" y1="11" x2="16" y2="11"></line>
            </svg>
            <span class="logo-text">DentalClinic</span>
        </a>
    </div>

    <div class="sidebar-menu">
        <ul class="nav-list">
            <!-- Chung cho mọi Role: Tổng quan Dashboard -->
            <li class="nav-item">
                <a href="${sessionScope.loggedUser.roleName == 'Customer' ? pageContext.request.contextPath.concat('/home') : pageContext.request.contextPath.concat('/dashboard')}" class="nav-link active">
                    <i class="fa-solid fa-house nav-icon"></i>
                    <span class="nav-text">Trang chủ</span>
                </a>
            </li>

            <!-- MENU DÀNH CHO ADMIN -->
            <c:if test="${sessionScope.loggedUser.roleName == 'Admin'}">
                <li class="nav-section">Quản Trị Hệ Thống</li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/employees" class="nav-link">
                        <i class="fa-solid fa-users-gear nav-icon"></i>
                        <span class="nav-text">Nhân viên & Phân quyền</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/services" class="nav-link">
                        <i class="fa-solid fa-list-check nav-icon"></i>
                        <span class="nav-text">Danh mục dịch vụ</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/chairs" class="nav-link">
                        <i class="fa-solid fa-chair nav-icon"></i>
                        <span class="nav-text">Quản lý ghế khám</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/reports" class="nav-link">
                        <i class="fa-solid fa-file-invoice-dollar nav-icon"></i>
                        <span class="nav-text">Báo cáo doanh thu</span>
                    </a>
                </li>
            </c:if>

            <!-- MENU DÀNH CHO RECEPTIONIST (LỄ TÂN) -->
            <c:if test="${sessionScope.loggedUser.roleName == 'Receptionist'}">
                <li class="nav-section">Lễ Tân & Đón Tiếp</li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/reception/appointments" class="nav-link">
                        <i class="fa-regular fa-calendar-check nav-icon"></i>
                        <span class="nav-text">Lịch hẹn & Check-in</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/reception/queue" class="nav-link">
                        <i class="fa-solid fa-users-line nav-icon"></i>
                        <span class="nav-text">Hàng đợi chờ khám</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/reception/patients" class="nav-link">
                        <i class="fa-solid fa-id-card nav-icon"></i>
                        <span class="nav-text">Hồ sơ bệnh nhân</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/reception/billing" class="nav-link">
                        <i class="fa-solid fa-money-bill-wave nav-icon"></i>
                        <span class="nav-text">Thanh toán & Hóa đơn</span>
                    </a>
                </li>
            </c:if>

            <!-- MENU DÀNH CHO DOCTOR (BÁC SĨ) -->
            <c:if test="${sessionScope.loggedUser.roleName == 'Doctor'}">
                <li class="nav-section">Khám & Điều Trị</li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/doctor/schedule" class="nav-link">
                        <i class="fa-regular fa-calendar-days nav-icon"></i>
                        <span class="nav-text">Lịch làm việc của tôi</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/doctor/examinations" class="nav-link">
                        <i class="fa-solid fa-stethoscope nav-icon"></i>
                        <span class="nav-text">Danh sách chờ khám</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/doctor/prescriptions" class="nav-link">
                        <i class="fa-solid fa-prescription-bottle-medical nav-icon"></i>
                        <span class="nav-text">Kê đơn thuốc</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/doctor/statistics" class="nav-link">
                        <i class="fa-solid fa-chart-column nav-icon"></i>
                        <span class="nav-text">Thống kê cá nhân</span>
                    </a>
                </li>
            </c:if>

            <!-- MENU DÀNH CHO TECHNICIAN (KỸ THUẬT VIÊN) -->
            <c:if test="${sessionScope.loggedUser.roleName == 'Technician'}">
                <li class="nav-section">Cận Lâm Sàng</li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/technician/tests" class="nav-link">
                        <i class="fa-solid fa-microscope nav-icon"></i>
                        <span class="nav-text">Lệnh xét nghiệm</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/technician/upload" class="nav-link">
                        <i class="fa-solid fa-file-arrow-up nav-icon"></i>
                        <span class="nav-text">Tải kết quả & Hình ảnh</span>
                    </a>
                </li>
            </c:if>

            <!-- MENU DÀNH CHO CUSTOMER -->
            <c:if test="${sessionScope.loggedUser.roleName == 'Customer'}">
                <li class="nav-section">Khách Hàng</li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/customer/appointments" class="nav-link">
                        <i class="fa-regular fa-calendar-check nav-icon"></i>
                        <span class="nav-text">Lịch hẹn của tôi</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/customer/records" class="nav-link">
                        <i class="fa-solid fa-notes-medical nav-icon"></i>
                        <span class="nav-text">Hồ sơ bệnh án</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/customer/invoices" class="nav-link">
                        <i class="fa-solid fa-file-invoice nav-icon"></i>
                        <span class="nav-text">Lịch sử thanh toán</span>
                    </a>
                </li>
            </c:if>

            <!-- Chung cho mọi Role: Cài đặt & Đăng xuất -->
            <li class="nav-section">Tài khoản</li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/profile" class="nav-link">
                    <i class="fa-regular fa-user nav-icon"></i>
                    <span class="nav-text">Hồ sơ cá nhân</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link text-error">
                    <i class="fa-solid fa-arrow-right-from-bracket nav-icon"></i>
                    <span class="nav-text">Đăng xuất</span>
                </a>
            </li>
        </ul>
    </div>
</div>
