<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="currentPage" value="services" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Danh Mục Dịch Vụ - Dental Clinic" />
</jsp:include>



<div class="section-spacing bg-white">
    <div class="container">
        <h2 class="section-title-premium">Danh Mục Dịch Vụ Nha Khoa</h2>
        
        <div style="margin-bottom: 30px;">
            <t:searchFilter actionUrl="${pageContext.request.contextPath}/services" searchPlaceholder="Tìm kiếm dịch vụ..." searchValue="${param.search}" />
        </div>

        <div class="row">
            <c:choose>
                <c:when test="${empty services}">
                    <div class="col col-12" style="text-align: center; padding: 50px 0;">
                        <i class="fa-solid fa-tooth" style="font-size: 4rem; color: #cbd5e1; margin-bottom: 20px;"></i>
                        <h3 style="color: #64748b;">Không tìm thấy dịch vụ nào phù hợp</h3>
                        <p style="color: #94a3b8;">Vui lòng thử lại với từ khóa khác.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="svc" items="${services}">
                        <div style="width: 33.33%; padding: 0 15px; box-sizing: border-box; margin-bottom: 30px;">
                            <div class="service-card-premium">
                                <div class="service-icon-wrapper">
                                    <c:choose>
                                        <c:when test="${svc.serviceName.contains('Cạo Vôi') || svc.serviceName.contains('Vệ Sinh')}">
                                            <i class="fa-solid fa-tooth"></i>
                                        </c:when>
                                        <c:when test="${svc.serviceName.contains('Tẩy Trắng')}">
                                            <i class="fa-regular fa-face-smile-beam"></i>
                                        </c:when>
                                        <c:when test="${svc.serviceName.contains('Nhổ Răng')}">
                                            <i class="fa-solid fa-staff-snake"></i>
                                        </c:when>
                                        <c:when test="${svc.serviceName.contains('Implant') || svc.serviceName.contains('Cắm Ghép')}">
                                            <i class="fa-solid fa-screwdriver-wrench"></i>
                                        </c:when>
                                        <c:when test="${svc.serviceName.contains('Niềng Răng') || svc.serviceName.contains('Chỉnh Nha')}">
                                            <i class="fa-solid fa-teeth-open"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa-solid fa-hand-holding-medical"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <h4 style="min-height: 45px; display: flex; align-items: center; justify-content: center;">${svc.serviceName}</h4>
                                <p style="display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden;">
                                    ${svc.description != null ? svc.description : 'Giải pháp nha khoa toàn diện mang lại nụ cười rạng rỡ và sự tự tin tối đa cho bạn.'}
                                </p>
                                <div style="font-size: 0.85rem; color: #64748b; margin-bottom: 15px; font-weight: 600; display: flex; align-items: center; justify-content: center; gap: 6px;">
                                    <span style="background: #f1f5f9; padding: 4px 10px; border-radius: 20px;">
                                        <i class="fa-regular fa-clock" style="color: #0ea5e9;"></i> ${svc.estimatedMinutes} phút
                                    </span>
                                </div>
                                <div class="service-price">
                                    <fmt:formatNumber value="${svc.listedPrice}" type="number" maxFractionDigits="0"/> <span style="font-size: 1rem; font-weight: 600;">VNĐ</span>
                                </div>
                                
                                <div style="display: flex; gap: 8px; margin-top: auto; padding-top: 10px; border-top: 1px dashed #e2e8f0;">
                                    <a href="${pageContext.request.contextPath}/service-detail?id=${svc.serviceId}" class="btn-outline-premium" style="flex: 1; padding: 8px 5px; text-align: center; text-decoration: none;">
                                        Xem Chi Tiết
                                    </a>
                                    <a href="${pageContext.request.contextPath}/booking?serviceId=${svc.serviceId}" class="btn-premium" style="flex: 1.2; padding: 8px 5px; text-align: center; text-decoration: none; height: auto; font-size: 0.85rem; border-radius: 8px;">
                                        Đặt Dịch Vụ
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        
        <t:pagination activePage="${not empty pageNumber ? pageNumber : 1}" totalPages="${totalPages}" urlParams="&search=${param.search}" />
    </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
