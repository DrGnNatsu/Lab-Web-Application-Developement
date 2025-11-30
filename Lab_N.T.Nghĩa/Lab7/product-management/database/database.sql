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
       ('P005', 'Standing Desk', 399.99, 15, 'Furniture', 'Adjustable height standing desk'),
       ('P010', 'Wireless Mouse Logitech MX Master 3', 99.99, 35, 'Electronics',
        'Ergonomic wireless mouse with MX wheel'),
       ('P011', 'Mechanical Keyboard Keychron K2', 89.99, 40, 'Electronics',
        'Compact mechanical keyboard with hot-swappable keys'),
       ('P012', 'USB-C Hub 7-in-1', 49.99, 120, 'Electronics', 'Multiport USB-C hub with HDMI and Ethernet'),
       ('P013', 'Noise Cancelling Headphones', 149.99, 25, 'Electronics',
        'Over-ear active noise cancelling headphones'),
       ('P014', '4K Monitor 27-inch', 329.99, 18, 'Electronics', '27-inch 4K IPS monitor with HDR support'),
       ('P015', 'Portable SSD 1TB', 129.99, 60, 'Electronics', 'High-speed external NVMe portable SSD'),
       ('P016', 'Smartwatch Series 6', 199.99, 50, 'Electronics', 'Fitness-focused smartwatch with heart-rate monitor'),
       ('P017', 'Bluetooth Speaker X200', 59.99, 80, 'Electronics', 'Portable Bluetooth speaker with 12h battery'),
       ('P018', 'Desk Lamp LED Adjustable', 39.99, 70, 'Furniture', 'Adjustable LED desk lamp with dimmer'),
       ('P019', 'Ergonomic Office Chair', 249.99, 22, 'Furniture', 'Mesh ergonomic chair with lumbar support'),
       ('P020', 'Bookshelf 5-Tier Oak', 179.99, 15, 'Furniture', '5-tier oak finish bookshelf, easy assembly'),
       ('P021', 'Stainless Steel Cookware Set', 219.99, 28, 'Appliances', '10-piece stainless steel cookware set'),
       ('P022', 'Air Fryer 5L', 99.99, 45, 'Appliances', '5L digital air fryer with multiple presets'),
       ('P023', 'Blender Pro 1200W', 79.99, 38, 'Appliances', 'High-power blender for smoothies and soups'),
       ('P024', 'Cotton Bed Sheet Set', 59.99, 90, 'Home', 'King-size 400TC cotton sheet set'),
       ('P025', 'Ceramic Vase Decorative', 24.99, 200, 'Home', 'Hand-painted ceramic decorative vase'),
       ('P026', 'Running Shoes Model R1', 119.99, 55, 'Sports', 'Lightweight running shoes with breathable mesh'),
       ('P027', 'Fitness Tracker Band', 49.99, 110, 'Sports', 'Activity tracker with sleep monitoring'),
       ('P028', 'Tennis Racket Pro', 89.99, 30, 'Sports', 'Lightweight graphite tennis racket'),
       ('P029', 'Camping Tent 4-Person', 149.99, 12, 'Outdoors', 'Waterproof 4-person dome tent with ventilation'),
       ('P030', 'Yoga Mat Pro', 29.99, 150, 'Sports', 'Non-slip yoga mat with extra cushioning'),
       ('P040', 'Wireless Mouse Logitech MX Master 2', 99.99, 35, 'Electronics',
        'Ergonomic wireless mouse with MX wheel');

