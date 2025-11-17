<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - MVC</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 32px;
        }

        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-style: italic;
        }

        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: 500;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .btn {
            display: inline-block;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 1px;
        }

        tbody tr {
            transition: background-color 0.2s;
        }

        tbody tr:hover {
            background-color: #f8f9fa;
        }

        .actions {
            display: flex;
            gap: 10px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state-icon {
            font-size: 64px;
            margin-bottom: 20px;
        }

        .search-box {
            display: flex;
            gap: 10px;
            align-items: center;
            margin: 10px 0 20px;
        }

        .filter-box {
            display: flex;
            gap: 10px;
            align-items: center;
            margin: 10px 0 20px;
        }

        .filter-box form {
            display: flex;
            gap: 10px;
            align-items: center;
            width: 100%;
        }

        .filter-box label {
            font-weight: 600;
            margin-right: 10px;
            white-space: nowrap;
        }

        .filter-box select {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: white;
            cursor: pointer;
            font-size: 14px;
        }

        .filter-box select:focus {
            outline: none;
            border-color: #667eea;
        }

        .filter-box button {
            padding: 12px 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
        }

        .filter-box button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .filter-box a {
            padding: 12px 24px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: all 0.3s;
            font-size: 14px;
        }

        .filter-box a:hover {
            background-color: #5a6268;
        }

        .pagination {
            margin: 30px 0;
            text-align: center;
            display: flex;
            justify-content: center;
            gap: 5px;
            flex-wrap: wrap;
        }

        .pagination a,
        .pagination strong,
        .pagination .disabled {
            padding: 10px 15px;
            border: 1px solid #ddd;
            text-decoration: none;
            color: #333;
            border-radius: 5px;
            transition: all 0.3s;
            display: inline-block;
            min-width: 40px;
            text-align: center;
        }

        .pagination a:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: #667eea;
            transform: translateY(-2px);
        }

        .pagination strong {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: #667eea;
            font-weight: 600;
        }

        .pagination .disabled {
            color: #999;
            cursor: not-allowed;
            background-color: #f5f5f5;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>📚 Student Management System</h1>
    <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>

    <!-- Success Message -->
    <c:if test="${not empty param.message}">
        <div class="message success">
            ✅ ${param.message}
        </div>
    </c:if>

    <!-- Error Message -->
    <c:if test="${not empty param.error}">
        <div class="message error">
            ❌ ${param.error}
        </div>
    </c:if>

    <!-- Add New Student Button -->
    <div style="margin-bottom: 20px;">
        <a href="student?action=new" class="btn btn-primary">
            ➕ Add New Student
        </a>
    </div>

    <!-- Search Bar -->
    <form class="search-box" method="get" action="student?action=search">
        <input type="hidden" name="action" value="search"/>
        <label for="keyword" style="font-weight:600; margin-right:10px;">🔍 Search:</label>
        <input
                type="text"
                name="keyword"
                id="keyword"
                placeholder="Search by student code, full name, or email"
                value="${fn:escapeXml(param.keyword)}"
                style="flex:1; padding:10px; border:1px solid #ddd; border-radius:5px;"
        />
        <button type="submit" class="btn btn-primary">🔍 Search</button>

        <!-- Show All button only when search is active -->
        <c:if test="${param.action == 'search' and not empty param.keyword}">
            <a href="student?action=search" class="btn btn-secondary">Show All</a>
        </c:if>
    </form>

    <!-- Search result message -->
    <c:if test="${param.action == 'search' and not empty param.keyword}">
        <div class="message" style="border:1px solid #e2e3e5; background:#f8f9fa; color:#383d41;">
            Search results for: <strong>${fn:escapeXml(param.keyword)}</strong>
        </div>
    </c:if>

    <!-- Filter by Major -->
    <div class="filter-box">
        <form action="student" method="get">
            <input type="hidden" name="action" value="filter">
            <label for="major">Filter by Major:</label>
            <select id="major" name="major">
                <option value="">All Majors</option>
                <option value="Computer Science" ${selectedMajor == 'Computer Science' ? 'selected' : ''}>
                    Computer Science
                </option>
                <option value="Information Technology" ${selectedMajor == 'Information Technology' ? 'selected' : ''}>
                    Information Technology
                </option>
                <option value="Software Engineering" ${selectedMajor == 'Software Engineering' ? 'selected' : ''}>
                    Software Engineering
                </option>
                <option value="Business Administration" ${selectedMajor == 'Business Administration' ? 'selected' : ''}>
                    Business Administration
                </option>
            </select>

            <button type="submit">Apply Filter</button>
            <c:if test="${not empty selectedMajor}">
                <a href="student?action=list">Clear Filter</a>
            </c:if>
        </form>
    </div>

    <div class="export-box">
        <form id="exportForm" action="${pageContext.request.contextPath}/export" method="get" style="display:inline;">
            <input type="hidden" name="keyword" value="${param.keyword}" />
            <input type="hidden" name="major" value="${param.major}" />
            <input type="hidden" name="sortBy" value="${param.sortBy}" />
            <input type="hidden" name="order" value="${param.order}" />
            <button type="submit" class="btn">Export to Excel</button>
        </form>
    </div>

    <!-- Student Table -->
    <c:choose>
        <c:when test="${not empty students}">
            <table>
                <thead>
                <tr>
                    <th>
                        <a href="student?action=sort&sortBy=id&order=${sortBy == 'id' && order == 'asc' ? 'desc' : 'asc'}">
                            ID
                            <c:if test="${sortBy == 'id'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                        </a>
                    </th>
                    <th>
                        <a href="student?action=sort&sortBy=student_code&order=${sortBy == 'student_code' && order == 'asc' ? 'desc' : 'asc'}">
                            Student Code
                            <c:if test="${sortBy == 'student_code'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                        </a>
                    </th>
                    <th>
                        <a href="student?action=sort&sortBy=full_name&order=${sortBy == 'full_name' && order == 'asc' ? 'desc' : 'asc'}">
                            Full Name
                            <c:if test="${sortBy == 'full_name'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                        </a>
                    </th>
                    <th>
                        <a href="student?action=sort&sortBy=email&order=${sortBy == 'email' && order == 'asc' ? 'desc' : 'asc'}">
                            Email
                            <c:if test="${sortBy == 'email'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                        </a>
                    </th>
                    <th>
                        <a href="student?action=sort&sortBy=major&order=${sortBy == 'major' && order == 'asc' ? 'desc' : 'asc'}">
                            Major
                            <c:if test="${sortBy == 'major'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                        </a>
                    </th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="student" items="${students}">
                    <tr>
                        <td>${student.id}</td>
                        <td><strong>${student.studentCode}</strong></td>
                        <td>${student.fullName}</td>
                        <td>${student.email}</td>
                        <td>${student.major}</td>
                        <td>
                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/student?action=edit&id=${student.id}" class="btn btn-secondary">
                                    ✏️ Edit
                                </a>
                                <a href="${pageContext.request.contextPath}/student?action=delete&id=${student.id}"
                                   class="btn btn-danger"
                                   onclick="return confirm('Are you sure you want to delete this student?')">
                                    🗑️ Delete
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <!-- Advanced Pagination with limited page numbers -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <!-- First button -->
                    <c:if test="${currentPage > 3}">
                        <a href="student?action=list&page=1">« First</a>
                    </c:if>

                    <!-- Previous button -->
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <a href="student?action=list&page=${currentPage - 1}">‹ Prev</a>
                        </c:when>
                        <c:otherwise>
                            <span class="disabled">‹ Prev</span>
                        </c:otherwise>
                    </c:choose>

                    <!-- Page numbers (show 5 pages around current) -->
                    <c:set var="startPage" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}" />
                    <c:set var="endPage" value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" />

                    <c:if test="${startPage > 1}">
                        <span>...</span>
                    </c:if>

                    <c:forEach begin="${startPage}" end="${endPage}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <strong>${i}</strong>
                            </c:when>
                            <c:otherwise>
                                <a href="student?action=list&page=${i}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:if test="${endPage < totalPages}">
                        <span>...</span>
                    </c:if>

                    <!-- Next button -->
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <a href="student?action=list&page=${currentPage + 1}">Next ›</a>
                        </c:when>
                        <c:otherwise>
                            <span class="disabled">Next ›</span>
                        </c:otherwise>
                    </c:choose>

                    <!-- Last button -->
                    <c:if test="${currentPage < totalPages - 2}">
                        <a href="student?action=list&page=${totalPages}">Last »</a>
                    </c:if>
                </div>

                <!-- Enhanced pagination info with record range -->
                <c:set var="startRecord" value="${(currentPage - 1) * 10 + 1}" />
                <c:set var="endRecord" value="${currentPage * 10 > totalRecords ? totalRecords : currentPage * 10}" />

                <p style="text-align: center; color: #666; margin-top: 10px; font-size: 14px;">
                    Showing <strong>${startRecord}-${endRecord}</strong> of <strong>${totalRecords}</strong> records
                    (Page ${currentPage} of ${totalPages})
                </p>
            </c:if>

        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <div class="empty-state-icon">📭</div>
                <h3>No students found</h3>
                <p>Start by adding a new student</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
