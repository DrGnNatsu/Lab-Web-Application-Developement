package org.example.customerapi.service;


import org.example.customerapi.dto.LoginRequestDTO;
import org.example.customerapi.dto.LoginResponseDTO;
import org.example.customerapi.dto.RegisterRequestDTO;
import org.example.customerapi.dto.UserResponseDTO;

public interface UserService {

    LoginResponseDTO login(LoginRequestDTO loginRequest);

    UserResponseDTO register(RegisterRequestDTO registerRequest);

    UserResponseDTO getCurrentUser(String username);
}
