import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localStorageServiceProvider = Provider<LocalStorageManager>((ref) {
  throw UnimplementedError();
});

class LocalStorageManager {
 static const _onboardingKey = 'onboarding_complete';

  final SharedPreferences _preferences;

  LocalStorageManager(this._preferences);

  bool get isOnboardingComplete =>
      _preferences.getBool(_onboardingKey) ?? false;

  Future<void> completeOnboarding() async {
    await _preferences.setBool(_onboardingKey, true);
  }

  Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  String? getString(String key) {
    return _preferences.getString(key);
  }

  Future<void> setInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  Future<void> clear() async {
    await _preferences.clear();
  }
}
