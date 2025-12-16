package org.example.customerapi.service;

import jakarta.validation.Valid;
import org.example.customerapi.dto.*;
import org.example.customerapi.enum_class.Role;
import org.example.customerapi.entity.User;
import org.example.customerapi.entity.LoginHistory;
import org.example.customerapi.entity.RefreshToken;
import org.example.customerapi.exception.DuplicateResourceException;
import org.example.customerapi.exception.ResourceNotFoundException;
import org.example.customerapi.repository.UserRepository;
import org.example.customerapi.repository.RefreshTokenRepository;
import org.example.customerapi.repository.LoginHistoryRepository;
import org.example.customerapi.security.JwtTokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    @Autowired
    private LoginHistoryRepository loginHistoryRepository;

    @Override
    public LoginResponseDTO login(LoginRequestDTO loginRequest, jakarta.servlet.http.HttpServletRequest request) {
        // Authenticate user
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginRequest.getUsername(),
                        loginRequest.getPassword()
                )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);

        // Generate JWT access token
        String token = tokenProvider.generateToken(authentication);

        // Get user details
        User user = userRepository.findByUsername(loginRequest.getUsername())
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        // Create refresh token (7 days)
        String refreshTokenValue = UUID.randomUUID().toString();
        RefreshToken refreshToken = new RefreshToken();
        refreshToken.setUser(user);
        refreshToken.setToken(refreshTokenValue);
        refreshToken.setExpiryDate(LocalDateTime.now().plusDays(7));
        refreshTokenRepository.save(refreshToken);

        // Log successful login
        try {
            String ip = extractClientIp(request);
            String userAgent = request != null ? request.getHeader("User-Agent") : null;
            LoginHistory history = new LoginHistory();
            history.setUser(user);
            history.setIpAddress(ip);
            history.setUserAgent(userAgent);
            history.setLoginTime(LocalDateTime.now());
            loginHistoryRepository.save(history);
        } catch (Exception ignored) {
            // Avoid breaking login flow due to logging errors
        }

        return new LoginResponseDTO(
                token,
                user.getUsername(),
                user.getEmail(),
                user.getRole().name(),
                refreshTokenValue
        );
    }

    private String extractClientIp(jakarta.servlet.http.HttpServletRequest request) {
        if (request == null) return null;
        String[] headers = new String[]{
                "X-Forwarded-For",
                "Proxy-Client-IP",
                "WL-Proxy-Client-IP",
                "HTTP_X_FORWARDED_FOR",
                "HTTP_X_FORWARDED",
                "HTTP_X_CLUSTER_CLIENT_IP",
                "HTTP_CLIENT_IP",
                "HTTP_FORWARDED_FOR",
                "HTTP_FORWARDED",
                "HTTP_VIA",
                "REMOTE_ADDR"
        };
        for (String h : headers) {
            String ip = request.getHeader(h);
            if (ip != null && !ip.isBlank() && !"unknown".equalsIgnoreCase(ip)) {
                // in case of multiple IPs, take the first
                int comma = ip.indexOf(',');
                return comma > 0 ? ip.substring(0, comma).trim() : ip.trim();
            }
        }
        return request.getRemoteAddr();
    }

    @Override
    public UserResponseDTO register(RegisterRequestDTO registerRequest) {
        // Check if username exists
        if (userRepository.existsByUsername(registerRequest.getUsername())) {
            throw new DuplicateResourceException("Username already exists");
        }

        // Check if email exists
        if (userRepository.existsByEmail(registerRequest.getEmail())) {
            throw new DuplicateResourceException("Email already exists");
        }

        // Create new user
        User user = new User();
        user.setUsername(registerRequest.getUsername());
        user.setEmail(registerRequest.getEmail());
        user.setPassword(passwordEncoder.encode(registerRequest.getPassword()));
        user.setFullName(registerRequest.getFullName());
        user.setRole(Role.USER);  // Default role
        user.setIsActive(true);

        User savedUser = userRepository.save(user);

        return convertToDTO(savedUser);
    }

    @Override
    public UserResponseDTO getCurrentUser(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        return convertToDTO(user);
    }

    @Override
    public java.util.List<org.example.customerapi.dto.LoginHistoryDTO> getLoginHistory(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        return loginHistoryRepository.findByUser_IdOrderByLoginTimeDesc(user.getId())
                .stream()
                .map(h -> new org.example.customerapi.dto.LoginHistoryDTO(
                        h.getId(),
                        h.getLoginTime(),
                        h.getIpAddress(),
                        h.getUserAgent()
                ))
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    public void changePassword(String username, ChangePasswordDTO dto) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        // 2. Verify current password
        if (!passwordEncoder.matches(dto.getCurrentPassword(), user.getPassword())) {
            throw new IllegalArgumentException("Current password is incorrect");
        }

        // 3. Check new password matches confirm
        if (!dto.getNewPassword().equals(dto.getConfirmPassword())) {
            throw new IllegalArgumentException("Password confirmation does not match");
        }

        // 4. Hash and update password
        user.setPassword(passwordEncoder.encode(dto.getNewPassword()));
        userRepository.save(user);
    }

    @Override
    public String forgotPassword(ForgotPasswordRequestDTO request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new ResourceNotFoundException("User not found with this email"));

        String token = UUID.randomUUID().toString();
        LocalDateTime expiry = LocalDateTime.now().plusHours(1);

        user.setResetToken(token);
        user.setResetTokenExpiry(expiry);
        userRepository.save(user);

        // In a real application, you would send this token via email.
        return token;
    }

    @Override
    public void resetPassword(ResetPasswordRequestDTO request) {
        User user = userRepository.findByResetToken(request.getResetToken())
                .orElseThrow(() -> new ResourceNotFoundException("Invalid password reset token"));

        if (user.getResetTokenExpiry() == null || user.getResetTokenExpiry().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Password reset token has expired");
        }

        if (!request.getNewPassword().equals(request.getConfirmPassword())) {
            throw new IllegalArgumentException("Password confirmation does not match");
        }

        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        // Clear token
        user.setResetToken(null);
        user.setResetTokenExpiry(null);
        userRepository.save(user);
    }

    @Override
    public void deleteAccount(String username, String password) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        if (!passwordEncoder.matches(password, user.getPassword())) {
            throw new IllegalArgumentException("Password is incorrect");
        }

        user.setIsActive(false);
        // Clear sensitive reset token info on delete for safety
        user.setResetToken(null);
        user.setResetTokenExpiry(null);
        userRepository.save(user);
    }

    @Override
    public UserResponseDTO updateProfile(String username, @Valid UpdateProfileDTO dto) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        // Check if email is changing and if new email already exists
        if (!user.getEmail().equals(dto.getEmail()) && userRepository.existsByEmail(dto.getEmail())) {
            throw new DuplicateResourceException("Email already exists");
        }
        user.setFullName(dto.getFullName());
        user.setEmail(dto.getEmail());
        User updatedUser = userRepository.save(user);
        return convertToDTO(updatedUser);
    }

    private UserResponseDTO convertToDTO(User user) {
        return new UserResponseDTO(
                user.getId(),
                user.getUsername(),
                user.getEmail(),
                user.getFullName(),
                user.getRole().name(),
                user.getIsActive(),
                user.getCreatedAt()
        );
    }

    // ===== Admin operations =====
    @Override
    public List<UserResponseDTO> getAllUsers() {
        return userRepository.findAll()
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public UserResponseDTO updateUserRole(Long id, org.example.customerapi.dto.UpdateRoleDTO dto) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        user.setRole(dto.getRole());
        User saved = userRepository.save(user);
        return convertToDTO(saved);
    }

    @Override
    public UserResponseDTO toggleUserStatus(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        user.setIsActive(user.getIsActive() == null ? Boolean.FALSE : !user.getIsActive());
        User saved = userRepository.save(user);
        return convertToDTO(saved);
    }
}

