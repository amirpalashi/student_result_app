import '../database/database_helper.dart';
import '../database/database_tables.dart';
import '../models/school_settings_model.dart';

class SchoolSettingsService {
  SchoolSettingsService._();

  static final SchoolSettingsService instance = SchoolSettingsService._();

  Future<int> saveSettings(SchoolSettingsModel settings) async {
    final db = await DatabaseHelper.instance.database;

    final existing = await db.query(
      DatabaseTables.schoolSettingsTable,
      limit: 1,
    );

    if (existing.isEmpty) {
      return await db.insert(
        DatabaseTables.schoolSettingsTable,
        settings.toMap(),
      );
    }

    final updatedSettings = settings.copyWith(id: existing.first['id'] as int);

    return await db.update(
      DatabaseTables.schoolSettingsTable,
      updatedSettings.toMap(),
      where: 'id = ?',
      whereArgs: [existing.first['id']],
    );
  }

  Future<SchoolSettingsModel?> getSettings() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(DatabaseTables.schoolSettingsTable, limit: 1);

    if (result.isEmpty) {
      return null;
    }

    return SchoolSettingsModel.fromMap(result.first);
  }

  Future<bool> hasSettings() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.query(DatabaseTables.schoolSettingsTable, limit: 1);

    return result.isNotEmpty;
  }

  Future<void> deleteSettings() async {
    final db = await DatabaseHelper.instance.database;

    await db.delete(DatabaseTables.schoolSettingsTable);
  }
}
