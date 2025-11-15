CREATE DATABASE IF NOT EXISTS student_management;
USE student_management;

CREATE TABLE students (
                          id INT PRIMARY KEY AUTO_INCREMENT,
                          student_code VARCHAR(20) UNIQUE NOT NULL,
                          full_name VARCHAR(100) NOT NULL,
                          email VARCHAR(100) NOT NULL,
                          major VARCHAR(100) NOT NULL,
                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO students (student_code, full_name, email, major) VALUES
                                                                 ('SV001', 'Nguyen Van A', 'a.nguyen@example.com', 'Computer Science'),
                                                                 ('SV002', 'Tran Thi B', 'b.tran@example.com', 'Information Technology'),
                                                                 ('SV003', 'Le Van C', 'c.le@example.com', 'Software Engineering');
