# Flutter Riverpod State Management Skill

## Overview
Architectural standards, directory structure, best practices, and implementation guidelines for Flutter applications utilizing Riverpod 2.x (`flutter_riverpod`) using `Notifier` and `AsyncNotifier`.

---

## Directory & Folder Structure

Follow a **Feature-First + Clean Architecture** organization:

```text
lib/
├── core/
│   ├── errors/
│   │   └── failures.dart
│   ├── network/
│   ├── theme/
│   └── utils/
├── features/
│   └── <feature_name>/
│       ├── data/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   └── entities/
│       └── presentation/
│           ├── controllers/
│           │   ├── <feature>_controller.dart    # Notifier / AsyncNotifier
│           │   └── <feature>_state.dart         # State models / Equatable
│           ├── screens/
│           │   └── <feature>_screen.dart
│           └── widgets/
│               └── <feature>_item_widget.dart
└── main.dart
```

---

## Core Rules & Principles

### 1. Modern Riverpod 2.x Paradigm
- Prefer **`Notifier`** for synchronous state and **`AsyncNotifier`** for asynchronous data logic.
- Avoid legacy `StateNotifierProvider` and `ChangeNotifierProvider` in modern implementations.
- Wrap the entire application root inside `ProviderScope` in `main.dart`.

### 2. Reading & Watching State
- **`ref.watch(provider)`**: Use in `build()` to reactively rebuild widgets when state changes.
- **`ref.read(provider.notifier)`**: Use in event callbacks (e.g., `onPressed`) to trigger methods. **Never** call `ref.read` directly inside `build()`.
- **`ref.listen(provider, (previous, next) => ...)`**: Use inside `build()` for navigation, showing dialogs, or SnackBars without rebuilding the widget tree.

### 3. Handling Asynchronous State with `AsyncValue`
- Always use `AsyncValue<T>` when dealing with network calls or async data.
- Handle all UI branches declaratively with `.when()`:
  ```dart
  asyncState.when(
    data: (data) => DataWidget(data),
    loading: () => const CircularProgressIndicator(),
    error: (err, stack) => ErrorWidget(err),
  );
  ```
- Use `AsyncValue.guard(() => ...)` inside controller actions to automatically catch errors and update the state cleanly.

### 4. Modifiers & Memory Management
- **`autoDispose`**: Always apply `autoDispose` to screen/view-level controllers so state is garbage-collected when the screen is removed from the navigation stack.
- **`family`**: Use when a provider requires external parameters (e.g. fetching details by `id`).

---

## Reference Implementation

### 1. AsyncNotifier Controller
```dart
// presentation/controllers/counter_controller.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterControllerProvider =
    AsyncNotifierProvider.autoDispose<CounterController, int>(CounterController.new);

class CounterController extends AutoDisposeAsyncNotifier<int> {
  @override
  FutureOr<int> build() async {
    // Initial fetch or async initialization
    return 0;
  }

  Future<void> increment() async {
    final current = state.value ?? 0;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 200));
      return current + 1;
    });
  }

  Future<void> decrement() async {
    final current = state.value ?? 0;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 200));
      return current - 1;
    });
  }
}
```

### 2. Presentation View with ConsumerWidget
```dart
// presentation/screens/counter_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/counter_controller.dart';

class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for error side effects
    ref.listen<AsyncValue<int>>(counterControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${next.error}')),
        );
      }
    });

    final counterState = ref.watch(counterControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Counter')),
      body: Center(
        child: counterState.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text('Error: $error'),
          data: (count) => Text(
            'Count: $count',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'dec',
            onPressed: () => ref.read(counterControllerProvider.notifier).decrement(),
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            heroTag: 'inc',
            onPressed: () => ref.read(counterControllerProvider.notifier).increment(),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
```

### 3. Root Setup
```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/counter/presentation/screens/counter_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CounterScreen(),
    );
  }
}
```
