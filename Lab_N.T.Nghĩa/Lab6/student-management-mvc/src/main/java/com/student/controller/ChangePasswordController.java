package com.student.controller;

import com.student.dao.UserDAO;
import com.student.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show change password form
        request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login?message=Please+login+first");
            return;
        }

        Object uidObj = session.getAttribute("userId");
        if (uidObj == null) {
            response.sendRedirect("login?message=Please+login+first");
            return;
        }

        int userId;
        try {
            userId = (uidObj instanceof Integer) ? (Integer) uidObj : Integer.parseInt(uidObj.toString());
        } catch (NumberFormatException e) {
            response.sendRedirect("login?message=Please+login+first");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null || confirmPassword == null) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }

        User user = userDAO.findById(userId);
        if (user == null) {
            response.sendRedirect("login?message=Please+login+first");
            return;
        }

        String storedHash = user.getPassword(); // assumed stored hashed password
        String currentHash = hashPassword(currentPassword);

        if (!currentHash.equals(storedHash)) {
            request.setAttribute("error", "Current password is incorrect.");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 8) {
            request.setAttribute("error", "New password must be at least 8 characters long.");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and confirmation do not match.");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }

        String newHash = hashPassword(newPassword);
        boolean updated = userDAO.updatePassword(userId, newHash);

        if (updated) {
            response.sendRedirect("change-password?message=Password+changed+successfully");
        } else {
            request.setAttribute("error", "Failed to update password. Please try again.");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
        }
    }

    private String hashPassword(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashed = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashed) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            // fallback (should not happen), return plain (not recommended for production)
            return Integer.toHexString(input.hashCode());
        }
    }
}