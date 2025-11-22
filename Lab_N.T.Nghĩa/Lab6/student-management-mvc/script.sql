CREATE DATABASE IF NOT EXISTS student_management;
USE student_management;

CREATE TABLE users (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       full_name VARCHAR(100) NOT NULL,
                       role ENUM('admin', 'user') DEFAULT 'user',
                       is_active BOOLEAN DEFAULT TRUE,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       last_login TIMESTAMP NULL
);

DESCRIBE users;

INSERT INTO users (username, password, full_name, role) VALUES
                                                            ('admin', '$2a$10$yWVO7QzwBqDNTDq6f4YwLu63bGs2/JOPV8ei2nnn3SBIPKTivtDIy', 'Admin User', 'admin'),
                                                            ('john', '$2a$10$yWVO7QzwBqDNTDq6f4YwLu63bGs2/JOPV8ei2nnn3SBIPKTivtDIy', 'John Doe', 'user'),
                                                            ('jane', '$2a$10$yWVO7QzwBqDNTDq6f4YwLu63bGs2/JOPV8ei2nnn3SBIPKTivtDIy', 'Jane Smith', 'user');
