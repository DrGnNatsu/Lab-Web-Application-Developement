# Secure Customer API with JWT Authentication

## Student Information

- **Name:** Pham Hoang Phuong
- **Student ID:** ITCSIU23056
- **Class:** ITCS23IU41()

## Features Implemented

### Authentication

- ✅ User registration
- ✅ User login with JWT
- ✅ Logout
- ✅ Get current user
- ✅ Password hashing with BCrypt

### Authorization

- ✅ Role-based access control (USER, ADMIN)
- ✅ Protected endpoints
- ✅ Method-level security with @PreAuthorize

### Additional Features

- ✅ Change password
- ✅ Forgot password / Reset password
- ✅ User profile management
- ✅ Admin user management
- ✅ Refresh token
- ✅ Login History (Bonus)

## API Endpoints

### Public Endpoints

- POST /api/v1/auth/register
- POST /api/v1/auth/login

### Protected Endpoints (Authenticated)

- GET /api/v1/auth/me
- POST /api/v1/auth/logout
- GET /api/v1/customers
- GET /api/v1/customers/{id}
- GET /api/v1/users/refresh
- GET /api/v1/users/profile
- PUT /api/v1/users/profile
- DELETE /api/v1/users/accoubnt

### Admin Only Endpoints

- POST /api/v1/customers
- PUT /api/v1/customers/{id}
- DELETE /api/v1/customers/{id}
- GET /api/v1/admin/users
- PUT /api/v1/admin/users/{id}/role
- GET /api/v1/admin/users/{id}/status


## Test Users

| Username | Password | Role |
|----------|----------|------|
| admin | password123 | ADMIN |
| john | password123 | USER |
| jane | password123 | USER |
| testadmin | newpassword123 | ADMIN |
| test1 | password123 | USER |
| test2 | password123 | USER |

## How to Run

1. Create database: `customer_management`
2. Run SQL scripts to create tables
3. Update `application.properties` with your MySQL credentials
4. Run: `mvn spring-boot:run`
5. Test with Thunder Client using provided collection

## Testing

Import Postman collection: `Customer_API.postman_collection.json`

All endpoints tested and working.

## Security

- Passwords hashed with BCrypt
- JWT tokens with 24-hour expiration
- Stateless authentication
- CORS enabled for frontend
- Protected endpoints with Spring Security

## Time Spent

Approximately 10 hours
