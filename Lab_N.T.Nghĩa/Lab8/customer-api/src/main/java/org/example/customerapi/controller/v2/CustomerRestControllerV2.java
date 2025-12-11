package org.example.customerapi.controller.v2;

import org.example.customerapi.dto.CustomerResponseDTO;
import org.example.customerapi.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@RequestMapping("/api/v2/customers")
@CrossOrigin(origins = "*")  // Allow CORS for frontend
public class CustomerRestControllerV2 {

    private final CustomerService customerService;

    @Autowired
    public CustomerRestControllerV2(CustomerService customerService) {
        this.customerService = customerService;
    }

    // GET all customers
    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllCustomers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String sortBy,
            @RequestParam(defaultValue = "asc") String sortDir) {

        Sort sort = sortDir.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();

        Page<CustomerResponseDTO> customerPage = customerService.getAllCustomers(page, size, sort);

        Map<String, Object> response = new HashMap<>();
        response.put("customers", customerPage.getContent());
        response.put("currentPage", customerPage.getNumber());
        response.put("totalItems", customerPage.getTotalElements());
        response.put("totalPages", customerPage.getTotalPages());

        return ResponseEntity.ok(response);
    }

    // GET customer by ID
    @GetMapping("/{id}")
    public ResponseEntity<CustomerResponseDTO> getCustomerById(@PathVariable Long id) {
        CustomerResponseDTO customer = customerService.getCustomerById(id);

        customer.add(linkTo(methodOn(CustomerRestControllerV2.class).getCustomerById(id)).withSelfRel());
        customer.add(linkTo(methodOn(CustomerRestControllerV2.class).getAllCustomers(0, 10, "id", "asc")).withRel("all-customers"));

        return ResponseEntity.ok(customer);
    }


}
