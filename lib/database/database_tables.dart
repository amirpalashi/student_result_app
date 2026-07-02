class DatabaseTables {
  DatabaseTables._();

  // Table Names
  static const String studentTable = 'students';
  static const String subjectResultTable = 'subject_results';

  // ==========================
  // Students Table
  // ==========================
  static const String createStudentTable = '''
CREATE TABLE students(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  student_id TEXT UNIQUE NOT NULL,
  student_name TEXT NOT NULL,
  father_name TEXT,
  mother_name TEXT,
  session TEXT NOT NULL,
  class_name TEXT NOT NULL,
  exam TEXT NOT NULL,
  roll TEXT,
  group_name TEXT,
  mobile TEXT,
  gpa REAL
)
''';

  // ==========================
  // Subject Results Table
  // ==========================
  static const String createSubjectResultTable = '''
CREATE TABLE subject_results(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  student_id TEXT NOT NULL,
  subject_name TEXT NOT NULL,
  marks INTEGER NOT NULL,
  grade TEXT NOT NULL,
  grade_point REAL NOT NULL
)
''';
}