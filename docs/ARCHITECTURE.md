# ARCHITECTURE

# Student Result Management System (SRMS)

Version: 1.0

---

# Project Architecture

This project follows a Clean Architecture with Repository Pattern.

```text
Presentation Layer
        │
        ▼
Repository Layer
        │
        ▼
Service Layer
        │
        ▼
SQLite Database
```

---

# Folder Structure

```text
lib/

core/
│
├── constants/
├── theme/
└── utils/

database/
│
├── database_helper.dart
├── database_tables.dart
└── seed_data.dart

models/
│
└── student_model.dart

repositories/
│
└── student_repository.dart

services/
│
└── student_service.dart

screens/
│
├── home/
├── result/
└── admin/

widgets/
│
├── custom_dropdown.dart
├── custom_textfield.dart
├── primary_button.dart
└── home_header.dart

main.dart
```

---

# Layer Responsibilities

## Presentation Layer

Contains all UI screens and widgets.

Examples

* Home Screen
* Result Screen
* Admin Dashboard
* Student List
* Add Student

This layer never talks directly to SQLite.

---

## Repository Layer

Acts as the bridge between UI and Services.

Responsibilities

* Receive requests from UI.
* Call the appropriate service.
* Return processed data.

Current Repository

* StudentRepository

---

## Service Layer

Handles all database operations.

Responsibilities

* Insert Student
* Update Student
* Delete Student
* Search Student
* Load Student List

Current Service

* StudentService

---

## Database Layer

Responsible for local data storage.

Current Database

SQLite

Current Table

students

---

# Data Flow

Search Student

```text
Home Screen

↓

Student Repository

↓

Student Service

↓

SQLite

↓

Student Service

↓

Repository

↓

Home Screen

↓

Result Screen
```

---

# Add Student Flow

```text
Add Student Screen

↓

Validation

↓

Repository

↓

Student Service

↓

SQLite Database

↓

Success Message

↓

Return to Dashboard
```

---

# Student List Flow

```text
Student List Screen

↓

Repository

↓

Service

↓

SQLite

↓

ListView
```

---

# Edit Student Flow

```text
Student List

↓

Edit Button

↓

Edit Screen

↓

Repository

↓

SQLite

↓

Refresh List
```

---

# Delete Student Flow

```text
Student List

↓

Delete Button

↓

Confirmation Dialog

↓

Repository

↓

SQLite

↓

Refresh List
```

---

# Database Schema

students

```text
id
student_id
student_name
father_name
mother_name
session
class_name
exam
roll
group_name
mobile
gpa
```

---

# Reusable Widgets

Current

* CustomTextField
* CustomDropdown
* PrimaryButton
* HomeHeader

Future

* StudentCard
* SubjectCard
* EmptyView
* LoadingWidget
* ConfirmationDialog

---

# Current Features

Completed

* Home Screen
* Result Search
* SQLite
* Student Model
* Student Repository
* Result Screen
* GPA Card
* Subject Result Card
* Admin Dashboard
* Add Student Screen

In Progress

* Student List

Upcoming

* Edit Student
* Delete Student
* Subject Management
* PDF Result
* Print Result

---

# Future Laravel Architecture

```text
Flutter App

↓

Repository

↓

API Service

↓

Laravel REST API

↓

MySQL Database
```

SQLite Service will later be replaceable with API Service without changing the UI.

---

# Design Principles

* Clean Architecture
* Repository Pattern
* Material 3
* Reusable Components
* Single Responsibility Principle
* Readable Code
* No Analyzer Issues
* Production Ready Code

---

# Development Rules

1. Complete one feature before starting another.

2. Run flutter analyze after every completed step.

3. Fix all analyzer issues before continuing.

4. Reuse existing widgets whenever possible.

5. Keep UI separated from business logic.

6. Maintain documentation after every completed milestone.

---

# Long-Term Vision

SRMS will evolve from an offline Flutter application into a complete education management platform.

Planned ecosystem

* Flutter Mobile App
* Laravel Backend API
* Web Admin Panel
* Student Portal
* Teacher Portal
* Parent Portal
* PDF & Print System
* Google Play Release
* Cloud Sync
* Multi-school Support
