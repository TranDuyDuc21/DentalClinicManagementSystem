<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty sessionScope.loggedUser}">
        </div> <!-- End dashboard-content -->
        
        <div class="dashboard-footer">
            <div class="footer-content" style="text-align: center; color: var(--text-secondary); padding: 15px; font-size: 0.9rem;">
                &copy; 2026 Dental Clinic Management System. All rights reserved.
            </div>
        </div>
    </div> <!-- End dashboard-main -->
</c:if>

    <jsp:include page="/WEB-INF/views/components/confirm-modal.jsp" />
    <script src="${pageContext.request.contextPath}/assets/js/validation.js"></script>
</body>
</html>
