<%@ tag description="Search and Filter Component" pageEncoding="UTF-8"%>
<%@ attribute name="actionUrl" required="true" type="java.lang.String" %>
<%@ attribute name="searchPlaceholder" required="true" type="java.lang.String" %>
<%@ attribute name="searchValue" required="false" type="java.lang.String" %>

<div class="search-filter-container" style="background: white; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid var(--border-color);">
    <form action="${actionUrl}" method="GET" style="display: flex; gap: 15px; align-items: center; flex-wrap: wrap; margin: 0;">
        <div style="flex: 1; min-width: 200px; max-width: 350px; position: relative;">
            <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-secondary);"></i>
            <input type="text" name="search" value="${searchValue}" placeholder="${searchPlaceholder}" class="form-control" style="padding-left: 35px; width: 100%; box-sizing: border-box;" />
        </div>
        
        <jsp:doBody/>
        
        <div style="display: flex; gap: 10px; flex-shrink: 0;">
            <button type="submit" class="btn btn-primary" style="padding: 8px 20px; white-space: nowrap;">
                <i class="fa-solid fa-filter"></i> Lọc
            </button>
            <a href="${actionUrl}" class="btn btn-secondary" style="padding: 8px 20px; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; white-space: nowrap;">
                <i class="fa-solid fa-rotate-right"></i> Đặt lại
            </a>
        </div>
    </form>
</div>
