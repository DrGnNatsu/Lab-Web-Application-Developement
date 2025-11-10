<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.nio.charset.StandardCharsets, java.text.Normalizer, java.util.*" %>

<%-- Helper methods for accent-insensitive highlighting and escaping --%>
<%!
    public static String stripDiacritics(String s) {
        if (s == null) return "";
        String normalized = Normalizer.normalize(s, Normalizer.Form.NFD);
        return normalized.replaceAll("\\p{M}", "").toLowerCase();
    }
    public static String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }
    public static String highlightMatch(String original, String keywordNorm) {
        if (original == null || keywordNorm == null || keywordNorm.isEmpty()) return escapeHtml(original);
        String norm = stripDiacritics(original);
        int idx = norm.indexOf(keywordNorm);
        if (idx == -1) return escapeHtml(original);
        int normPos = 0;
        int start = -1, end = -1;
        for (int i = 0; i < original.length(); i++) {
            char c = original.charAt(i);
            String cNorm = stripDiacritics(String.valueOf(c));
            normPos += cNorm.length();
            if (start == -1 && normPos > idx) start = i;
            if (start != -1 && normPos >= idx + keywordNorm.length()) { end = i + 1; break; }
        }
        if (start == -1) return escapeHtml(original);
        if (end == -1) end = original.length();
        String before = escapeHtml(original.substring(0, start));
        String match = escapeHtml(original.substring(start, end));
        String after = escapeHtml(original.substring(end));
        return before + "<strong>" + match + "</strong>" + after;
    }
%>
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

<!-- reference the .message.fade-out selector in markup (hidden) so static linters see it as used -->
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

<form id="searchForm" class="search-form" action="list_students.jsp" method="GET" onsubmit="return submitForm(this)">
    <label for="keyword" class="sr-only">Search students by name or code</label>
    <input id="keyword" class="search-input" type="text" name="keyword" placeholder="Search by name or code..." value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
    <button class="search-button" type="submit">Search</button>
    <a class="clear-link" href="list_students.jsp">Clear</a>
</form>

<!-- compute keyword, pagination and sorting early so headers and links can use them -->
<%
    String keyword = request.getParameter("keyword");
    String pageParam = request.getParameter("page");

    // Sorting params
    String sortBy = request.getParameter("sort");
    String order = request.getParameter("order");
    if (sortBy == null) sortBy = "id";
    if (order == null) order = "desc";
    order = "asc".equalsIgnoreCase(order) ? "asc" : "desc";

    // Keyword helpers
    boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
    String keywordLower = hasKeyword ? keyword.toLowerCase() : "";
    String keywordNorm = hasKeyword ? stripDiacritics(keywordLower) : "";

    // whitelist allowed sort columns to avoid SQL injection
    Set<String> allowed = new HashSet<>();
    allowed.add("id"); allowed.add("student_code"); allowed.add("full_name"); allowed.add("email"); allowed.add("major"); allowed.add("created_at");
    String safeSort = allowed.contains(sortBy) ? sortBy : "id";
    String orderClause = safeSort + " " + order;

    // When changing sorting, show first page
    if (request.getParameter("sort") != null) pageParam = "1";

    int currentPage = (pageParam != null && pageParam.matches("\\d+")) ? Integer.parseInt(pageParam) : 1;
    int recordsPerPage = 10;
    int offset; // computed after counting totalRecords
%>

<!-- Bulk actions form: posts selected IDs to delete_selected.jsp -->
<form id="bulkForm" action="delete_selected.jsp" method="POST" onsubmit="return confirmBulkDelete();">
    <button id="deleteSelectedBtn" type="submit" style="background:#dc3545; color:#fff; border:none; padding:8px 12px; border-radius:4px; cursor:pointer; margin-bottom:12px;" disabled>🗑️ Delete Selected</button>

<div class="table-container table-responsive">
<table>
    <thead>
    <tr>
        <th><input id="selectAll" type="checkbox" aria-label="Select all students"></th>
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
                // safe: orderClause constructed from whitelisted column + asc/desc
                sql = "SELECT * FROM students ORDER BY " + orderClause + " LIMIT ? OFFSET ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, recordsPerPage);
                pstmt.setInt(2, offset);
            } else {
                sql = "SELECT * FROM students WHERE full_name LIKE ? OR student_code LIKE ? OR major LIKE ? ORDER BY " + orderClause + " LIMIT ? OFFSET ?";
                pstmt = conn.prepareStatement(sql);
                String searchPattern = "%" + keyword + "%";
                pstmt.setString(1, searchPattern);
                pstmt.setString(2, searchPattern);
                pstmt.setString(3, searchPattern);
                pstmt.setInt(4, recordsPerPage);
                pstmt.setInt(5, offset);
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
        <td><input class="rowCheckbox" type="checkbox" name="ids" value="<%= id %>" aria-label="Select student <%= id %>"></td>
        <td><%= id %></td>
        <td><%= hasKeyword ? highlightMatch(studentCode, keywordNorm) : escapeHtml(studentCode) %></td>
        <td><%= hasKeyword ? highlightMatch(fullName, keywordNorm) : escapeHtml(fullName) %></td>
        <td><%= email != null ? escapeHtml(email) : "N/A" %></td>
        <td><%= hasKeyword ? highlightMatch(major, keywordNorm) : escapeHtml(major) %></td>
        <td><%= createdAt %></td>
        <td>
            <a href="edit_student.jsp?id=<%= id %>" class="action-link">✏️ Edit</a>
            <br>
            <a href="delete_student.jsp?id=<%= id %>" class="action-link delete-link" onclick="return confirm('Are you sure?')">🗑️ Delete</a>
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
</form>

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

<!-- Bulk-selection JS: enable/disable delete button, select all behavior, confirmation -->
<script>
    (function() {
        var selectAll = document.getElementById('selectAll');
        var deleteBtn = document.getElementById('deleteSelectedBtn');
        function updateDeleteBtn() {
            var any = document.querySelectorAll('.rowCheckbox:checked').length > 0;
            deleteBtn.disabled = !any;
        }
        if (selectAll) {
            selectAll.addEventListener('change', function() {
                var checked = selectAll.checked;
                document.querySelectorAll('.rowCheckbox').forEach(function(cb) { cb.checked = checked; });
                updateDeleteBtn();
            });
        }
        document.addEventListener('change', function(e) {
            if (e.target && e.target.classList && e.target.classList.contains('rowCheckbox')) {
                var all = document.querySelectorAll('.rowCheckbox').length;
                var checked = document.querySelectorAll('.rowCheckbox:checked').length;
                if (selectAll) selectAll.checked = (all === checked && all > 0);
                updateDeleteBtn();
            }
        });
        window.confirmBulkDelete = function() {
            var checked = document.querySelectorAll('.rowCheckbox:checked').length;
            if (!checked) return false;
            return confirm('Are you sure you want to delete ' + checked + ' selected student(s)?');
        }
    })();
</script>

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
</script>

</body>
</html>
