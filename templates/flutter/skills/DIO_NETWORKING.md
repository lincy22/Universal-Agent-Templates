# Flutter Dio Networking & HTTP Client Skill

## Overview
Architectural standards, directory structure, interceptor management, error handling, and implementation guidelines for Flutter applications utilizing `dio`.

---

## Directory & Folder Structure

Follow a centralized networking pattern under `core/network`:

```text
lib/
├── core/
│   ├── errors/
│   │   ├── exceptions.dart          # Network & Server Exception definitions
│   │   └── failures.dart            # Domain-level failure representations
│   └── network/
│       ├── api_client.dart          # Configured Dio wrapper / client
│       ├── api_endpoints.dart       # API URL constants and paths
│       ├── network_info.dart        # Connectivity check service
│       └── interceptors/
│           ├── auth_interceptor.dart    # Token injection & 401 refresh queue
│           └── logging_interceptor.dart # Sanitized console logger (Debug only)
├── features/
│   └── <feature_name>/
│       └── data/
│           └── datasources/
│               └── <feature>_remote_data_source.dart
└── main.dart
```

---

## Core Rules & Principles

### 1. Centralized Dio Configuration & Timeouts
- Never instantiate `Dio()` directly inside repositories or data sources.
- Set explicit timeouts (`connectTimeout`, `receiveTimeout`, `sendTimeout`) on `BaseOptions` to prevent indefinite hangs.
- Define a single base URL and standard headers (`Content-Type: application/json`, `Accept: application/json`).

### 2. Queued Auth Interceptor & Token Refresh
- Inject the Bearer token dynamically into request headers using an `Interceptor`.
- Handle `401 Unauthorized` responses with a `QueuedInterceptor` to lock pending requests while asynchronously fetching a new token via refresh token endpoint, and replay failed requests cleanly.
- Never run an infinite refresh loop; if the refresh token fails, trigger a global logout event.

### 3. Sanitized Logging
- Add `LogInterceptor` only when `kDebugMode` is true.
- Never print sensitive credentials, raw passwords, or authorization headers into production logs.

### 4. Strict Exception to Failure Mapping
- Catch `DioException` exclusively at the data source layer and translate into concrete domain exceptions or failures (`NetworkException`, `ServerException`, `UnauthorizedException`).
- Never leak raw `DioException` objects to the presentation layer or UI controllers.

### 5. Cancellation Tokens
- Provide `CancelToken` support for long-running downloads, file uploads, or search queries that may be discarded when the user leaves the screen or types a new query.

---

## Reference Implementation

### 1. Exception Definitions
```dart
// core/errors/exceptions.dart
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = 'Session expired. Please log in again.']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection available.']);
}
```

### 2. Auth Interceptor with Token Refresh
```dart
// core/network/interceptors/auth_interceptor.dart
import 'package:dio/dio.dart';

abstract class TokenStorage {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens({required String accessToken, required String refreshToken});
  Future<void> clearTokens();
}

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final TokenStorage tokenStorage;
  final void Function() onSessionExpired;

  AuthInterceptor({
    required this.dio,
    required this.tokenStorage,
    required this.onSessionExpired,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        onSessionExpired();
        return handler.reject(err);
      }

      try {
        // Create an isolated Dio instance to avoid interceptor recursion
        final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
        final response = await refreshDio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['accessToken'] as String;
        final newRefreshToken = response.data['refreshToken'] as String;

        await tokenStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        // Retry original request with new token
        final requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        
        final retryResponse = await dio.fetch(requestOptions);
        return handler.resolve(retryResponse);
      } catch (refreshError) {
        await tokenStorage.clearTokens();
        onSessionExpired();
        return handler.reject(err);
      }
    }

    handler.next(err);
  }
}
```

### 3. API Client Wrapper
```dart
// core/network/api_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../errors/exceptions.dart';
import 'interceptors/auth_interceptor.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({
    required String baseUrl,
    required TokenStorage tokenStorage,
    required VoidCallback onSessionExpired,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(
      AuthInterceptor(
        dio: _dio,
        tokenStorage: tokenStorage,
        onSessionExpired: onSessionExpired,
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
        ),
      );
    }
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException('Connection timed out. Please check your network.');
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Unexpected server error';
        if (status == 401) {
          return const UnauthorizedException();
        }
        return ServerException(message: message.toString(), statusCode: status);
      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled.');
      case DioExceptionType.unknown:
      default:
        return const NetworkException('An unexpected network error occurred.');
    }
  }
}
```
