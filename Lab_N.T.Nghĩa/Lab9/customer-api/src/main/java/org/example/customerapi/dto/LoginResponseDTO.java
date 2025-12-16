package org.example.customerapi.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LoginResponseDTO {

    // Getters and Setters
    private String token;
    private String type = "Bearer";
    private String username;
    private String email;
    private String role;
    private String refreshToken;

    public LoginResponseDTO() {
    }

    public LoginResponseDTO(String token, String username, String email, String role) {
        this.token = token;
        this.username = username;
        this.email = email;
        this.role = role;
    }

    public LoginResponseDTO(String token, String username, String email, String role, String refreshToken) {
        this.token = token;
        this.username = username;
        this.email = email;
        this.role = role;
        this.refreshToken = refreshToken;
    }

}

