# Lab 5: Servlets and MVC Patterns

## Exercise 1: PROJECT SETUP & MODEL LAYER (15 points)
### Task 1.1: Create Project Structure (5 points)
#### Steps:
1. Create new Web Application project: StudentManagementMVC 
2. Create Java packages: model, dao, controller 
3. Create views folder inside Web Pages 
4. Add MySQL Connector/J library
#### Output
![Ex11_1.png](image/Ex11_1.png)

### Task 1.2: Create Student JavaBean (5 points)
#### Steps:
1. Create the file `'src/main/java/com/student/model/Student.java'`. 
2. Declare private attributes: `id:int`, `studentCode:String`, `fullName:String`, `email:String`, `major:String`, `createdAt:Timestamp`. 
3. Import `java.sql.Timestamp`. 
4. Add a public no-arg constructor to satisfy JavaBean requirements. 
5. Add a parameterized constructor for `studentCode`, `fullName`, `email`, `major` (leave `id` and `createdAt` unset). 
6. Generate getters and setters for all attributes. 
7. Override `toString()` to return a readable summary of key fields.
```java
    public String toString() {
        return "Student{" +
                "id=" + id +
                ", studentCode='" + studentCode + '\'' +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", major='" + major + '\'' +
                '}';
    }
```

#### Output:
![Ex12.1.png](image/Ex12.1.png)

### Task 1.3: Create StudentDAO Class (5 points)
#### Steps:
1. Create the file `'src/main/java/com/student/dao/StudentDAO.java'`.
2. Import necessary packages: `java.sql.*`, `java.util.*`, `com.student.model.Student`.
3. Define database connection parameters as private static final strings.
4. Implement a private method `getConnection()` to establish and return a database connection. Create the connection using `DriverManager.getConnection()`. 
5. Implement `getAllStudents()` method to retrieve all student records from the database and return them as a list of `Student` objects. Define list to hold students, execute SQL query, iterate through ResultSet to populate the list. 
```java
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY id DESC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                students.add(student);
            }

        } 
```
6. Implement `addStudent(Student student)` method to insert a new student record into the database.
7. Implement `getStudentById(int id)` method to retrieve a student record by its ID.
8. Implement `updateStudent(Student student)` method to update an existing student record.
9. Implement `deleteStudent(int id)` method to delete a student record by its ID.
10. Handle SQL exceptions appropriately.

#### Output:
![Ex13.1.png](image/Ex13.1.png)

## Exercise 2: CONTROLLER LAYER (15 points)

### Task 2.1: Create Basic Servlet (10 points)
#### Steps:
1. Create the file `'src/main/java/com/student/controller/StudentController.java'`.
2. Import necessary packages: `java.io.*`, `javax.servlet.*`, `javax.servlet
3. .http.*`, `com.student.dao.StudentDAO`, `com.student.model.Student`.
4. Annotate the servlet with `@WebServlet("/students")`.
5. Declare a private instance of `StudentDAO`.
6. Override the `init()` method to initialize the `StudentDAO` instance.
```java
private transient StudentDAO studentDAO;
```
7. Override the `doGet()` method to handle GET requests. Retrieve the list of students.
```java
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
            default:
                listStudents(request, response);
                break;
        }
    }
```
8. Implement helper methods: `listStudents()`, `showNewForm()`, `showEditForm()`, `deleteStudent()`.
```java
private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Student> students = studentDAO.getAllStudents();
            request.setAttribute("students", students); // attribute name must match JSP
            System.out.println("Loaded " + students.size() + " students.");
            request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Failed to load students: " + e.getMessage());
            request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
        }
    }
```
10. Handle exceptions appropriately.

#### Output:
![Ex21_1.png](image/Ex21_1.png)

