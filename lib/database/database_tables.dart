class DatabaseTables {
  DatabaseTables._();

  // ==========================
  // Table Names
  // ==========================

  static const String studentTable = 'students';
  static const String subjectResultTable = 'subject_results';
  static const String subjectTable = 'subjects';
  static const String schoolSettingsTable = 'school_settings';

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
  full_marks INTEGER NOT NULL DEFAULT 100,
  pass_marks INTEGER NOT NULL DEFAULT 33,
  marks INTEGER NOT NULL,
  grade TEXT NOT NULL,
  grade_point REAL NOT NULL
)
''';

  // ==========================
  // Subjects Table
  // ==========================

  static const String createSubjectTable = '''
CREATE TABLE subjects(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  class_name TEXT NOT NULL,
  group_name TEXT NOT NULL,
  subject_name TEXT NOT NULL,
  full_marks INTEGER NOT NULL DEFAULT 100,
  pass_marks INTEGER NOT NULL DEFAULT 33
)
''';

  // ==========================
  // School Settings Table
  // ==========================

  static const String createSchoolSettingsTable = '''
CREATE TABLE IF NOT EXISTS school_settings(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  organization_name TEXT NOT NULL,
  eiin TEXT NOT NULL,
  address TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT NOT NULL,
  website TEXT NOT NULL,
  principal_name TEXT NOT NULL,
  principal_designation TEXT NOT NULL,
  logo_path TEXT,
  principal_photo_path TEXT,
  principal_signature_path TEXT
)
''';
}