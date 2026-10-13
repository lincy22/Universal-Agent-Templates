# Flutter Clean Architecture & Repository Pattern Skill

## Overview
Architectural standards, directory structure, dependency rules, and implementation patterns for building scalable, testable Flutter applications using **Feature-First Clean Architecture**.

---

## Directory & Folder Structure

Structure applications by **Feature-First**, isolating **Domain**, **Data**, and **Presentation** within each feature:

```text
lib/
├── core/
│   ├── errors/
│   │   ├── exceptions.dart          # Low-level data source exceptions
│   │   └── failures.dart            # Domain-level failure representations
│   ├── usecase/
│   │   └── usecase.dart             # Base UseCase contract
│   ├── utils/
│   │   └── result.dart              # Functional Result / Either pattern
│   └── network/
├── features/
│   └── <feature_name>/
│       ├── domain/                  # PURE BUSINESS LOGIC (No Flutter dependencies)
│       │   ├── entities/            # Core business objects
│       │   ├── repositories/        # Repository interfaces / contracts
│       │   └── usecases/            # Single-responsibility business actions
│       ├── data/                    # DATA ACCESS & PERSISTENCE
│       │   ├── datasources/         # Remote (API) & Local (DB/Cache) data sources
│       │   ├── models/              # DTOs with JSON serialization & entity mappers
│       │   └── repositories/        # Implementations of domain repository contracts
│       └── presentation/            # USER INTERFACE & STATE
│           ├── controllers/         # BLoC, Cubit, Riverpod Notifier, or ChangeNotifier
│           ├── screens/             # Top-level route pages
│           └── widgets/             # Reusable UI subcomponents
└── main.dart
```

---

## Core Rules & Principles

### 1. The Dependency Inversion Rule
- Dependencies point **inward** toward the **Domain** layer.
- **Domain Layer is Pure Dart:** It must never import Flutter UI packages (`flutter/material.dart`) or serialization libraries (`json_serializable`, `dio`).
- **Data** and **Presentation** depend on **Domain**, never on each other directly.

### 2. Entities vs. Models (DTOs)
- **Entity (`domain/entities`):** Immutable business object. Contains business logic, getters, and equality definitions. Does not know about JSON, APIs, or database formats.
- **Model (`data/models`):** Extends or converts to an Entity. Contains `fromJson`, `toJson`, and maps data transfer objects (DTOs) from APIs or databases into domain entities.

### 3. Repository Contract vs. Implementation
- **Repository Interface:** Declared in `domain/repositories/` (e.g., `abstract class UserRepository`).
- **Repository Implementation:** Resides in `data/repositories/` (e.g., `UserRepositoryImpl implements UserRepository`). It orchestrates remote and local data sources, catches low-level exceptions, and returns domain-safe results.

### 4. Explicit Result / Either Error Handling
- Never throw unhandled exceptions across layer boundaries into the UI.
- Repositories should return a typed `Result<T>` or `Either<Failure, T>` so that failures are explicit compile-time contracts.

### 5. Single-Responsibility Use Cases
- Each Use Case represents one specific user action or business workflow (e.g., `GetUserProfileUseCase`, `UpdatePasswordUseCase`).
- Implement a callable method: `Future<Result<T>> call(Params params)`.

---

## Reference Implementation

### 1. Result & Failure Types
```dart
// core/utils/result.dart
sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(String message, [Exception? exception]) = FailureResult<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class FailureResult<T> extends Result<T> {
  final String message;
  final Exception? exception;
  const FailureResult(this.message, [this.exception]);
}
```

### 2. Domain Layer: Entity & Repository Contract
```dart
// features/auth/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String email;
  final String name;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
  });
}
```

```dart
// features/auth/domain/repositories/auth_repository.dart
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });
  Future<Result<void>> logout();
}
```

### 3. Domain Layer: Use Case
```dart
// features/auth/domain/usecases/login_usecase.dart
import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;
  const LoginParams({required this.email, required this.password});
}

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<Result<UserEntity>> call(LoginParams params) async {
    if (params.email.trim().isEmpty || !params.email.contains('@')) {
      return Result.failure('Invalid email format provided.');
    }
    if (params.password.length < 6) {
      return Result.failure('Password must be at least 6 characters.');
    }
    return repository.login(email: params.email, password: params.password);
  }
}
```

### 4. Data Layer: Model (DTO)
```dart
// features/auth/data/models/user_model.dart
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }
}
```

### 5. Data Layer: Repository Implementation
```dart
// features/auth/data/repositories/auth_repository_impl.dart
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(email: email, password: password);
      return Result.success(userModel);
    } catch (e) {
      return Result.failure('Authentication failed: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Failed to logout cleanly.');
    }
  }
}
```