### Task 2.2: Add More CRUD Methods (10 points)
#### Steps:
1. In `StudentController.java`, override the `doPost()` method to handle POST requests. Choose action based on request parameter.
```java
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
```
2. Implement `insertStudent()` method to add a new student. Get the student details from the request parameters and call the `addStudent` method from `StudentDAO`.
```java
    // Insert new student
    private void insertStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student newStudent = new Student(studentCode, fullName, email, major);

        if (studentDAO.addStudent(newStudent)) {
            response.sendRedirect("student?action=list&message=Student added successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to add student");
        }
    }
```
3. Implement `updateStudent()` method to update an existing student. Get the student details from the request parameters and call the `updateStudent` method from `StudentDAO`.
```java
    // Update student
    private void updateStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student student = new Student(studentCode, fullName, email, major);
        student.setId(id);

        if (studentDAO.updateStudent(student)) {
            response.sendRedirect("student?action=list&message=Student updated successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to update student");
        }
    }
```
4. Implement the `deleteStudent()` method to delete a student. Get the student ID from the request parameter and call the `deleteStudent` method from `StudentDAO`.
```java
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
```
5. Implement `showEditForm()` method to display the edit form for a student. Get the student by ID and set it as a request attribute. Send the request to `student-form.jsp`.
```java
    // Show edit form
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Student existingStudent = studentDAO.getStudentById(id);
        request.setAttribute("student", existingStudent);
        request.getRequestDispatcher("/views/student-form.jsp").forward(request, response);
    }
```
6. Implement `showNewForm()` method to display the new student form. Get the student by ID and set it as a request attribute. Send the request to `student-form.jsp`.
```java
    // Show new student form
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/student-form.jsp").forward(request, response);
    }
```
7. Handle exceptions appropriately.

#### Output:
![Ex22_1.png](image/Ex22_1.png)

## Exercise 3: VIEW LAYER WITH JSTL (15 points)

### Task 3.1: Create Student List View (8 points)
#### Steps:
1. Create the file `'webapp/views/student-list.jsp'`.
2. Add JSTL core taglib directive at top. 
3. Avoid scriptlets; use EL for all values. 
4. Use <c:if> blocks to conditionally show success/error messages. 
5. Use <c:if> with empty to handle empty list case. 
6. Use <c:forEach> to iterate students. 
7. Use ${pageContext.request.contextPath} for safe URLs.

#### Output:
```jsp
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

    <!-- Student Table -->
    <c:choose>
        <c:when test="${not empty students}">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Student Code</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Major</th>
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
```

### Task 3.2: Create Student Form View (7 points)

#### Steps:
1. Create the file `'webapp/views/student-form.jsp'`.
2. Add JSTL core taglib directive at top.
3. Avoid scriptlets; use EL for all values.
4. Use a single form for both add/edit.
5. Use conditional logic to set form action and button text.
6. Pre-fill form fields when editing.
7. Use ${pageContext.request.contextPath} for safe URLs.
8. `c:if` to check if `student` attribute is present to determine add vs edit mode.
9. Form fields for `studentCode`, `fullName`, `email`, `major`.
10. Submit button text changes based on mode.
11. Cancel button to return to student list.

