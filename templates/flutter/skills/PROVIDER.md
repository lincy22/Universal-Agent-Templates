# Flutter Provider State Management Skill

## Overview
Architectural standards, directory structure, best practices, and implementation guidelines for Flutter applications utilizing the Provider package (`provider`).

---

## Directory & Folder Structure

Follow a **Feature-First** organization:

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
│           ├── providers/
│           │   ├── <feature>_provider.dart    # ChangeNotifier business logic
│           │   └── <feature>_state.dart       # State model / status definitions
│           ├── screens/
│           │   └── <feature>_screen.dart
│           └── widgets/
│               └── <feature>_item_widget.dart
└── main.dart
```

---

## Core Rules & Principles

### 1. ChangeNotifier Best Practices
- Keep `notifyListeners()` intentional. Do not call it if no state values actually changed.
- Avoid calling `notifyListeners()` repeatedly in rapid succession within the same method; batch updates before notifying.
- Check `hasListeners` or a `_disposed` flag if awaiting asynchronous operations to prevent notifying after widget unmount.

### 2. Context Access Rules
- **`context.watch<T>()`**: Use inside `build()` when the widget depends on the state and must rebuild whenever it changes.
- **`context.read<T>()`**: Use inside user interaction callbacks (`onPressed`, `onTap`, etc.) to invoke controller methods. **Never** call `context.read<T>()` directly in the `build()` body.
- **`context.select<T, R>((p) => p.property)`**: Use to subscribe and rebuild only when a specific slice of the state changes.

### 3. Granular UI Rebuilding with Consumer & Selector
- Avoid wrapping the entire top-level screen with `Consumer<T>`. Wrap only the specific child widgets that depend on changing values.
- Use `Selector<T, S>` when you want to rebuild a widget only when a selected sub-field changes, ignoring other provider updates.

### 4. Lifecycle & Disposal
- When creating providers scoped to a route using `ChangeNotifierProvider(create: (_) => ...)`, Provider automatically calls `dispose()` when navigating away.
- When passing an already existing instance, use `ChangeNotifierProvider.value(value: ...)` to avoid premature disposal.
- Always cancel timers, stream subscriptions, and text controllers inside `dispose()`.

---

## Reference Implementation

### 1. ChangeNotifier Provider
```dart
// presentation/providers/counter_provider.dart
import 'package:flutter/foundation.dart';

enum CounterStatus { initial, loading, success, failure }

class CounterProvider extends ChangeNotifier {
  int _count = 0;
  CounterStatus _status = CounterStatus.initial;
  String? _errorMessage;

  int get count => _count;
  CounterStatus get status => _status;
  String? get errorMessage => _errorMessage;

  void increment() {
    _count++;
    _status = CounterStatus.success;
    notifyListeners();
  }

  void decrement() {
    _count--;
    _status = CounterStatus.success;
    notifyListeners();
  }

  Future<void> resetAsync() async {
    _status = CounterStatus.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _count = 0;
      _status = CounterStatus.success;
    } catch (e) {
      _status = CounterStatus.failure;
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
```

### 2. Presentation View
```dart
// presentation/screens/counter_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/counter_provider.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterProvider(),
      child: const _CounterView(),
    );
  }
}

class _CounterView extends StatelessWidget {
  const _CounterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider Counter')),
      body: Center(
        child: Consumer<CounterProvider>(
          builder: (context, provider, child) {
            if (provider.status == CounterStatus.loading) {
              return const CircularProgressIndicator();
            }
            return Text(
              'Count: ${provider.count}',
              style: Theme.of(context).textTheme.headlineMedium,
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'dec',
            onPressed: () => context.read<CounterProvider>().decrement(),
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            heroTag: 'inc',
            onPressed: () => context.read<CounterProvider>().increment(),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
```
