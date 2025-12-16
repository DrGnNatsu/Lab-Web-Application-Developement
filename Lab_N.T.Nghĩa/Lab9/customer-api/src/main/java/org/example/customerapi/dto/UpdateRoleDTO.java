package org.example.customerapi.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;
import org.example.customerapi.enum_class.Role;

@Getter
@Setter
public class UpdateRoleDTO {
    @NotNull
    private Role role;
}
