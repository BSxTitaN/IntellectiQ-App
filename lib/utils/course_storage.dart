import 'package:sembast/sembast.dart';
import 'package:intellectiq/models/course.dart';

class CourseStorage {
  static const String _storeName = 'courses';
  static const String _quizScoresStoreName = 'quiz_scores';
  static final _store = intMapStoreFactory.store(_storeName);
  static final _quizScoresStore = intMapStoreFactory.store(_quizScoresStoreName);

  final Database _db;

  CourseStorage(this._db);

  Future<String> storeCourse(Course course) async {
    final key = await _store.add(_db, course.toJson());
    return key.toString();
  }

  Future<Course?> getCourse(String courseId) async {
    final snapshot = await _store.record(int.parse(courseId)).get(_db);
    if (snapshot != null) {
      return Course.fromJson(courseId, snapshot as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Course>> getAllCourses() async {
    final snapshots = await _store.find(_db);
    return snapshots.map((snapshot) {
      return Course.fromJson(snapshot.key.toString(), snapshot.value as Map<String, dynamic>);
    }).toList();
  }

  Stream<List<Course>> getAllCoursesStream() {
    return _store
        .query()
        .onSnapshots(_db)
        .map((snapshots) {
      return snapshots.map((snapshot) {
        return Course.fromJson(snapshot.key.toString(), snapshot.value as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> saveQuizScore(String courseId, int score, DateTime date) async {
    await _quizScoresStore.add(_db, {
      'courseId': courseId,
      'score': score,
      'date': date.toIso8601String(),
    });
  }

  Future<List<QuizScore>> getQuizScores(String courseId) async {
    final finder = Finder(filter: Filter.equals('courseId', courseId));
    final snapshots = await _quizScoresStore.find(_db, finder: finder);
    return snapshots.map((snapshot) {
      return QuizScore(
        score: snapshot.value['score'] as int,
        date: DateTime.parse(snapshot.value['date'] as String),
      );
    }).toList();
  }

  Stream<List<QuizScore>> getQuizScoresStream(String courseId) {
    final finder = Finder(filter: Filter.equals('courseId', courseId));
    return _quizScoresStore
        .query(finder: finder)
        .onSnapshots(_db)
        .map((snapshots) {
      return snapshots.map((snapshot) {
        return QuizScore(
          score: snapshot.value['score'] as int,
          date: DateTime.parse(snapshot.value['date'] as String),
        );
      }).toList();
    });
  }
}

class QuizScore {
  final int score;
  final DateTime date;

  QuizScore({required this.score, required this.date});
}