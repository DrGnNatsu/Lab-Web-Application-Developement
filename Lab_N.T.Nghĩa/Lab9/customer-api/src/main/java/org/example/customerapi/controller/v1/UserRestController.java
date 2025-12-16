package org.example.customerapi.controller.v1;

import jakarta.validation.Valid;
import org.example.customerapi.dto.UpdateProfileDTO;
import org.example.customerapi.dto.LoginHistoryDTO;
import org.example.customerapi.dto.UserResponseDTO;
import org.example.customerapi.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;

import java.util.HashMap;
import java.util.Map;
import java.util.List;

@RestController
@RequestMapping("/api/v1/users")
@CrossOrigin(origins = "*")  // Allow CORS for frontend
public class UserRestController {

    private final UserService userService;

    @Autowired
    public UserRestController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/profile")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<UserResponseDTO> getProfile() {
        // Retrieve and return the authenticated user's profile
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        String username = authentication.getName();
        UserResponseDTO userResponseDTO = userService.getCurrentUser(username);
        return ResponseEntity.ok(userResponseDTO);

    }

    @PutMapping("/profile")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<UserResponseDTO> updateProfile(@Valid @RequestBody UpdateProfileDTO dto) {
        // Update and return the authenticated user's profile
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        UserResponseDTO updatedUser = userService.updateProfile(username, dto);
        return ResponseEntity.ok(updatedUser);
    }

    @DeleteMapping("/account")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<?> deleteAccount(@RequestParam String password) {
        // Verify password and soft-delete account
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        userService.deleteAccount(username, password);

        Map<String, String> response = new HashMap<>();
        response.put("message", "Account has been deactivated successfully.");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/login-history")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<List<LoginHistoryDTO>> getLoginHistory() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        List<LoginHistoryDTO> history = userService.getLoginHistory(username);
        return ResponseEntity.ok(history);
    }
}
