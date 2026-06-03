<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle"   value="Dashboard" />
<c:set var="currentPage" value="dashboard" />
<c:set var="pageCSS"     value="dashboard.css" />
<%@ include file="/WEB-INF/views/layouts/header.jsp" %>
<%@ include file="/WEB-INF/views/layouts/sidebar.jsp" %>

<div class="page-header mb-4">
    <h4 class="fw-bold mb-1"><i class="bi bi-speedometer2 me-2 text-primary"></i>Dashboard</h4>
    <p class="text-muted small mb-0">Tổng quan hệ thống phòng khám</p>
</div>

<!-- Stat Cards -->
<div class="row g-3 mb-4">
    <div class="col-sm-6 col-xl-3">
        <div class="stat-card card border-0 h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                    <i class="bi bi-people-fill"></i>
                </div>
                <div>
                    <p class="text-muted small mb-0">Bệnh nhân</p>
                    <h3 class="fw-bold mb-0">${totalPatients != null ? totalPatients : 0}</h3>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3">
        <div class="stat-card card border-0 h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon bg-success bg-opacity-10 text-success">
                    <i class="bi bi-calendar-check-fill"></i>
                </div>
                <div>
                    <p class="text-muted small mb-0">Lịch hẹn hôm nay</p>
                    <h3 class="fw-bold mb-0">${todayAppointments != null ? todayAppointments : 0}</h3>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3">
        <div class="stat-card card border-0 h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                    <i class="bi bi-person-badge-fill"></i>
                </div>
                <div>
                    <p class="text-muted small mb-0">Bác sĩ</p>
                    <h3 class="fw-bold mb-0">${totalDoctors != null ? totalDoctors : 0}</h3>
                </div>
            </div>
        </div>
    </div>
    <div class="col-sm-6 col-xl-3">
        <div class="stat-card card border-0 h-100">
            <div class="card-body d-flex align-items-center gap-3">
                <div class="stat-icon bg-info bg-opacity-10 text-info">
                    <i class="bi bi-cash-stack"></i>
                </div>
                <div>
                    <p class="text-muted small mb-0">Doanh thu tháng</p>
                    <h3 class="fw-bold mb-0">${monthlyRevenue != null ? monthlyRevenue : '0đ'}</h3>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Placeholder for charts / tables -->
<div class="row g-3">
    <div class="col-lg-8">
        <div class="card border-0">
            <div class="card-header bg-white border-0 pb-0">
                <h6 class="fw-bold mb-0">Lịch hẹn sắp tới</h6>
            </div>
            <div class="card-body">
                <p class="text-muted">Dữ liệu lịch hẹn sẽ hiển thị tại đây.</p>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="card border-0">
            <div class="card-header bg-white border-0 pb-0">
                <h6 class="fw-bold mb-0">Thống kê theo vai trò</h6>
            </div>
            <div class="card-body">
                <p class="text-muted">Biểu đồ sẽ hiển thị tại đây.</p>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/layouts/footer.jsp" %>
