package com.student.controller;

import com.student.dao.StudentDAO;
import com.student.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.util.List;

@WebServlet("/export")
public class ExportController extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<Student> students = studentDAO.getAllStudents();

        // Create workbook and sheet
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Students");

            // Header row
            Row header = sheet.createRow(0);
            String[] headers = new String[] { "ID", "Student Code", "Full Name", "Major", "Email"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = header.createCell(i);
                cell.setCellValue(headers[i]);
            }

            // Data rows
            int rowIdx = 1;
            for (Student s : students) {
                Row row = sheet.createRow(rowIdx++);
                int col = 0;
                row.createCell(col++).setCellValue(s.getId());
                row.createCell(col++).setCellValue(nullToEmpty(s.getStudentCode()));
                row.createCell(col++).setCellValue(nullToEmpty(s.getFullName()));
                row.createCell(col++).setCellValue(nullToEmpty(s.getMajor()));
                row.createCell(col++).setCellValue(nullToEmpty(s.getEmail()));
            }

            // Autosize columns
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // Set response headers
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=students.xlsx");

            // Write workbook to response
            workbook.write(response.getOutputStream());
            response.getOutputStream().flush();
        } catch (Exception e) {
            throw new ServletException("Error exporting students to Excel", e);
        }
    }

    private String nullToEmpty(String s) {
        return s == null ? "" : s;
    }
}