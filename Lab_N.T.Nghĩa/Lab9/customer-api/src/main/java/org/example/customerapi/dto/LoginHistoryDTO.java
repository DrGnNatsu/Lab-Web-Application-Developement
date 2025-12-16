package org.example.customerapi.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginHistoryDTO {
    private Long id;
    private LocalDateTime loginTime;
    private String ipAddress;
    private String userAgent;
}
