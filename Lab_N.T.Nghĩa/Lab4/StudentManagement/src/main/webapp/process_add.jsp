<%--
  Created by IntelliJ IDEA.
  User: phuong
  Date: 8/11/25
  Time: 08:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String studentCode = request.getParameter("student_code");
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String major = request.getParameter("major");

    // Trim inputs to avoid validation issues due to whitespace
    if (studentCode != null) studentCode = studentCode.trim();
    if (fullName != null) fullName = fullName.trim();
    if (email != null) email = email.trim();
    if (major != null) major = major.trim();

    if (studentCode == null || studentCode.isEmpty() ||
            fullName == null || fullName.isEmpty()) {
        response.sendRedirect("add_student.jsp?error=Required fields are missing");
        return;
    }

    // Validate email only if provided
    // Require a more strict email format: local@domain.tld (simple, not fully RFC-complete)
    // - local part: letters, digits and . _ + -
    // - domain: letters/digits/dots/hyphens and must contain at least one dot with a 2+ letter TLD
    String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
    if (email != null && !email.isEmpty()) {
        if (!email.matches(emailRegex)) {
            // Invalid email format (require domain with TLD like example.com)
            response.sendRedirect("add_student.jsp?error=Invalid email format");
            return;
        }
    }

    if (!studentCode.matches("^[A-Z]{2}[0-9]{3,}")) {
        // Invalid student code format
        response.sendRedirect("add_student.jsp?error=Invalid student code format");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/student_management",
                "appuser",
                "apppass"
        );

        String sql = "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, studentCode);
        pstmt.setString(2, fullName);
        pstmt.setString(3, email);
        pstmt.setString(4, major);

        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("list_students.jsp?message=Student added successfully");
        } else {
            response.sendRedirect("add_student.jsp?error=Failed to add student");
        }

    } catch (ClassNotFoundException e) {
        response.sendRedirect("add_student.jsp?error=Driver not found");
        e.printStackTrace();
    } catch (SQLException e) {
        String errorMsg = e.getMessage();
        if (errorMsg.contains("Duplicate entry")) {
            response.sendRedirect("add_student.jsp?error=Student code already exists");
        } else {
            response.sendRedirect("add_student.jsp?error=Database error");
        }
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
