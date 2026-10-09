# Flutter / Dart AI Agent Rules & Guidelines

## Core Principles
1. **Clean Architecture:** Use Feature-First folder organization (`features/feature_name/presentation`, `domain`, `data`).
2. **Immutability:** Mark all Widget classes as `const` where possible. Prefer `freezed` or immutable data classes for models.
3. **State Management:** Enforce single state management strategy (e.g. Bloc, Riverpod, or Provider). Do not mix multiple frameworks.
4. **Error Handling:** Use explicit Result/Either types or domain exceptions. Never silently ignore errors or leave empty `catch` blocks.

## Directory Structure
```text
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── network/
├── features/
│   └── feature_name/
│       ├── data/
│       ├── domain/
│       └── presentation/
│           ├── controllers/
│           ├── screens/
│           └── widgets/
└── main.dart
```

## Security Guardrails
- Never store plain API keys or secrets in Dart files. Use `flutter_dotenv` or `--dart-define`.
- Validate user inputs in form controllers before invoking domain logic.
