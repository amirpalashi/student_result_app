# API_PLAN

# Student Result Management System (SRMS)

Version: 1.0

Status: Future Development

Backend: Laravel 12

Database: MySQL

Authentication: Laravel Sanctum (Planned)

---

# Objective

The current version uses SQLite.

Future versions will replace SQLite with a Laravel REST API without changing the UI.

The Repository Pattern makes this possible.

---

# Architecture

```text
Flutter UI

↓

Repository

↓

API Service

↓

Laravel REST API

↓

MySQL Database
```

---

# Base URL

Development

```text
http://localhost:8000/api
```

Production

```text
https://your-domain.com/api
```

---

# Authentication

Future

POST

```text
/api/login
```

Response

```json
{
  "token": "xxxxxxxxxxxxxxxx"
}
```

The token will be stored securely in Flutter.

---

# Student APIs

## Get All Students

GET

```text
/api/students
```

Response

```json
[
  {
    "id":1,
    "student_id":"1001",
    "student_name":"Rahim"
  }
]
```

---

## Get Single Student

GET

```text
/api/students/{id}
```

---

## Search Result

POST

```text
/api/result/search
```

Request

```json
{
    "student_id":"1001",
    "session":"2025-26",
    "class":"Class XI",
    "exam":"Final"
}
```

Future Support

```json
{
    "roll":"15",
    "class":"Class XI",
    "session":"2025-26",
    "exam":"Final"
}
```

---

## Add Student

POST

```text
/api/students
```

---

## Update Student

PUT

```text
/api/students/{id}
```

---

## Delete Student

DELETE

```text
/api/students/{id}
```

---

# Subject APIs

GET

```text
/api/subjects
```

POST

```text
/api/subjects
```

PUT

```text
/api/subjects/{id}
```

DELETE

```text
/api/subjects/{id}
```

---

# Result APIs

GET

```text
/api/results
```

POST

```text
/api/results
```

PUT

```text
/api/results/{id}
```

DELETE

```text
/api/results/{id}
```

---

# Dashboard APIs

GET

```text
/api/dashboard
```

Response

```json
{
    "students":520,
    "results":480,
    "subjects":12
}
```

---

# Future Modules

Attendance

```text
/api/attendance
```

Routine

```text
/api/routines
```

Notice

```text
/api/notices
```

Teacher

```text
/api/teachers
```

Parent

```text
/api/parents
```

---

# Flutter Repository Strategy

Current

```text
Home Screen

↓

StudentRepository

↓

StudentService

↓

SQLite
```

Future

```text
Home Screen

↓

StudentRepository

↓

ApiStudentService

↓

Laravel API
```

The UI will remain unchanged.

Only the service implementation will change.

---

# Error Handling

HTTP Status Codes

200 OK

201 Created

400 Validation Error

401 Unauthorized

404 Not Found

500 Server Error

Flutter will display proper user-friendly messages.

---

# Security

Laravel Sanctum

HTTPS

Request Validation

Rate Limiting

Token Authentication

---

# Future File Upload

Student Photo

College Logo

PDF Upload

---

# Future Reports

PDF Result

Excel Export

Student List Export

Attendance Report

---

# Final Goal

Build a scalable Student Result Management System that works both offline (SQLite) and online (Laravel API) while keeping the same Flutter UI.
