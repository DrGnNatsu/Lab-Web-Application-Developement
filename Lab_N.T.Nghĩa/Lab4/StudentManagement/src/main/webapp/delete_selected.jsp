<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.net.URLEncoder" %>
<%
    request.setCharacterEncoding("UTF-8");
    String[] ids = request.getParameterValues("ids");
    if (ids == null || ids.length == 0) {
        String msg = URLEncoder.encode("No students selected.", java.nio.charset.StandardCharsets.UTF_8.name());
        response.sendRedirect("list_students.jsp?error=" + msg);
        return;
    }

    // validate numeric ids and collect
    List<Integer> validIds = new ArrayList<>();
    for (String s : ids) {
        if (s != null && s.matches("\\d+")) {
            try {
                validIds.add(Integer.parseInt(s));
            } catch (NumberFormatException e) { /* ignore */ }
        }
    }

    if (validIds.isEmpty()) {
        String msg = URLEncoder.encode("No valid student ids selected.", java.nio.charset.StandardCharsets.UTF_8.name());
        response.sendRedirect("list_students.jsp?error=" + msg);
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/student_management", "appuser", "apppass");

        StringBuilder sb = new StringBuilder();
        sb.append("DELETE FROM students WHERE id IN (");
        for (int i = 0; i < validIds.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append("?");
        }
        sb.append(")");

        pstmt = conn.prepareStatement(sb.toString());
        for (int i = 0; i < validIds.size(); i++) {
            pstmt.setInt(i + 1, validIds.get(i));
        }

        int deleted = pstmt.executeUpdate();
        String msg = URLEncoder.encode(deleted + " student(s) deleted.", java.nio.charset.StandardCharsets.UTF_8.name());
        response.sendRedirect("list_students.jsp?message=" + msg);
        return;
    } catch (Exception e) {
        String msg = URLEncoder.encode("Error deleting students: " + e.getMessage(), java.nio.charset.StandardCharsets.UTF_8.name());
        response.sendRedirect("list_students.jsp?error=" + msg);
        return;
    } finally {
        try { if (pstmt != null) pstmt.close(); } catch (Exception ignore) {}
        try { if (conn != null) conn.close(); } catch (Exception ignore) {}
    }
%>
