import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';

class ApiKeyProvider with ChangeNotifier {
  static const String _apiKeyStore = 'api_keys';
  static const String _openAiKeyField = 'openai_key';
  static const String _assemblyAiKeyField = 'assemblyai_key';

  final Database _db;
  final StoreRef _store = StoreRef(_apiKeyStore);

  String _openAiKey = '';
  String _assemblyAiKey = '';

  ApiKeyProvider(this._db) {
    _loadApiKeys();
  }

  String get openAiKey => _openAiKey;
  String get assemblyAiKey => _assemblyAiKey;

  Future<void> setOpenAiKey(String value) async {
    _openAiKey = value;
    await _store.record(_openAiKeyField).put(_db, value);
    notifyListeners();
  }

  Future<void> setAssemblyAiKey(String value) async {
    _assemblyAiKey = value;
    await _store.record(_assemblyAiKeyField).put(_db, value);
    notifyListeners();
  }

  Future<void> _loadApiKeys() async {
    final storedOpenAiKey = await _store.record(_openAiKeyField).get(_db) as String?;
    final storedAssemblyAiKey = await _store.record(_assemblyAiKeyField).get(_db) as String?;

    if (storedOpenAiKey != null) {
      _openAiKey = storedOpenAiKey;
    }
    if (storedAssemblyAiKey != null) {
      _assemblyAiKey = storedAssemblyAiKey;
    }

    notifyListeners();
  }
}