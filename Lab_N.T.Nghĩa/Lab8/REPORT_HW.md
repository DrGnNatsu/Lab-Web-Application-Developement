# Customer API

## Student Information

- **Name:** Pham Hoang Phuong
- **Student ID:** ITCSIU23056
- **Class:** ITCS23IU41()

## API Endpoints

- `http://localhost:8080/api/v1/customers` - `GET, POST`
- `http://localhost:8080/api/v1/customers/{id}` - `GET, PUT, DELETE, PATCH`
- `http://localhost:8080/api/v1/customers/search?keyword=""` - `GET`
- `http://localhost:8080/api/v1/customers/status/{STATUS}` - `GET`
- `http://localhost:8080/api/v1/customers/advanced-search/name=""&email=""&status=""` - `GET`
- `http://localhost:8080/api/v2/customers/{id}` - `GET`

### Base URL

- `http://localhost:8080/api/v1/customers`
- `http://localhost:8080/api/v2/customers`

### Endpoints Implemented

- ✅ GET /api/customers - Get all customers
- ✅ GET /api/customers/{id} - Get by ID
- ✅ POST /api/customers - Create customer
- ✅ PUT /api/customers/{id} - Update customer
- ✅ DELETE /api/customers/{id} - Delete customer
- ✅ GET /api/customers/search?keyword={keyword} - Search
- ✅ GET /api/customers/status/{status} - Filter by status
- ✅ Pagination and sorting
- ✅ PATCH for partial update
- ✅ Bonus: API Version
- ✅ Bonus: HATEOAS Links

## How to Run

1. Create database: `customer_management`
2. Update `application.properties` with your MySQL credentials
3. Run: `mvn spring-boot:run`
4. Test: Open Thunder Client or Postman
5. Import collection: `Customer_API.postman_collection.json`

## Testing

All endpoints tested with PostMan. See `images/` folder for test results.

## Features Implemented

- DTO pattern for request/response
- Validation with @Valid
- Exception handling with @RestControllerAdvice
- Custom exceptions (404, 409)
- Proper HTTP status codes
- Search and filter
- Pagination
- Sorting

## Time Spent

Approximately **6** hours

## EXERCISE 5: SEARCH & FILTER ENDPOINTS (12 points)

### Task 5.1: Search Customers (6 points)

```java
    @Query("SELECT c FROM Customer c WHERE " +
            "LOWER(c.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.customerCode) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Customer> searchCustomers(@Param("keyword") String keyword);

    List<CustomerResponseDTO> searchCustomers(String keyword);

    @GetMapping("/search")
    public ResponseEntity<List<CustomerResponseDTO>> searchCustomers(@RequestParam String keyword) {
        List<CustomerResponseDTO> customers = customerService.searchCustomers(keyword);
        return ResponseEntity.ok(customers);
    }
```

Search API: `http://localhost:8080/api/v1/customers/search?keyword="john"`

![Result_Search_API](/image/416.png)

### Task 5.2: Filter by Status (3 points)

```java
    @GetMapping("/status/{status}")
    public ResponseEntity<List<CustomerResponseDTO>> getCustomersByStatus(@PathVariable CustomerStatus status) {
        List<CustomerResponseDTO> customers = customerService.getCustomersByStatus(status);
        return ResponseEntity.ok(customers);
    }
```

#### Search API INACTIVE

`http://localhost:8080/v1/customers/status/INACTIVE`

![Filter INACTIVE USER](/image/521.png)

#### Search API ACTIVE

`http://localhost:8080/v1/customers/status/INACTIVE`

![Filter ACTIVE USER](/image/522.png)

### Task 5.3: Advanced Search with Multiple Criteria (3 points)

```java
    @GetMapping("/advanced-search")
    public ResponseEntity<List<CustomerResponseDTO>> advancedSearch(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) CustomerStatus status) {
        List<CustomerResponseDTO> customers = customerService.advancedSearch(name, email, status);
        return ResponseEntity.ok(customers);
    }
```

## EXERCISE 6: PAGINATION & SORTING (10 points)

### Task 6.1: Add Pagination (5 points) + Task 6.2: Add Sorting (3 points) + Task 6.3: Combine Pagination and Sorting (2 points)

#### How does it work

1. The `RestController` take 4 parameters:
    - `page`: page number
    - `size`: size of page
    - `sortBy`: sort by Columns
    - `sortDir`: ASC or DESC
2. Get the result throught the `service` and The `Service` call the `Repository`. The `@Query` will query the data from the rows $page \times size$ to $(page+1) \times size - 1$.
3. Cretaae the JSON repsonse.
4. Return the data

#### Implementation

```java
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

    Page<CustomerResponseDTO> getAllCustomers(int page, int size, Sort sort);
```

#### Get All API test 1

`http://localhost:8080/api/v1/customers?page=0&size=5&sortDir=desc&sortBy=id`

![Get All User with Pagnition](/image/621.png)

#### Get All API test 2

`http://localhost:8080/api/v1/customers?page=1&size=10&sortDir=desc&sortBy=id`

![Get All User with Pagnition](/image/622.png)

## EXERCISE 7: PARTIAL UPDATE WITH PATCH (10 points)

### Task 7.1: Create Update DTO (3 points)

```java
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

```

### Task 7.2: Implement PATCH Endpoint (5 points)

```java
    @PatchMapping("/{id}")
    public ResponseEntity<CustomerResponseDTO> partialUpdateCustomer(
            @PathVariable Long id,
            @RequestBody CustomerUpdateDTO updateDTO) {

        CustomerResponseDTO updated = customerService.partialUpdateCustomer(id, updateDTO);
        return ResponseEntity.ok(updated);
    }

    @Override
    public CustomerResponseDTO partialUpdateCustomer(Long id, CustomerUpdateDTO updateDTO) {
        Customer customer = customerRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found"));

        // Only update non-null fields
        if (updateDTO.getFullName() != null) {
            customer.setFullName(updateDTO.getFullName());
        }
        if (updateDTO.getEmail() != null) {
            customer.setEmail(updateDTO.getEmail());
        }
        // ... other fields

        return convertToResponseDTO(customerRepository.save(customer));
    }
```

### Test PATCH vs PUT (2 points)

#### PATCH API

`http://localhost:8080/api/v1/customers/6`

![Get All User with Pagnition](/image/721.png)

#### PUT API

`http://localhost:8080/api/v1/customers/6`

![Get All User with Pagnition](/image/722.png)

## EXERCISE 8: API DOCUMENTATION (8 points)

### Task 8.1: Create Postman Collection (4 points)

[Result Testing](Customer_API.postman_collection.json)

### Task 8.2: Document API Responses (2 points)

## Bonus 1: API Versioning + Bonus 2: HATEOAS Links

```java
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

package org.example.customerapi.dto;

import lombok.Getter;
import lombok.Setter;
import org.springframework.hateoas.RepresentationModel;

import java.time.LocalDateTime;

@Getter
@Setter
public class CustomerResponseDTO extends RepresentationModel<CustomerResponseDTO> {

    private Long id;
    private String customerCode;
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private String status;
    private LocalDateTime createdAt;

    // Constructors
    public CustomerResponseDTO() {
    }

    public CustomerResponseDTO(Long id, String customerCode, String fullName, String email,
                               String phone, String address, String status, LocalDateTime createdAt) {
        this.id = id;
        this.customerCode = customerCode;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.status = status;
        this.createdAt = createdAt;
    }

}
```

![Result of API Versioning + HATEOAS Links](/image/Bonus.png)
