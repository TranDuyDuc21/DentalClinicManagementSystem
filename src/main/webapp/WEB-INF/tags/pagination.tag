<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ attribute name="activePage" required="true" type="java.lang.Integer" %>
<%@ attribute name="totalPages" required="true" type="java.lang.Integer" %>
<%@ attribute name="urlParams" required="false" type="java.lang.String" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${totalPages > 1}">
    <c:set var="startPage" value="${activePage - 1}" />
    <c:set var="endPage" value="${activePage + 1}" />

    <c:if test="${startPage < 1}">
        <c:set var="startPage" value="1" />
        <c:set var="endPage" value="${totalPages > 3 ? 3 : totalPages}" />
    </c:if>

    <c:if test="${endPage > totalPages}">
        <c:set var="endPage" value="${totalPages}" />
        <c:set var="startPage" value="${totalPages - 2 > 0 ? totalPages - 2 : 1}" />
    </c:if>

    <div style="padding: 20px; display: flex; justify-content: center; border-top: 1px solid var(--border-color);">
        <div style="display: flex; gap: 5px;">
            <!-- Nút Previous -->
            <c:choose>
                <c:when test="${activePage > 1}">
                    <a href="?page=${activePage - 1}${empty urlParams ? '' : urlParams}" class="btn btn-secondary" style="padding: 6px 12px; min-width: auto;" title="Trang trước">
                        <i class="fa-solid fa-angle-left"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <span class="btn btn-secondary" style="padding: 6px 12px; min-width: auto; opacity: 0.5; cursor: not-allowed;">
                        <i class="fa-solid fa-angle-left"></i>
                    </span>
                </c:otherwise>
            </c:choose>

            <!-- Các số trang -->
            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                <a href="?page=${i}${empty urlParams ? '' : urlParams}" 
                   class="btn ${i == activePage ? 'btn-primary' : 'btn-secondary'}" 
                   style="padding: 6px 12px; min-width: auto;">
                    ${i}
                </a>
            </c:forEach>

            <!-- Nút Next -->
            <c:choose>
                <c:when test="${activePage < totalPages}">
                    <a href="?page=${activePage + 1}${empty urlParams ? '' : urlParams}" class="btn btn-secondary" style="padding: 6px 12px; min-width: auto;" title="Trang sau">
                        <i class="fa-solid fa-angle-right"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <span class="btn btn-secondary" style="padding: 6px 12px; min-width: auto; opacity: 0.5; cursor: not-allowed;">
                        <i class="fa-solid fa-angle-right"></i>
                    </span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</c:if>
