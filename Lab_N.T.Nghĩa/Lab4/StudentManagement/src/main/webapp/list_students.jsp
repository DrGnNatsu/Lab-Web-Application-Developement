<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.nio.charset.StandardCharsets" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student List</title>
    <style>
        /* ===== Base ===== */
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
            color: #222;
        }
        h1 {
            color: #333;
            margin: 0 0 12px 0;
        }

        /* ===== Accessibility helpers ===== */
        .sr-only {
            position: absolute !important;
            width: 1px;
            height: 1px;
            padding: 0;
            margin: -1px;
            overflow: hidden;
            clip: rect(0, 0, 0, 0);
            white-space: nowrap;
            border: 0;
        }

        /* ===== Messages (success / error) ===== */
        .message {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 10px 12px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-weight: 500;
        }
        .message::before {
            display: inline-block;
            width: 20px;
            text-align: center;
            font-weight: 700;
        }
        .message.success {
            background-color: #d4edda; /* green */
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .message.success::before {
            content: '✓';
            color: #155724;
        }

        .message.error {
            background-color: #f8d7da; /* red */
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .message.error::before {
            content: '✗';
            color: #721c24;
        }

        .message.fade-out {
            opacity: 0;
            transition: opacity 300ms ease;
        }

        /* ===== Buttons ===== */
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin-bottom: 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }

        /* ===== Search form ===== */
        .search-form {
            display: flex;
            gap: 8px;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            position: relative;
        }
        .search-input {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            width: 300px;
            max-width: 60%;
            box-sizing: border-box;
        }
        .search-button {
            padding: 8px 12px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .search-button:hover {
            background-color: #218838;
        }
        .clear-link {
            margin-left: 4px;
            color: #6c757d;
            text-decoration: none;
        }
        .clear-link:hover {
            text-decoration: underline;
        }

        /* ===== Table layout ===== */
        .table-container {
            overflow-x: auto;
            margin-top: 8px;
        }
        .table-responsive {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            min-width: 720px;
        }
        th {
            background-color: #007bff;
            color: #fff;
            padding: 12px 14px;
            text-align: left;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            vertical-align: middle;
        }
        td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
        tr:hover {
            background-color: #f8f9fa;
        }
        .action-link {
            color: #007bff;
            text-decoration: none;
            margin-right: 10px;
        }
        .delete-link {
            color: #dc3545;
        }
        .actions-col {
            width: 140px;
        }
        .checkbox-col {
            width: 50px;
            text-align: center;
        }
        .delete-selected-btn {
            background-color: #dc3545;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-left: 10px;
            text-decoration: none;
            display: inline-block;
        }
        .delete-selected-btn:hover {
            background-color: #c82333;
        }
        .delete-selected-btn:disabled {
            background-color: #6c757d;
            cursor: not-allowed;
        }

        /* ===== Pagination ===== */
        .pagination {
            margin-top: 16px;
            display: flex;
            gap: 8px;
            align-items: center;
            justify-content: flex-start;
            flex-wrap: wrap;
        }
        .pagination a, .pagination strong {
            margin: 0;
            padding: 6px 10px;
            text-decoration: none;
            border: 1px solid #ddd;
            border-radius: 4px;
            color: #007bff;
            background: #fff;
            transition: background-color 120ms ease, box-shadow 120ms ease;
        }
        .pagination a:hover {
            background: #f1f1f1;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        .pagination strong {
            background-color: #007bff;
            color: #fff;
            border-color: #007bff;
            font-weight: 600;
        }

        /* ===== Responsive adjustments ===== */
        @media (max-width: 768px) {
            table {
                font-size: 12px;
            }
            th, td {
                padding: 5px;
            }
        }

        @media (max-width: 640px) {
            .search-input {
                width: 180px;
                max-width: 70%;
            }
            th, td {
                padding: 8px 10px;
            }
            .actions-col {
                width: 110px;
            }
        }

    </style>
</head>
<body>
<h1>📚 Student Management System</h1>

<span class="message sr-only fade-out" aria-hidden="true"></span>

<% if (request.getParameter("message") != null) { %>
<div class="message success" role="status" aria-live="polite">
    <%= request.getParameter("message") %>
</div>
<% } %>

<% if (request.getParameter("error") != null) { %>
<div class="message error" role="alert" aria-live="assertive">
    <%= request.getParameter("error") %>
</div>
<% } %>

<a href="add_student.jsp" class="btn">➕ Add New Student</a>
<button type="button" class="delete-selected-btn" id="deleteSelectedBtn" onclick="deleteSelected()" disabled>🗑️ Delete Selected</button>

<form class="search-form" action="list_students.jsp" method="GET" onsubmit="return submitForm(this)">
    <label for="keyword" class="sr-only">Search students by name or code</label>
    <input id="keyword" class="search-input" type="text" name="keyword" placeholder="Search by name or code..." value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
    <button class="search-button" type="submit">Search</button>
    <a class="clear-link" href="list_students.jsp">Clear</a>
</form>

<%-- compute keyword, pagination and sorting early so headers and links can use them --%>
<%
    String keyword = request.getParameter("keyword");
    String pageParam = request.getParameter("page");

    // Sorting params
    String sortBy = request.getParameter("sort");
    String order = request.getParameter("order");
    if (sortBy == null) sortBy = "id";
    if (order == null) order = "desc";
    order = "asc".equalsIgnoreCase(order) ? "asc" : "desc";

    // Keyword helpers for highlighting
    boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
    String keywordLower = hasKeyword ? keyword.toLowerCase() : "";

    // whitelist allowed sort columns to avoid SQL injection
    java.util.Set<String> allowed = new java.util.HashSet<>();
    allowed.add("id"); allowed.add("student_code"); allowed.add("full_name"); allowed.add("email"); allowed.add("major"); allowed.add("created_at");
    String safeSort = allowed.contains(sortBy) ? sortBy : "id";
    String orderClause = safeSort + " " + order;

    // When changing sorting, show first page
    if (request.getParameter("sort") != null) {
        pageParam = "1";
    }

    int currentPage = (pageParam != null && pageParam.matches("\\d+")) ? Integer.parseInt(pageParam) : 1;
    int recordsPerPage = 10;
    int offset; // computed after counting totalRecords
%>

<div class="table-container table-responsive">
<table>
    <thead>
    <tr>
        <th class="checkbox-col">
            <input type="checkbox" id="selectAll" onchange="toggleSelectAll()" title="Select/Deselect All">
        </th>
        <th>ID</th>
        <th>Student Code</th>
        <th>
            <a href="list_students.jsp?sort=full_name&order=<%= "full_name".equals(safeSort) && "asc".equals(order) ? "desc" : "asc" %><%= keyword != null ? "&keyword=" + java.net.URLEncoder.encode(keyword, StandardCharsets.UTF_8) : "" %>" style="color: inherit; text-decoration: none;">
                Full Name
                <% if ("full_name".equals(safeSort)) { %>
                <span style="font-size:0.8em; margin-left:6px; color:#666"><%= "asc".equals(order) ? "▲" : "▼" %></span>
                <% } %>
            </a>
        </th>
        <th>Email</th>
        <th>Major</th>
        <th>
            <a href="list_students.jsp?sort=created_at&order=<%= "created_at".equals(safeSort) && "asc".equals(order) ? "desc" : "asc" %><%= keyword != null ? "&keyword=" + java.net.URLEncoder.encode(keyword, StandardCharsets.UTF_8) : "" %>" style="color: inherit; text-decoration: none;">
                Created At
                <% if ("created_at".equals(safeSort)) { %>
                <span style="font-size:0.8em; margin-left:6px; color:#666"><%= "asc".equals(order) ? "▲" : "▼" %></span>
                <% } %>
            </a>
        </th>
        <th class="actions-col">Actions</th>
    </tr>
    </thead>
    <tbody>
    <%-- variables (keyword, currentPage, safeSort, order, orderClause) were computed above --%>
    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String errorRow = null;
        boolean hadError = false;
        int totalRecords = 0;
        int totalPages = 1;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/student_management",
                    "appuser",
                    "apppass"
            );

            // --- count total matching records ---
            String countSql;
            if (keyword == null || keyword.trim().isEmpty()) {
                countSql = "SELECT COUNT(*) FROM students";
                pstmt = conn.prepareStatement(countSql);
            } else {
                countSql = "SELECT COUNT(*) FROM students WHERE full_name LIKE ? OR student_code LIKE ? OR major LIKE ?";
                pstmt = conn.prepareStatement(countSql);
                String searchPattern = "%" + keyword + "%";
                pstmt.setString(1, searchPattern);
                pstmt.setString(2, searchPattern);
                pstmt.setString(3, searchPattern);
            }

            ResultSet countRs = pstmt.executeQuery();
            if (countRs.next()) totalRecords = countRs.getInt(1);
            countRs.close();
            pstmt.close();

            // compute pagination
            totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            if (totalPages < 1) totalPages = 1;
            if (currentPage > totalPages) currentPage = totalPages;
            offset = (currentPage - 1) * recordsPerPage; // recalc in case currentPage changed

            // --- query current page ---
            String sql;
            if (keyword == null || keyword.trim().isEmpty()) {
                sql = "SELECT * FROM students ORDER BY ? LIMIT ? OFFSET ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, orderClause);
                pstmt.setInt(2, recordsPerPage);
                pstmt.setInt(3, offset);
            } else {
                sql = "SELECT * FROM students WHERE full_name LIKE ? OR student_code LIKE ? OR major LIKE ? ORDER BY ? LIMIT ? OFFSET ?";
                pstmt = conn.prepareStatement(sql);
                String searchPattern = "%" + keyword + "%";
                pstmt.setString(1, searchPattern);
                pstmt.setString(2, searchPattern);
                pstmt.setString(3, searchPattern);
                pstmt.setString(4, orderClause);
                pstmt.setInt(5, recordsPerPage);
                pstmt.setInt(6, offset);
            }

            rs = pstmt.executeQuery();


            while (rs.next()) {
                int id = rs.getInt("id");
                String studentCode = rs.getString("student_code");
                String fullName = rs.getString("full_name");
                String email = rs.getString("email");
                String major = rs.getString("major");
                Timestamp createdAt = rs.getTimestamp("created_at");
    %>
    <tr>
        <td class="checkbox-col">
            <input type="checkbox" name="studentIds" value="<%= id %>" onchange="updateDeleteButton()">
        </td>
        <td><%= id %></td>
        <%
            if (hasKeyword && studentCode != null && studentCode.toLowerCase().contains(keywordLower)) {
        %>
        <td style="font-weight: bold;"><%= studentCode %></td>
        <%
            } else {
        %>
        <td><%= studentCode %></td>
        <%
            }
        %>
        <%
            if (hasKeyword && fullName != null && fullName.toLowerCase().contains(keywordLower)) {
        %>
        <td style="font-weight: bold;"><%= fullName %></td>
        <%
            } else {
        %>
        <td><%= fullName %></td>
        <%
            }
        %>
        <td><%= email != null ? email : "N/A" %></td>
        <%
            if (hasKeyword && major != null && major.toLowerCase().contains(keywordLower)) {
        %>
        <td style="font-weight: bold;"><%= major %></td>
        <%
            } else {
        %>
        <td><%= major != null ? major : "N/A" %></td>
        <%
            }
        %>
         <td><%= createdAt %></td>
         <td>
             <a href="edit_student.jsp?id=<%= id %>" class="action-link">✏️ Edit</a>
             <br>
             <a href="delete_student.jsp?id=<%= id %>"
                class="action-link delete-link"
                onclick="return confirm('Are you sure?')">🗑️ Delete</a>
         </td>
     </tr>
    <%
            }
        } catch (ClassNotFoundException e) {
            hadError = true;
            errorRow = "<tr><td colspan='7'>Error: JDBC Driver not found!</td></tr>";
        } catch (SQLException e) {
            hadError = true;
            errorRow = "<tr><td colspan='7'>Database Error: " + e.getMessage() + "</td></tr>";
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                // ignore close exceptions in this simple example
            }
        }
    %>
    <% if (hadError) { %>
        <%= errorRow %>
    <% } %>
    </tbody>
