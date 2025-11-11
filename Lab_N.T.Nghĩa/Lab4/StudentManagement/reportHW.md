# Lab 4 - JSP + JDBC + CRUD
## Exercise 5: SEARCH FUNCTIONALITY
### 5.1: Create Search Form
#### How does it work?
1. Create a search form in your JSP page (e.g., `list_students.jsp`) that allows users to input a keyword to search for students by name or code.
2. The form should submit the search query to the same page using the GET method.
3. When the form is submitted, retrieve the search keyword from the request parameters and use it to filter the student records displayed on the page.
4. If the search keyword is empty, display all student records.
5. Include a "Clear" button or link that resets the search and displays all student records again.
6. Ensure that the search input retains its value after submission for better user experience.
#### Code Snippet:
```html
<form class="search-form" action="list_students.jsp" method="GET" onsubmit="return submitForm(this)">
    <label for="keyword" class="sr-only">Search students by name or code</label>
    <input id="keyword" class="search-input" type="text" name="keyword" placeholder="Search by name or code..." value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
    <button class="search-button" type="submit">Search</button>
    <a class="clear-link" href="list_students.jsp">Clear</a>
</form>
```
#### Results:
![ResultEx51.png](Img/ResultEx51.png)

### 5.2: Implement Search Logic
#### How does it work?
1. In your JSP page (e.g., `list_students.jsp`), retrieve the search keyword from the request parameters.
2. Modify the SQL query used to fetch student records from the database to include a WHERE clause that filters records based on the search keyword.
3. Use the `LIKE` operator in SQL to perform partial matching on the student name and code fields.
4. If the search keyword is empty, fetch all student records without any filtering.
5. Display the filtered or unfiltered student records in the table on the JSP page.
#### Code Snippet:
```jsp
<%
String keyword = request.getParameter("keyword");
String sql;
if (keyword != null && !keyword.trim().isEmpty()) {
    sql = "SELECT * FROM students WHERE name LIKE ? OR code LIKE ?";    
} else {
    sql = "SELECT * FROM students";
}
PreparedStatement pstmt = conn.prepareStatement(sql);
if (keyword != null && !keyword.trim().isEmpty()) {
    String searchPattern = "%" + keyword + "%";
    pstmt.setString(1, searchPattern);
    pstmt.setString(2, searchPattern);
}
ResultSet rs = pstmt.executeQuery();
```
#### Results:
##### Test Case 1: Search with keyword "John"
![ResultEx52_1.png](Img/ResultEx52_1.png)
##### Test Case 2: Search with keyword "SV001"
![ResultEx52_2.png](Img/ResultEx52_2.png)
##### Test Case 3: Search with keyword "science" 
![ResultEx52_3.png](Img/ResultEx52_3.png)
##### Test Case 3: Search with empty keyword
![ResultEx52_4.png](Img/ResultEx52_4.png)
---

## Exercise 6: VALIDATION ENHANCEMENT
### 6.1: Email Validation
#### How does it work?
1. In your JSP page for adding or editing student records (e.g., `add_student.jsp` or `edit_student.jsp`), add a JavaScript function to validate the email format before form submission.
2. Use a regular expression to check if the email input matches a valid email pattern.
3. If the email format is invalid, display an error message and prevent form submission.
4. If the email format is valid, allow the form to be submitted to the server for further processing.
#### Code Snippet:
```html
<div class="form-group">
   <label for="email">Email</label>
   <input type="email" id="email" name="email" placeholder="student@email.com">
</div>
```
```jsp
    String email = request.getParameter("email");
    if (email != null) email = email.trim();

    // Validate email only if provided
    String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
    if (email != null && !email.isEmpty()) {
        if (!email.matches(emailRegex)) {
            // Invalid email format
            response.sendRedirect("add_student.jsp?error=Invalid email format");
            return;
        }
    }
```
#### Results:
##### Test Case 1: Valid Email
![ResultEx61_1.png](Img/ResultEx61_1.png)
![ResultEx61_2.png](Img/ResultEx61_2.png)
##### Test Case 2: Invalid Email
![ResultEx61_3.png](Img/ResultEx61_3.png)
![ResultEx61_4.png](Img/ResultEx61_4.png)