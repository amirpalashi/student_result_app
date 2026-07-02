# DATABASE DOCUMENTATION

## Database

SQLite

Database Name:

student_result.db

---

# Table

students

## Columns

| Column       | Type    |
| ------------ | ------- |
| id           | INTEGER |
| student_id   | TEXT    |
| student_name | TEXT    |
| father_name  | TEXT    |
| mother_name  | TEXT    |
| session      | TEXT    |
| class_name   | TEXT    |
| exam         | TEXT    |
| roll         | TEXT    |
| group_name   | TEXT    |
| mobile       | TEXT    |
| gpa          | REAL    |

---

## Primary Key

id

---

## Unique

student_id

---

## Current Search

* Student ID
* Session
* Class
* Exam

---

## Planned Search

* Class + Roll
* Student Name
* Registration Number

---

## Future Tables

subjects

```
id
subject_name
subject_code
```

student_results

```
student_id
subject_id
marks
grade
gpa
```

settings

```
college_name
logo
address
principal
```
