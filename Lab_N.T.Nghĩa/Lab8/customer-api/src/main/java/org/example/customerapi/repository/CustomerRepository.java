package org.example.customerapi.repository;

import org.example.customerapi.entity.Customer;
import org.example.customerapi.enum_class.CustomerStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {

    Optional<Customer> findByCustomerCode(String customerCode);

    Optional<Customer> findByEmail(String email);

    boolean existsByCustomerCode(String customerCode);

    boolean existsByEmail(String email);

    List<Customer> findByStatus(CustomerStatus status);

    @Query("SELECT c FROM Customer c WHERE " +
            "LOWER(c.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
            "LOWER(c.customerCode) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Customer> searchCustomers(@Param("keyword") String keyword);

    @Query("SELECT c FROM Customer c WHERE " +
            "(:fullName IS NULL OR LOWER(c.fullName) LIKE LOWER(CONCAT('%', :fullName, '%'))) AND " +
            "(:email IS NULL OR LOWER(c.email) LIKE LOWER(CONCAT('%', :email, '%'))) AND " +
            "(:status IS NULL OR c.status = :status)")
    List<Customer> advancedSearch(@Param("fullName") String fullName,
                                  @Param("email") String email,
                                  @Param("status") CustomerStatus status);

    @Query("SELECT c FROM Customer c ORDER BY " +
            "CASE WHEN :sort = 'asc' THEN " +
            "   CASE WHEN :sortBy = 'fullName' THEN c.fullName END ASC, " +
            "   CASE WHEN :sortBy = 'email' THEN c.email END ASC, " +
            "   CASE WHEN :sortBy = 'customerCode' THEN c.customerCode END ASC " +
            "WHEN :sort = 'desc' THEN " +
            "   CASE WHEN :sortBy = 'fullName' THEN c.fullName END DESC, " +
            "   CASE WHEN :sortBy = 'email' THEN c.email END DESC, " +
            "   CASE WHEN :sortBy = 'customerCode' THEN c.customerCode END DESC " +
            "END")
    Page<Customer> findAll(PageRequest of, @Param("sort") Sort sort, @Param("sortBy") String sortBy);
}
