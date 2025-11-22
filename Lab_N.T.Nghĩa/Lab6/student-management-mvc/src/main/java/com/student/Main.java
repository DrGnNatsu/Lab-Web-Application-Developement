package com.student;
import com.student.dao.UserDAO;
import com.student.model.User;

public class Main {
    // Add this main method to test (remove after testing)
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();

        // Test authentication
        User user = dao.authenticate("admin", "password123");
        if (user != null) {
            System.out.println("Authentication successful!");
            System.out.println(user);
        } else {
            System.out.println("Authentication failed!");
        }

        // Test with wrong password
        User invalidUser = dao.authenticate("admin", "wrongpassword");
        System.out.println("Invalid auth: " + (invalidUser == null ? "Correctly rejected" : "ERROR!"));
    }

}
