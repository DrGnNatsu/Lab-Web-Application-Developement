# Customer API Documentation

## Base URL

`http://localhost:8080/api/v1/customers`

## Endpoints

### 1. Get All Customers

**GET** `{{baseURL}}/api/v1/customers?page=0&size=5&sortDir=desc&sortBy=id`

**Response:** 200 OK

```json
{
    "totalItems": 5,
    "totalPages": 1,
    "customers": [],
    "currentPage": 1
}
```

### 2. Get Customer By ID

**GET** `{{baseURL}}/api/v1/customers/1`

**Response:** 200 OK

```json
{
    "id": 1,
    "customerCode": "C001",
    "fullName": "John Partially Updated",
    "email": "john.updated@example.com",
    "phone": "0123456789",
    "address": "New Address",
    "status": "ACTIVE",
    "createdAt": "2025-12-06T08:32:07"
}
```

### 3. Create The User

**POST** `{{baseURL}}/api/v1/customers`

**BODY**:

```json
{
    "customerCode": "C036",
    "fullName": "Niggay",
    "email": "niggay@example.com",
    "phone": "0123456789",
    "address": "Thanh Hoa"
}
```

**Response:** 200 OK

```json
{
    "id": 7,
    "customerCode": "C006",
    "fullName": "David Miller",
    "email": "david.miller@example.com",
    "phone": "0123456789",
    "address": "999 Broadway, Seattle, WA 98101",
    "status": "ACTIVE",
    "createdAt": "2025-12-11T21:56:57.967898"
}
```

### 4. Update Customer

**PUT** `{{baseURL}}/api/v1/customers/6`

**BODY**:

```json
{
    "customerCode": "C036",
    "fullName": "SpiderMan",
    "email": "SpiderMan@example.com",
    "phone": "9876543210",
    "address": "1000 Broadway, Seattle, WA 98101"
}

```

**Response:** 200 OK

```json
{
    "id": 6,
    "customerCode": "C036",
    "fullName": "SpiderMan",
    "email": "SpiderMan@example.com",
    "phone": "9876543210",
    "address": "1000 Broadway, Seattle, WA 98101",
    "status": "ACTIVE",
    "createdAt": "2025-12-11T23:11:36"
}
```

### 4. Partial Update Customer

**PATCH** `{{baseURL}}/api/v1/customers/6`

**BODY**:

```json
{
    "fullName": "Binh Partial Update"
}

```

**Response:** 200 OK

```json
{
    "id": 6,
    "customerCode": "C036",
    "fullName": "Binh Partial Update",
    "email": "SpiderMan@example.com",
    "phone": "9876543210",
    "address": "1000 Broadway, Seattle, WA 98101",
    "status": "ACTIVE",
    "createdAt": "2025-12-11T23:11:36"
}
```

### 5. Delete Customer By ID

**DELETE** `{{baseURL}}/api/v1/customers/2`

**Response:** 200 OK

```json
{
    "message": "Customer deleted successfully"
}
```

### 6. Search Customer

**GET** `{{baseURL}}/api/v1/customers/search?keyword=john`

**Response:** 200 OK

```json
[
    {
        "id": 3,
        "customerCode": "C003",
        "fullName": "Bob Johnson",
        "email": "bob.johnson@example.com",
        "phone": "+1-555-0103",
        "address": "789 Pine Rd, Chicago, IL 60601",
        "status": "ACTIVE",
        "createdAt": "2025-12-11T23:11:21",
        "links": []
    }
]
```

### 7. Filter By Status

**GET** `{{baseURL}}/api/v1/customers/status/INACTIVE`

**Response:** 200 OK

```json
[
    {
        "id": 4,
        "customerCode": "C004",
        "fullName": "Alice Brown",
        "email": "alice.brown@example.com",
        "phone": "+1-555-0104",
        "address": "321 Elm St, Houston, TX 77001",
        "status": "INACTIVE",
        "createdAt": "2025-12-11T23:11:21",
        "links": []
    }
]
```

### 8. API Versioning

**GET** `{{baseURL}}/api/v2/customers/3`

**Response:** 200 OK

```json
{
    "id": 3,
    "customerCode": "C003",
    "fullName": "Bob Johnson",
    "email": "bob.johnson@example.com",
    "phone": "+1-555-0103",
    "address": "789 Pine Rd, Chicago, IL 60601",
    "status": "ACTIVE",
    "createdAt": "2025-12-11T23:11:21",
    "_links": {
        "self": {
            "href": "http://localhost:8080/api/v2/customers/3"
        },
        "all-customers": {
            "href": "http://localhost:8080/api/v2/customers?page=0&size=10&sortBy=id&sortDir=asc"
        }
    }
}
```
