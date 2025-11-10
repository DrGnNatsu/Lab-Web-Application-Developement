<%--
  Created for bulk student deletion
  User: AI Assistant
  Date: 11/11/25
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.net.URLEncoder" %>
<%
    String[] selectedIdsArray = request.getParameterValues("selectedIds");

    if (selectedIdsArray == null || selectedIdsArray.length == 0) {
        response.sendRedirect("list_students.jsp?error=No students selected for deletion");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    int successCount = 0;
    int errorCount = 0;
    List<String> errorMessages = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/student_management",
                "appuser",
                "apppass"
        );

        // Use transaction for bulk delete to ensure consistency
        conn.setAutoCommit(false);

        String sql = "DELETE FROM students WHERE id = ?";
        pstmt = conn.prepareStatement(sql);

        for (String idStr : selectedIdsArray) {
            try {
                int studentId = Integer.parseInt(idStr);
                pstmt.setInt(1, studentId);

                int rowsAffected = pstmt.executeUpdate();
                if (rowsAffected > 0) {
                    successCount++;
                } else {
                    errorCount++;
                    errorMessages.add("Student ID " + studentId + " not found");
                }
            } catch (NumberFormatException e) {
                errorCount++;
                errorMessages.add("Invalid ID: " + idStr);
            } catch (SQLException e) {
                errorCount++;
                if (e.getMessage().contains("foreign key constraint")) {
                    errorMessages.add("Student ID " + idStr + " has related records");
                } else {
                    errorMessages.add("Database error for ID " + idStr);
                }
            }
        }

        // Commit the transaction
        conn.commit();

        // Prepare success/error message
        StringBuilder message = new StringBuilder();
        if (successCount > 0) {
            message.append(successCount).append(" student(s) deleted successfully");
        }

        if (errorCount > 0) {
            if (successCount > 0) {
                message.append("; ");
            }
            message.append(errorCount).append(" deletion(s) failed");
            if (!errorMessages.isEmpty()) {
                message.append(": ").append(String.join(", ", errorMessages));
            }
        }

        if (successCount > 0 && errorCount == 0) {
            response.sendRedirect("list_students.jsp?message=" + URLEncoder.encode(message.toString(), "UTF-8"));
        } else if (successCount > 0 && errorCount > 0) {
            response.sendRedirect("list_students.jsp?message=" + URLEncoder.encode(message.toString(), "UTF-8"));
        } else {
            response.sendRedirect("list_students.jsp?error=" + URLEncoder.encode(message.toString(), "UTF-8"));
        }

    } catch (ClassNotFoundException e) {
        try {
            if (conn != null) conn.rollback();
        } catch (SQLException rollbackEx) {
            rollbackEx.printStackTrace();
        }
        response.sendRedirect("list_students.jsp?error=" + URLEncoder.encode("JDBC Driver not found", "UTF-8"));
        e.printStackTrace();
    } catch (SQLException e) {
        try {
            if (conn != null) conn.rollback();
        } catch (SQLException rollbackEx) {
            rollbackEx.printStackTrace();
        }
        response.sendRedirect("list_students.jsp?error=" + URLEncoder.encode("Database connection error", "UTF-8"));
        e.printStackTrace();
    } catch (Exception e) {
        try {
            if (conn != null) conn.rollback();
        } catch (SQLException rollbackEx) {
            rollbackEx.printStackTrace();
        }
        response.sendRedirect("list_students.jsp?error=" + URLEncoder.encode("Unexpected error occurred", "UTF-8"));
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) {
                conn.setAutoCommit(true); // Reset auto-commit
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
