package org.example.customerapi.controller.v1;

import jakarta.validation.Valid;
import org.example.customerapi.dto.UpdateRoleDTO;
import org.example.customerapi.dto.UserResponseDTO;
import org.example.customerapi.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/admin")
@CrossOrigin(origins = "*")
public class AdminRestController {

    private final UserService userService;

    @Autowired
    public AdminRestController(UserService userService) {
        this.userService = userService;
    }

    // Task 8.1: List All Users
    @GetMapping("/users")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<UserResponseDTO>> getAllUsers() {
        List<UserResponseDTO> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    // Task 8.2: Update User Role
    @PutMapping("/users/{id}/role")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UserResponseDTO> updateUserRole(
            @PathVariable Long id,
            @Valid @RequestBody UpdateRoleDTO dto) {
        UserResponseDTO updated = userService.updateUserRole(id, dto);
        return ResponseEntity.ok(updated);
    }

    // Task 8.3: Deactivate/Activate User
    @PatchMapping("/users/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<UserResponseDTO> toggleUserStatus(@PathVariable Long id) {
        UserResponseDTO updated = userService.toggleUserStatus(id);
        return ResponseEntity.ok(updated);
    }
}