#### Output:
```jsp
<div class="container">
    <h1>
        <c:choose>
            <c:when test="${student != null}">
                ✏️ Edit Student
            </c:when>
            <c:otherwise>
                ➕ Add New Student
            </c:otherwise>
        </c:choose>
    </h1>

    <form action="student" method="POST">
        <!-- Hidden field for action -->
        <input type="hidden" name="action"
               value="${student != null ? 'update' : 'insert'}">

        <!-- Hidden field for ID (only for update) -->
        <c:if test="${student != null}">
            <input type="hidden" name="id" value="${student.id}">
        </c:if>

        <!-- Student Code -->
        <div class="form-group">
            <label for="studentCode">
                Student Code <span class="required">*</span>
            </label>
            <input type="text"
                   id="studentCode"
                   name="studentCode"
                   value="${student.studentCode}"
            ${student != null ? 'readonly' : 'required'}
                   placeholder="e.g., SV001, IT123">
            <p class="info-text">Format: 2 letters + 3+ digits</p>
        </div>

        <!-- Full Name -->
        <div class="form-group">
            <label for="fullName">
                Full Name <span class="required">*</span>
            </label>
            <input type="text"
                   id="fullName"
                   name="fullName"
                   value="${student.fullName}"
                   required
                   placeholder="Enter full name">
        </div>

        <!-- Email -->
        <div class="form-group">
            <label for="email">
                Email <span class="required">*</span>
            </label>
            <input type="email"
                   id="email"
                   name="email"
                   value="${student.email}"
                   required
                   placeholder="student@example.com">
        </div>

        <!-- Major -->
        <div class="form-group">
            <label for="major">
                Major <span class="required">*</span>
            </label>
            <select id="major" name="major" required>
                <option value="">-- Select Major --</option>
                <option value="Computer Science"
                ${student.major == 'Computer Science' ? 'selected' : ''}>
                    Computer Science
                </option>
                <option value="Information Technology"
                ${student.major == 'Information Technology' ? 'selected' : ''}>
                    Information Technology
                </option>
                <option value="Software Engineering"
                ${student.major == 'Software Engineering' ? 'selected' : ''}>
                    Software Engineering
                </option>
                <option value="Business Administration"
                ${student.major == 'Business Administration' ? 'selected' : ''}>
                    Business Administration
                </option>
            </select>
        </div>

        <!-- Buttons -->
        <div class="button-group">
            <button type="submit" class="btn btn-primary">
                <c:choose>
                    <c:when test="${student != null}">
                        💾 Update Student
                    </c:when>
                    <c:otherwise>
                        ➕ Add Student
                    </c:otherwise>
                </c:choose>
            </button>
            <a href="student?action=list" class="btn btn-secondary">
                ❌ Cancel
            </a>
        </div>
    </form>
</div>
```

## Exercise 4: COMPLETE CRUD OPERATIONS (10 points)
### Task 4.1: Complete DAO Methods (5 points)
#### Steps:
1. Update `StudentDAO.java` to fully implement CRUD methods.
2. Use PreparedStatement with ? placeholders. 
3. Bind parameters in order. 
4. For getStudentById, execute query, map columns to a Student if a row exists. 
5. For addStudent, insert row and return true if affected rows > 0. 
6. For updateStudent, update by id and return success flag. 
7. For deleteStudent, delete by id and return success flag. 
8. Handle SQLException with try-with-resources; return null or false on failure.

#### Output:
```java
    public Student getStudentById(int id) {
        String sql = "SELECT * FROM students WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setStudentCode(rs.getString("student_code"));
                student.setFullName(rs.getString("full_name"));
                student.setEmail(rs.getString("email"));
                student.setMajor(rs.getString("major"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                return student;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Add new student
    public boolean addStudent(Student student) {
        String sql = "INSERT INTO students (student_code, full_name, email, major) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, student.getStudentCode());
            pstmt.setString(2, student.getFullName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getMajor());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update student
    public boolean updateStudent(Student student) {
        String sql = "UPDATE students SET student_code = ?, full_name = ?, email = ?, major = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, student.getStudentCode());
            pstmt.setString(2, student.getFullName());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getMajor());
            pstmt.setInt(5, student.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete student
    public boolean deleteStudent(int id) {
        String sql = "DELETE FROM students WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
```
### Task 4.2: Integration Testing (5 points)
#### Steps:
Test Sequence:
1. List: Navigate to /student - should see existing students 
2. Add: Click "Add New Student"
   1. Fill form with test data 
   2. Submit 
   3. Should redirect to list with success message
3. Edit: Click "Edit" on test student
   1. Form should pre-fill
   2. Modify data
   3. Submit
   4. Should redirect with update message
4. Delete: Click "Delete" on test student
   1. Should confirm
   2. Should redirect with delete message
   3. Empty State: Delete all students
   4. Should show "No students found" message

#### Output:
![Ex21_1.png](image/Ex21_1.png)
![Ex40_1.png](image/Ex40_1.png)
![Ex40_2.png](image/Ex40_2.png)
![Ex40_3.png](image/Ex40_3.png)
![Ex40_4.png](image/Ex40_4.png)
![Ex40_5.png](image/Ex40_5.png)

