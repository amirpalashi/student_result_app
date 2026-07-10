class EducationHelper {
  EducationHelper._();

  static const List<String> juniorClasses = [
    'Play',
    'Nursery',
    'KG',
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
    'Class 6',
    'Class 7',
    'Class 8',
  ];

  static bool hasGroup(String? className) {
    return !juniorClasses.contains(className);
  }

  static List<String> availableGroups(String? className) {
    if (!hasGroup(className)) {
      return const ['General'];
    }

    return const [
      'Science',
      'Business Studies',
      'Humanities',
    ];
  }
}