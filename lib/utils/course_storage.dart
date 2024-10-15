import 'package:sembast/sembast.dart';

class CourseStorage {
  static const String _storeName = 'courses';
  static final _store = intMapStoreFactory.store(_storeName);

  final Database _db;

  CourseStorage(this._db);

  Future<String> storeCourse(String courseJson) async {
    final key = await _store.add(_db, {'data': courseJson});
    return key.toString();
  }

  Future<String?> getCourse(String courseId) async {
    final snapshot = await _store.record(int.parse(courseId)).get(_db);
    return snapshot?['data'] as String?;
  }
}