# Student Result Management System (SRMS)

## Project Overview

SRMS (Student Result Management System) is a Flutter-based offline application that allows educational institutions to manage student information and publish examination results. The first version is fully offline using SQLite. A future version will use Laravel as the backend API.

---

## Technology Stack

### Frontend

* Flutter
* Material 3

### Database

* SQLite (sqflite)

### Architecture

* Clean Architecture
* Repository Pattern
* Service Layer

---

## Folder Structure

```
lib/

core/
database/
models/
repositories/
services/
screens/
widgets/
```

---

## Coding Rules

* Use reusable widgets whenever possible.
* Keep UI and business logic separate.
* Always use Repository instead of directly calling services from multiple places.
* Run `flutter analyze` after every completed step.
* Do not continue until `No issues found!`.

---

## Reusable Widgets

* CustomTextField
* CustomDropdown
* PrimaryButton
* HomeHeader

---

## Database

Current Database:

* students

Future Tables:

* subjects
* student_results
* settings
* users
* notices

---

## Development Workflow

1. Implement Feature
2. Test
3. Run flutter analyze
4. Fix Issues
5. Update Documentation
6. Commit Changes

---

## Future Roadmap

Version 1

* Offline Result System

Version 2

* Laravel API
* Online Sync

Version 3

* School ERP
* Attendance
* Notice
* Routine
* Student Portal

---

## Goal

Build a production-ready Student Result Management System suitable for Google Play release and future online deployment.
