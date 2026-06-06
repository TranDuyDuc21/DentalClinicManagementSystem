<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">
        ${errorMessage}
    </div>
    <c:remove var="errorMessage" scope="request" />
    <c:remove var="errorMessage" scope="session" />
</c:if>

<c:if test="${not empty successMessage}">
    <div class="alert alert-success">
        ${successMessage}
    </div>
    <c:remove var="successMessage" scope="request" />
    <c:remove var="successMessage" scope="session" />
</c:if>
