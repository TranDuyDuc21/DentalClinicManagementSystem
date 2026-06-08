<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="currentPage" value="services" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Danh Mục Dịch Vụ - Admin" />
</jsp:include>

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
    <div>
        <h2 style="color: var(--text-primary); margin-bottom: 8px;"><i class="fa-solid fa-list-check"></i> Danh Mục Dịch Vụ</h2>
        <p style="color: var(--text-secondary); margin: 0;">Quản lý danh sách các dịch vụ khám và điều trị nha khoa</p>
    </div>
    <a href="${pageContext.request.contextPath}/services/create" class="btn btn-primary" style="width: auto; display: inline-flex; align-items: center; gap: 8px;">
        <i class="fa-solid fa-plus"></i> Thêm Dịch Vụ Mới
    </a>
</div>

<jsp:include page="/WEB-INF/views/components/messages.jsp" />

<t:searchFilter actionUrl="${pageContext.request.contextPath}/services" searchPlaceholder="Tìm tên dịch vụ..." searchValue="${param.search}">
    <div style="width: 200px;">
        <select name="status" class="form-control" style="width: 100%; box-sizing: border-box;">
            <option value="">-- Tất cả trạng thái --</option>
            <option value="true" ${param.status == 'true' ? 'selected' : ''}>Đang hoạt động</option>
            <option value="false" ${param.status == 'false' ? 'selected' : ''}>Đã ngưng</option>
        </select>
    </div>
</t:searchFilter>

<div class="card">
    <div style="overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse; min-width: 800px;">
            <thead style="background-color: #f8fafc;">
                <tr>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); border-bottom: 2px solid var(--border-color); text-align: left; width: 60px;">ID</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); border-bottom: 2px solid var(--border-color); text-align: left;">Tên Dịch Vụ</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); border-bottom: 2px solid var(--border-color); text-align: right; width: 150px;">Giá Niêm Yết</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); border-bottom: 2px solid var(--border-color); text-align: center; width: 150px;">Thời Gian ĐT</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); border-bottom: 2px solid var(--border-color); text-align: center; width: 150px;">Trạng Thái</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); border-bottom: 2px solid var(--border-color); text-align: left; width: 150px; white-space: nowrap;">Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty services}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 30px; color: var(--text-secondary);">
                                Không tìm thấy dịch vụ nào.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="srv" items="${services}">
                            <tr style="border-bottom: 1px solid var(--border-color); transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#f1f5f9'" onmouseout="this.style.backgroundColor='transparent'">
                                <td style="padding: 12px; font-weight: 500; color: var(--text-secondary); text-align: left;">#${srv.serviceId}</td>
                                <td style="padding: 12px; font-weight: 600; color: var(--primary); text-align: left;">
                                    ${srv.serviceName}
                                    <div style="font-weight: 400; font-size: 0.85rem; color: var(--text-secondary); margin-top: 4px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                        ${srv.description}
                                    </div>
                                </td>
                                <td style="padding: 12px; font-weight: 500; text-align: right; color: #10b981;">
                                    <fmt:formatNumber value="${srv.listedPrice}" pattern="#,###" /> đ
                                </td>
                                <td style="padding: 12px; text-align: center;">
                                    ${not empty srv.estimatedMinutes ? srv.estimatedMinutes.toString().concat(' phút') : '-'}
                                </td>
                                <td style="padding: 12px; text-align: center;">
                                    <c:choose>
                                        <c:when test="${srv.active}">
                                            <span style="color: var(--success); font-weight: 500; font-size: 0.9rem;"><i class="fa-solid fa-circle-check"></i> Đang HĐ</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: var(--error); font-weight: 500; font-size: 0.9rem;"><i class="fa-solid fa-circle-xmark"></i> Đã ngưng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="padding: 12px; text-align: left;">
                                    <div style="display: flex; gap: 15px; justify-content: flex-start; align-items: center;">
                                        <a href="${pageContext.request.contextPath}/services/update?id=${srv.serviceId}" style="color: #6366f1; text-decoration: none; font-weight: 600; font-size: 0.9rem; display: inline-flex; align-items: center; gap: 4px;">
                                            <i class="fa-solid fa-pen"></i> Sửa
                                        </a>
                                        <form action="${pageContext.request.contextPath}/services/toggle" method="POST" style="margin: 0;">
                                            <input type="hidden" name="id" value="${srv.serviceId}">
                                            <input type="hidden" name="status" value="${!srv.active}">
                                            <c:set var="actionMsg" value="${srv.active ? 'tạm ngưng' : 'kích hoạt lại'}"/>
                                            <c:set var="actionType" value="${srv.active ? 'danger' : 'warning'}"/>
                                            <button type="submit" class="btn" style="padding: 4px 8px; font-size: 0.85rem; min-width: auto; background-color: ${srv.active ? 'var(--error)' : 'var(--success)'}; color: white; border: none; border-radius: 4px;" onclick="event.preventDefault(); var form = this.closest('form'); showConfirmModal('Bạn có chắc chắn muốn ${actionMsg} dịch vụ này?', function() { form.submit(); }, '${actionType}');">
                                                <i class="fa-solid ${srv.active ? 'fa-ban' : 'fa-check'}"></i> 
                                                ${srv.active ? 'Ngưng' : 'Mở lại'}
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- Phân trang -->
    <c:if test="${totalPages > 1}">
        <div style="padding: 20px; display: flex; justify-content: center; border-top: 1px solid var(--border-color);">
            <div style="display: flex; gap: 5px;">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="?page=${i}&search=${param.search}&status=${param.status}" 
                       class="btn ${i == currentPage ? 'btn-primary' : 'btn-secondary'}" 
                       style="padding: 6px 12px; min-width: auto;">
                        ${i}
                    </a>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
