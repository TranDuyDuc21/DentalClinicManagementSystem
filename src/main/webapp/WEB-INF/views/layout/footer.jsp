<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="isCustomer" value="${sessionScope.loggedUser != null && sessionScope.loggedUser.roleName == 'Customer'}" />
<c:set var="isStaff" value="${sessionScope.loggedUser != null && sessionScope.loggedUser.roleName != 'Customer'}" />
<c:set var="isGuest" value="${sessionScope.loggedUser == null}" />

<c:if test="${isStaff}">
        </div> <!-- End dashboard-content -->
        
        <div class="dashboard-footer">
            <div class="footer-content" style="text-align: center; color: var(--text-secondary); padding: 15px; font-size: 0.9rem;">
                &copy; 2026 Dental Clinic Management System. All rights reserved.
            </div>
        </div>
    </div> <!-- End dashboard-main -->
</c:if>

<c:if test="${isCustomer || isGuest}">
    </div> <!-- End customer-main-content -->
    <!-- Footer cho Customer và Guest -->
    <div style="background: #f8fafc; border-top: 1px solid #e2e8f0; padding: 30px 20px; text-align: center; margin-top: auto;">
        <div style="max-width: 1200px; margin: 0 auto;">
            <div style="color: var(--text-secondary); font-size: 0.95rem;">
                &copy; 2026 Dental Clinic Management System. All rights reserved.
            </div>
        </div>
    </div>
</c:if>

    <jsp:include page="/WEB-INF/views/components/confirm-modal.jsp" />
    <jsp:include page="/WEB-INF/views/components/alert-modal.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/validation.js?v=1.1"></script>
</body>
</html>
