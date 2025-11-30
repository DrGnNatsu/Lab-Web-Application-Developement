package com.example.productmanagement.service;

import com.example.productmanagement.entity.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface ProductService {

    Page<Product> getAllProducts(Pageable pageable);

    Optional<Product> getProductById(Long id);

    Product saveProduct(Product product);

    void deleteProduct(Long id);

    Page<Product> searchProducts(String keyword, Pageable pageable);

    Page<Product> getProductsByCategory(String category, Pageable pageable);

    Page<Product> advancedSearch(String keyword, String category, BigDecimal minPrice, BigDecimal maxPrice, Pageable pageable);

    List<String> findAllCategories();
}
