package org.example.customerapi.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CustomerUpdateDTO {
    private String fullName;
    private String email;
    private String phone;
    private String address;

    // Constructors
    public CustomerUpdateDTO() {}

    public CustomerUpdateDTO(String fullName, String email, String phone, String address) {
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }
}
