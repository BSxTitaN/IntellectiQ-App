import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';

class ApiKeyProvider with ChangeNotifier {
  static const String _apiKeyStore = 'api_key';
  static const String _apiKeyField = 'key';

  final Database _db;
  final StoreRef _store = StoreRef(_apiKeyStore);

  String _apiKey = '';

  ApiKeyProvider(this._db) {
    _loadApiKey();
  }

  String get apiKey => _apiKey;

  Future<void> setApiKey(String value) async {
    _apiKey = value;
    await _store.record(_apiKeyField).put(_db, value);
    notifyListeners();
  }

  Future<void> _loadApiKey() async {
    final storedKey = await _store.record(_apiKeyField).get(_db) as String?;
    if (storedKey != null) {
      _apiKey = storedKey;
      notifyListeners();
    }
  }
}