</table>
</div>
<div class="pagination">
    <% if (currentPage > 1) { %>
    <a href="list_students.jsp?page=<%= currentPage - 1 %><%= keyword != null ? "&keyword=" + java.net.URLEncoder.encode(keyword, StandardCharsets.UTF_8) : "" %><%= "&sort=" + safeSort + "&order=" + order %>">Previous</a>
    <% } %>

    <% for (int i = 1; i <= totalPages; i++) { %>
    <% if (i == currentPage) { %>
    <strong><%= i %></strong>
    <% } else { %>
    <a href="list_students.jsp?page=<%= i %><%= keyword != null ? "&keyword=" + java.net.URLEncoder.encode(keyword, StandardCharsets.UTF_8) : "" %><%= "&sort=" + safeSort + "&order=" + order %>"><%= i %></a>
    <% } %>
    <% } %>

    <% if (currentPage < totalPages) { %>
    <a href="list_students.jsp?page=<%= currentPage + 1 %><%= keyword != null ? "&keyword=" + java.net.URLEncoder.encode(keyword, StandardCharsets.UTF_8) : "" %><%= "&sort=" + safeSort + "&order=" + order %>">Next</a>
    <% } %>
</div>
<!-- JS: auto-hide messages and prevent double submit (loading state) -->
<script>
    // Auto-hide messages after 3 seconds
    setTimeout(function() {
        var messages = document.querySelectorAll('.message');
        messages.forEach(function(msg) {
            // add fade then remove after transition
            msg.classList.add('fade-out');
            setTimeout(function() { try { msg.style.display = 'none'; } catch(e) {} }, 300);
        });
    }, 3000);

    // Disable submit button and show processing text
    function submitForm(form) {
        try {
            var btn = form.querySelector('button[type="submit"]');
            if (btn) {
                btn.disabled = true;
                // preserve width by setting minWidth
                btn.dataset.origText = btn.textContent;
                btn.textContent = 'Processing...';
            }
        } catch (e) { /* ignore */ }
        return true;
    }

    // Toggle select all checkboxes
    function toggleSelectAll() {
        var selectAllCheckbox = document.getElementById('selectAll');
        var studentCheckboxes = document.getElementsByName('studentIds');

        for (let i = 0; i < studentCheckboxes.length; i++) {
            studentCheckboxes[i].checked = selectAllCheckbox.checked;
        }

        updateDeleteButton();
    }

    // Update delete button state based on selected checkboxes
    function updateDeleteButton() {
        var studentCheckboxes = document.getElementsByName('studentIds');
        var deleteButton = document.getElementById('deleteSelectedBtn');
        var selectAllCheckbox = document.getElementById('selectAll');
        var checkedCount = 0;

        for (let i = 0; i < studentCheckboxes.length; i++) {
            if (studentCheckboxes[i].checked) {
                checkedCount++;
            }
        }

        // Enable/disable delete button
        deleteButton.disabled = checkedCount === 0;

        // Update select all checkbox state
        if (checkedCount === 0) {
            selectAllCheckbox.indeterminate = false;
            selectAllCheckbox.checked = false;
        } else if (checkedCount === studentCheckboxes.length) {
            selectAllCheckbox.indeterminate = false;
            selectAllCheckbox.checked = true;
        } else {
            selectAllCheckbox.indeterminate = true;
        }
    }

    // Delete selected students
    function deleteSelected() {
        var studentCheckboxes = document.getElementsByName('studentIds');
        var selectedIds = [];

        for (let i = 0; i < studentCheckboxes.length; i++) {
            if (studentCheckboxes[i].checked) {
                selectedIds.push(studentCheckboxes[i].value);
            }
        }

        if (selectedIds.length === 0) {
            alert('Please select at least one student to delete.');
            return;
        }

        var confirmMessage = 'Are you sure you want to delete ' + selectedIds.length + ' selected student(s)? This action cannot be undone.';
        if (confirm(confirmMessage)) {
            // Create a form to submit the selected IDs
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = 'delete_selected.jsp';

            for (let j = 0; j < selectedIds.length; j++) {
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'selectedIds';
                input.value = selectedIds[j];
                form.appendChild(input);
            }

            document.body.appendChild(form);
            form.submit();
        }
    }

    // Initialize delete button state on page load
    document.addEventListener('DOMContentLoaded', function() {
        updateDeleteButton();
    });
</script>

</body>
</html>
