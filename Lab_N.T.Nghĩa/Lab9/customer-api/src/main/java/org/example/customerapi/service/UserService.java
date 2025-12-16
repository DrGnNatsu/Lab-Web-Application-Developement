package org.example.customerapi.service;


import jakarta.validation.Valid;
import org.example.customerapi.dto.*;
import java.util.List;

public interface UserService {

    LoginResponseDTO login(LoginRequestDTO loginRequest, jakarta.servlet.http.HttpServletRequest request);

    UserResponseDTO register(RegisterRequestDTO registerRequest);

    UserResponseDTO getCurrentUser(String username);

    void changePassword(String username, ChangePasswordDTO dto);

    String forgotPassword(ForgotPasswordRequestDTO request);

    void resetPassword(ResetPasswordRequestDTO request);

    UserResponseDTO updateProfile(String username, @Valid UpdateProfileDTO dto);

    void deleteAccount(String username, String password);

    // Admin operations
    List<UserResponseDTO> getAllUsers();

    UserResponseDTO updateUserRole(Long id, UpdateRoleDTO dto);

    UserResponseDTO toggleUserStatus(Long id);

    // Login history
    java.util.List<org.example.customerapi.dto.LoginHistoryDTO> getLoginHistory(String username);
}
