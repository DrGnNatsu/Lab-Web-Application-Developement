package com.example.productmanagement.controller;


import com.example.productmanagement.entity.Product;
import com.example.productmanagement.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

    @Controller
    @RequestMapping("/dashboard")
    public class DashboardController {

        private final ProductService productService;

        public DashboardController(ProductService productService) {
            this.productService = productService;
        }

        @GetMapping
        public String showDashboard(Model model) {
            // Total products count
            long totalProducts = productService.getTotalProductCount();
            model.addAttribute("totalProducts", totalProducts);

            // Products by category
            List<String> categories = productService.findAllCategories();
            Map<String, Long> productsByCategory = new LinkedHashMap<>();
            for (String category : categories) {
                long count = productService.countByCategory(category);
                productsByCategory.put(category, count);
            }
            model.addAttribute("productsByCategory", productsByCategory);

            // Total inventory value
            BigDecimal totalValue = productService.calculateTotalInventoryValue();
            model.addAttribute("totalValue", totalValue != null ? totalValue : BigDecimal.ZERO);

            // Average product price
            BigDecimal averagePrice = productService.calculateAveragePrice();
            model.addAttribute("averagePrice", averagePrice != null ? averagePrice : BigDecimal.ZERO);

            // Low stock alerts (quantity < 10)
            List<Product> lowStockProducts = productService.findLowStockProducts(10);
            model.addAttribute("lowStockProducts", lowStockProducts);
            model.addAttribute("lowStockCount", lowStockProducts.size());

            // Recent products (last 5 added)
            Pageable recentPageable = PageRequest.of(0, 5, Sort.by(Sort.Direction.DESC, "createdAt"));
            List<Product> recentProducts = productService.getAllProducts(recentPageable).getContent();
            model.addAttribute("recentProducts", recentProducts);

            return "dashboard";
        }

}
