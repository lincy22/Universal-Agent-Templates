# Flutter Local Storage & Caching Skill

## Overview
Architectural standards, directory structure, security tiers, and implementation guidelines for client-side persistence and caching in Flutter applications.

---

## Directory & Folder Structure

Organize storage utilities centrally under `core/storage`:

```text
lib/
├── core/
│   ├── storage/
│   │   ├── secure_storage_service.dart # Encrypted credentials & tokens (flutter_secure_storage)
│   │   ├── preferences_service.dart    # App settings & flags (shared_preferences)
│   │   ├── cache_service.dart          # Offline entity cache (Hive / Drift / Isar)
│   │   └── storage_keys.dart           # Constant key strings
├── features/
│   ├── auth/
│   │   └── data/repositories/auth_repository_impl.dart
│   └── settings/
│       └── data/repositories/settings_repository_impl.dart
└── main.dart
```

---

## Core Rules & Principles

### 1. Multi-Tier Storage Strategy
Use the appropriate storage mechanism for the specific data type:
- **Tier 1 — Sensitive Data (`flutter_secure_storage`):**
  - Store JWT access tokens, refresh tokens, biometric state, and API encryption keys.
  - Configured with `AndroidOptions(encryptedSharedPreferences: true)` and iOS Keychain accessibility flags.
- **Tier 2 — Lightweight Preferences (`shared_preferences`):**
  - Store non-sensitive primitive flags (e.g. `isDarkMode`, `locale`, `hasSeenOnboarding`, `lastSyncTimestamp`).
  - **Never** store passwords, PINs, or auth tokens in `shared_preferences`.
- **Tier 3 — Structured Offline Cache (`Hive` / `Isar` / `Drift`):**
  - Store lists, articles, product catalogs, and draft forms for offline access.

### 2. Interface Abstraction for Testability
- Always abstract storage services behind Dart interfaces (`abstract class`).
- Repositories must depend on storage interfaces, never concrete package classes directly, enabling effortless mocking in unit tests.

### 3. Key Centralization
- Centralize all preference and storage keys in a dedicated constants file (`storage_keys.dart`). Never use arbitrary inline string keys scattered across the codebase.

### 4. Asynchronous Startup & Cache Invalidation
- Initialize necessary persistent stores before `runApp()` if immediate synchronous state is required at startup.
- Always implement cache invalidation policies (TTL or version checking) to prevent stale or corrupted data schemas after app updates.

---

## Reference Implementation

### 1. Centralized Storage Keys
```dart
// core/storage/storage_keys.dart
abstract class StorageKeys {
  static const String accessToken = 'secure_access_token';
  static const String refreshToken = 'secure_refresh_token';
  static const String userId = 'secure_user_id';
  static const String themeMode = 'pref_theme_mode';
  static const String onboardingSeen = 'pref_onboarding_seen';
  static const String languageCode = 'pref_language_code';
}
```

### 2. Secure Storage Service (Tier 1)
```dart
// core/storage/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_keys.dart';

abstract class ISecureStorageService {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens({required String accessToken, required String refreshToken});
  Future<void> clearAll();
}

class SecureStorageService implements ISecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  @override
  Future<String?> getAccessToken() async {
    return _storage.read(key: StorageKeys.accessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _storage.read(key: StorageKeys.refreshToken);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: StorageKeys.accessToken, value: accessToken),
      _storage.write(key: StorageKeys.refreshToken, value: refreshToken),
    ]);
  }

  @override
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
```

### 3. Preferences Service (Tier 2)
```dart
// core/storage/preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_keys.dart';

abstract class IPreferencesService {
  bool get hasSeenOnboarding;
  Future<void> setHasSeenOnboarding(bool value);
  String? get themeMode;
  Future<void> setThemeMode(String mode);
  Future<void> clearAll();
}

class PreferencesService implements IPreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  @override
  bool get hasSeenOnboarding => _prefs.getBool(StorageKeys.onboardingSeen) ?? false;

  @override
  Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs.setBool(StorageKeys.onboardingSeen, value);
  }

  @override
  String? get themeMode => _prefs.getString(StorageKeys.themeMode);

  @override
  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(StorageKeys.themeMode, mode);
  }

  @override
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
```

### 4. Startup Initialization in main.dart
```dart
// main.dart
import 'package:flutter/material.dart';
import 'core/storage/preferences_service.dart';
import 'core/storage/secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage dependencies
  final secureStorage = SecureStorageService();
  final preferencesService = await PreferencesService.init();

  runApp(MyApp(
    secureStorage: secureStorage,
    preferencesService: preferencesService,
  ));
}

class MyApp extends StatelessWidget {
  final ISecureStorageService secureStorage;
  final IPreferencesService preferencesService;

  const MyApp({
    super.key,
    required this.secureStorage,
    required this.preferencesService,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Storage Configured')),
      ),
    );
  }
}
```
