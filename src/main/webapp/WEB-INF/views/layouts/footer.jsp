<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

    </div><!-- end content-wrapper -->
</div><!-- end page-content -->

</div><!-- end wrapper -->

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Common JS -->
<script src="${pageContext.request.contextPath}/assets/js/common/utils.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/components/sidebar.js"></script>
<c:if test="${not empty pageJS}">
    <script src="${pageContext.request.contextPath}/assets/js/pages/${pageJS}"></script>
</c:if>
</body>
</html>
