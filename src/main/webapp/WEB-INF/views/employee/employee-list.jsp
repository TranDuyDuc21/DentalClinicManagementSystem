<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<c:set var="currentPage" value="employees" scope="request" />

<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="pageTitle" value="Quản Lý Nhân Viên - Admin" />
</jsp:include>

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
    <h2 style="color: var(--primary); margin: 0;"><i class="fa-solid fa-users-gear"></i> Quản Lý Nhân Viên</h2>
    <a href="${pageContext.request.contextPath}/employees/create" class="btn btn-primary" style="width: auto;">
        <i class="fa-solid fa-plus"></i> Thêm Nhân Viên Mới
    </a>
</div>

<t:searchFilter actionUrl="${pageContext.request.contextPath}/employees" searchPlaceholder="Tìm theo tên, username, sđt, email..." searchValue="${param.search}">
    <div style="width: 200px;">
        <select name="roleId" class="form-control" style="width: 100%; box-sizing: border-box;">
            <option value="">-- Tất cả chức vụ --</option>
            <c:forEach var="role" items="${roles}">
                <option value="${role.roleId}" ${param.roleId == role.roleId ? 'selected' : ''}>${role.roleName}</option>
            </c:forEach>
        </select>
    </div>
    <div style="width: 200px;">
        <select name="status" class="form-control" style="width: 100%; box-sizing: border-box;">
            <option value="">-- Tất cả trạng thái --</option>
            <option value="true" ${param.status == 'true' ? 'selected' : ''}>Đang hoạt động</option>
            <option value="false" ${param.status == 'false' ? 'selected' : ''}>Đã khoá</option>
        </select>
    </div>
</t:searchFilter>

<div class="card" style="padding: 20px;">
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success" style="margin-bottom: 20px;">
            ${sessionScope.successMessage}
            <c:remove var="successMessage" scope="session" />
        </div>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-error" style="margin-bottom: 20px;">
            ${sessionScope.errorMessage}
            <c:remove var="errorMessage" scope="session" />
        </div>
    </c:if>

    <div style="overflow-x: auto;">
        <table style="width: 100%; border-collapse: collapse; min-width: 800px;">
            <thead>
                <tr style="border-bottom: 2px solid var(--border-color); text-align: left; background: #f8fafc;">
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Họ Tên</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Tài Khoản</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">SĐT</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Chức Vụ</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary);">Trạng Thái</th>
                    <th style="padding: 15px 12px; font-weight: 600; color: var(--text-secondary); text-align: left;">Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="emp" items="${employees}">
                    <tr style="border-bottom: 1px solid var(--border-color); transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#f1f5f9'" onmouseout="this.style.backgroundColor='transparent'">
                        <td style="padding: 12px; font-weight: 500; color: var(--text-primary);">${emp.fullName}</td>
                        <td style="padding: 12px;">${emp.username}</td>
                        <td style="padding: 12px;">${emp.phoneNumber}</td>
                        <td style="padding: 12px;">
                            <span style="padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 500; 
                                ${emp.roleName == 'Admin' ? 'background: #fee2e2; color: #ef4444;' : 
                                  (emp.roleName == 'Doctor' ? 'background: #dbeafe; color: #3b82f6;' : 
                                  (emp.roleName == 'Receptionist' ? 'background: #fef3c7; color: #f59e0b;' : 'background: #e0e7ff; color: #6366f1;'))}">
                                ${emp.roleName}
                            </span>
                        </td>
                        <td style="padding: 12px;">
                            <c:choose>
                                <c:when test="${emp.active}">
                                    <span style="color: var(--success); font-weight: 500; font-size: 0.9rem;"><i class="fa-solid fa-circle-check"></i> Hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: var(--error); font-weight: 500; font-size: 0.9rem;"><i class="fa-solid fa-lock"></i> Đã khoá</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="padding: 12px; text-align: left;">
                            <div style="display: flex; gap: 15px; justify-content: flex-start; align-items: center;">
                                <a href="${pageContext.request.contextPath}/employees/update?id=${emp.userId}" style="color: #6366f1; text-decoration: none; font-weight: 600; font-size: 0.9rem; padding: 6px 0;">
                                    <i class="fa-solid fa-pen"></i> Sửa
                                </a>
                                
                                <c:choose>
                                    <c:when test="${emp.userId != sessionScope.loggedUser.userId}">
                                        <form action="${pageContext.request.contextPath}/employees/toggle" method="POST" style="display: inline; margin: 0;" onsubmit="event.preventDefault(); const form = this; showConfirmModal('Bạn có chắc chắn muốn ${emp.active ? 'khoá' : 'mở khoá'} tài khoản này?', () => form.submit(), '${emp.active ? 'danger' : 'warning'}');">
                                            <input type="hidden" name="id" value="${emp.userId}">
                                            <input type="hidden" name="status" value="${!emp.active}">
                                            <button type="submit" class="btn" style="padding: 6px 12px; font-size: 0.85rem; min-width: auto; background-color: ${emp.active ? 'var(--error)' : 'var(--success)'}; color: white; border: none;">
                                                <i class="fa-solid ${emp.active ? 'fa-lock' : 'fa-unlock'}"></i> 
                                                ${emp.active ? 'Khoá' : 'Mở'}
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Invisible placeholder for alignment -->
                                        <div style="visibility: hidden; display: inline;">
                                            <button type="button" class="btn" style="padding: 6px 12px; font-size: 0.85rem; min-width: auto; border: none;">
                                                <i class="fa-solid fa-lock"></i> Khoá
                                            </button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty employees}">
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 30px; color: var(--text-secondary);">
                            Không có dữ liệu nhân viên nào.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- Phân trang -->
    <t:pagination activePage="${not empty pageNumber ? pageNumber : (not empty param.page ? param.page : 1)}" totalPages="${totalPages}" urlParams="&search=${param.search}&roleId=${param.roleId}&status=${param.status}" />
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
