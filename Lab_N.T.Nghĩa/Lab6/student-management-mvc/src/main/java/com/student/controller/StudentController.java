package com.student.controller;

import com.student.dao.StudentDAO;
import com.student.model.Student;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/student")
public class StudentController extends HttpServlet {

    private transient StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) action = "list";

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            case "search":
                searchStudents(request, response);
                break;
            case "sort":
                sortStudents(request, response);
                break;
            case "filter":
                filterStudents(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        switch (action) {
            case "insert":
                insertStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
        }
    }

    // List all students
    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get current page (default to 1)
            String pageParam = request.getParameter("page");
            int currentPage = 1;

            if (pageParam != null) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            // Records per page
            int recordsPerPage = 10;

            // Get total records and calculate total pages
            int totalRecords = studentDAO.getTotalStudents();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            // Handle edge cases
            if (currentPage < 1) {
                currentPage = 1;
            }
            if (totalPages > 0 && currentPage > totalPages) {
                currentPage = totalPages;
            }

            // Calculate offset
            int offset = (currentPage - 1) * recordsPerPage;

            // Get paginated data
            List<Student> students = studentDAO.getStudentsPaginated(offset, recordsPerPage);

            // Set attributes
            request.setAttribute("students", students);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);

            System.out.println("Page " + currentPage + "/" + totalPages + " - Loaded " + students.size() + " students.");

            request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Failed to load students: " + e.getMessage());
            request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
        }
    }


    // Show form for new student
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }

    // Show form for editing student
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Student existingStudent = studentDAO.getStudentById(id);

        request.setAttribute("student", existingStudent);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }

    // Insert new student
    private void insertStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student newStudent = new Student(studentCode, fullName, email, major);

        if (!validateStudent(newStudent, request)) {
            request.setAttribute("student", newStudent);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (studentDAO.addStudent(newStudent)) {
            response.sendRedirect("student?action=list&message=Student added successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to add student");
        }
    }

    // Update student
    private void updateStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student student = new Student(studentCode, fullName, email, major);
        student.setId(id);

        if (!validateStudent(student, request)) {
            request.setAttribute("student", student);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (studentDAO.updateStudent(student)) {
            response.sendRedirect("student?action=list&message=Student updated successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to update student");
        }
    }

    // Delete student
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        if (studentDAO.deleteStudent(id)) {
            response.sendRedirect("student?action=list&message=Student deleted successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to delete student");
        }
    }

    // Search students
    private void searchStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        try {
            List<Student> students = studentDAO.searchStudents(keyword);
            request.setAttribute("students", students);
            request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Failed to search students: " + e.getMessage());
            request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
        }
    }

    // Validate student
    private boolean validateStudent(Student student, HttpServletRequest request) {
        boolean isValid = true;

        String studentCode = student.getStudentCode();
        if (studentCode == null || studentCode.trim().isEmpty()) {
            request.setAttribute("errorCode", "Student Code cannot be empty.");
            isValid = false;
        } else {
            String studentCodePattern = "^[A-Z]{2}[0-9]{3,}$";
            if (!studentCode.matches(studentCodePattern)) {
                request.setAttribute("errorCode", "Invalid Student Code. It should start with two uppercase letters followed by at least three digits (e.g., SV001).");
                isValid = false;
            }
        }

        String fullName = student.getFullName();
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("errorName", "Full Name cannot be empty.");
            isValid = false;
        } else if (fullName.trim().length() < 2) {
            request.setAttribute("errorName", "Full Name must be at least 2 characters.");
            isValid = false;
        }

        String studentEmail = student.getEmail();
        if (studentEmail != null && !studentEmail.trim().isEmpty()) {
            String emailTrim = studentEmail.trim();
            if (!emailTrim.contains("@") || !emailTrim.contains(".")) {
                request.setAttribute("errorEmail", "Invalid Email format.");
                isValid = false;
            }
        }

        String major = student.getMajor();
        if (major == null || major.trim().isEmpty()) {
            request.setAttribute("errorMajor", "Major cannot be empty.");
            isValid = false;
        }

        return isValid;
    }

    // Sort Student
    private void sortStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order"); // "asc" or "desc"
        try {
            List<Student> students = studentDAO.getStudentsSorted(sortBy, order);
            request.setAttribute("students", students);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("order", order);
            request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Failed to sort students: " + e.getMessage());
            request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
        }
    }

    private void filterStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String major = request.getParameter("major");
        try {
            List<Student> students = studentDAO.getStudentsByMajor(major);
            request.setAttribute("students", students);
            request.setAttribute("selectedMajor", major);
            request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Failed to filter students: " + e.getMessage());
            request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
        }

    }


}
