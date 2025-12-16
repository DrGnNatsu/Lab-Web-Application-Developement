package org.example.customerapi.controller.v1;

import org.example.customerapi.dto.*;
import org.example.customerapi.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.access.prepost.PreAuthorize;

import java.util.HashMap;
import java.util.Map;
import java.time.LocalDateTime;

import org.example.customerapi.repository.RefreshTokenRepository;
import org.example.customerapi.entity.RefreshToken;
import org.example.customerapi.entity.User;
import org.example.customerapi.security.JwtTokenProvider;

@RestController
@RequestMapping("/api/v1/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    @Autowired
    private JwtTokenProvider tokenProvider;

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> login(@Valid @RequestBody LoginRequestDTO loginRequest,
                                                  jakarta.servlet.http.HttpServletRequest request) {
        LoginResponseDTO response = userService.login(loginRequest, request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/register")
    public ResponseEntity<UserResponseDTO> register(@Valid @RequestBody RegisterRequestDTO registerRequest) {
        UserResponseDTO response = userService.register(registerRequest);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/me")
    public ResponseEntity<UserResponseDTO> getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();

        UserResponseDTO user = userService.getCurrentUser(username);
        return ResponseEntity.ok(user);
    }

    @PostMapping("/logout")
    public ResponseEntity<Map<String, String>> logout() {
        // In JWT, logout is handled client-side by removing token
        Map<String, String> response = new HashMap<>();
        response.put("message", "Logged out successfully. Please remove token from client.");
        return ResponseEntity.ok(response);
    }

    @PreAuthorize("isAuthenticated()")
    @PutMapping("/change-password")
    public ResponseEntity<Map<String, String>> changePassword(@Valid @RequestBody ChangePasswordDTO dto) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        String username = authentication.getName();
        userService.changePassword(username, dto);
        

        Map<String, String> response = new HashMap<>();
        response.put("message", "Password changed successfully. Please re-login to get a new token.");
        return ResponseEntity.ok(response);
    }

    // Public endpoint to request a password reset token by email
    @PostMapping("/forgot-password")
    public ResponseEntity<Map<String, String>> forgotPassword(@Valid @RequestBody ForgotPasswordRequestDTO request) {
        String token = userService.forgotPassword(request);
        Map<String, String> response = new HashMap<>();
        // In production, you would email this token; returning for demo/testing purpose
        response.put("resetToken", token);
        response.put("message", "If the email exists, a reset token has been generated.");
        return ResponseEntity.ok(response);
    }

    // Public endpoint to reset password using token
    @PostMapping("/reset-password")
    public ResponseEntity<Map<String, String>> resetPassword(@Valid @RequestBody ResetPasswordRequestDTO request) {
        userService.resetPassword(request);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Password reset successfully. You can now log in with your new password.");
        return ResponseEntity.ok(response);
    }

    // Task 9.3: Refresh Access Token
    @PostMapping("/refresh")
    public ResponseEntity<LoginResponseDTO> refreshToken(@RequestBody RefreshTokenDTO dto) {
        RefreshToken rt = refreshTokenRepository.findByToken(dto.getToken())
                .orElseThrow(() -> new IllegalArgumentException("Invalid refresh token"));

        if (rt.getExpiryDate() == null || rt.getExpiryDate().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Refresh token has expired");
        }

        User user = rt.getUser();
        String newAccessToken = tokenProvider.generateTokenFromUsername(user.getUsername());

        LoginResponseDTO response = new LoginResponseDTO(
                newAccessToken,
                user.getUsername(),
                user.getEmail(),
                user.getRole().name(),
                rt.getToken()
        );
        return ResponseEntity.ok(response);
    }
}
