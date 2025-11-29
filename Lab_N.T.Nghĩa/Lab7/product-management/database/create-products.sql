CREATE DATABASE product_management;
USE product_management;

CREATE TABLE products
(
    id           BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_code VARCHAR(20) UNIQUE NOT NULL,
    name         VARCHAR(100)       NOT NULL,
    price        DECIMAL(10, 2)     NOT NULL,
    quantity     INT       DEFAULT 0,
    category     VARCHAR(50),
    description  TEXT,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO products (product_code, name, price, quantity, category, description)
VALUES ('P001', 'Laptop Dell XPS 13', 1299.99, 10, 'Electronics', 'High-performance laptop with Intel i7'),
       ('P002', 'iPhone 15 Pro', 999.99, 25, 'Electronics', 'Latest iPhone with A17 Pro chip'),
       ('P003', 'Samsung Galaxy S24', 899.99, 20, 'Electronics', 'Flagship Android smartphone'),
       ('P004', 'Office Chair Ergonomic', 199.99, 50, 'Furniture', 'Comfortable office chair with lumbar support'),
       ('P005', 'Standing Desk', 399.99, 15, 'Furniture', 'Adjustable height standing desk');
