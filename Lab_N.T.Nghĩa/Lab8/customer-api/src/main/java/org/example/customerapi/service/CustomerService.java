package org.example.customerapi.service;

import org.example.customerapi.dto.CustomerRequestDTO;
import org.example.customerapi.dto.CustomerResponseDTO;
import org.example.customerapi.dto.CustomerUpdateDTO;
import org.example.customerapi.enum_class.CustomerStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;

import java.util.List;

public interface CustomerService {

    Page<CustomerResponseDTO> getAllCustomers(int page, int size, Sort sort);

    CustomerResponseDTO getCustomerById(Long id);

    CustomerResponseDTO createCustomer(CustomerRequestDTO requestDTO);

    CustomerResponseDTO updateCustomer(Long id, CustomerRequestDTO requestDTO);

    void deleteCustomer(Long id);

    List<CustomerResponseDTO> searchCustomers(String keyword);

    List<CustomerResponseDTO> getCustomersByStatus(CustomerStatus status);

    List<CustomerResponseDTO> advancedSearch(String fullName, String email, CustomerStatus status);

    CustomerResponseDTO partialUpdateCustomer(Long id, CustomerUpdateDTO updateDTO);
}
