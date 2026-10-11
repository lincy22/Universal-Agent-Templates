# Flutter BLoC State Management Skill

## Overview
Architectural standards, directory structure, best practices, and implementation guidelines for Flutter applications utilizing the BLoC (Business Logic Component) pattern with `flutter_bloc`.

---

## Directory & Folder Structure

Follow a **Feature-First + Clean Architecture** organization:

```text
lib/
├── core/
│   ├── bloc/
│   │   └── app_bloc_observer.dart       # Global lifecycle & error observer
│   ├── errors/
│   │   └── failures.dart
│   ├── network/
│   └── theme/
├── features/
│   └── <feature_name>/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           │   ├── <feature>_bloc.dart    # Logic & event handling
│           │   ├── <feature>_event.dart   # Input events
│           │   └── <feature>_state.dart   # Output immutable states
│           ├── screens/
│           │   └── <feature>_screen.dart
│           └── widgets/
│               └── <feature>_widget.dart
└── main.dart
```

---

## Core Rules & Principles

### 1. Cubit vs. BLoC
- **Use Cubit** for straightforward state changes (e.g., toggle switches, simple counter, theme switcher) where actions map directly to functions.
- **Use BLoC** for complex event-driven logic, concurrency needs (e.g., debounce, throttle with `rxdart` or `bloc_concurrency`), or when tracking audit logs of distinct user events.

### 2. State & Event Immutability
- Always extend `Equatable` (or use `@freezed`) for all Events and States.
- Never mutate state objects in place; always emit new copies using `.copyWith()`.

### 3. Widget Selection Guidelines
- **`BlocBuilder`**: Strictly for rebuilding UI elements. Must be a pure function with **no side effects**.
- **`BlocListener`**: Used exclusively for one-time side effects (navigation, SnackBars, dialogs). Does not rebuild UI.
- **`BlocConsumer`**: Used when both UI rebuilding and side effects are needed for the same state.
- **`BlocSelector`**: Filter and rebuild only when a specific sub-property changes to optimize rendering performance.

### 4. Scoping & Dependency Injection
- Scope BLoCs locally to the route or widget subtree requiring them using `BlocProvider(create: (context) => ...)`.
- Only place `MultiBlocProvider` at the root of `MaterialApp` for global application-level states (e.g., `AuthBloc`, `ThemeBloc`, `LocaleBloc`).
- Never instantiate a BLoC directly inside a `build()` method.

### 5. Global Observer
- Always configure an `AppBlocObserver` in `main.dart` to monitor transitions, events, and uncaught exceptions.

---

## Reference Implementation

### 1. Events & States
```dart
// presentation/bloc/counter_event.dart
import 'package:equatable/equatable.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object?> get props => [];
}

class CounterIncrementPressed extends CounterEvent {}
class CounterDecrementPressed extends CounterEvent {}
```

```dart
// presentation/bloc/counter_state.dart
import 'package:equatable/equatable.dart';

enum CounterStatus { initial, loading, success, failure }

class CounterState extends Equatable {
  final int count;
  final CounterStatus status;
  final String? errorMessage;

  const CounterState({
    this.count = 0,
    this.status = CounterStatus.initial,
    this.errorMessage,
  });

  CounterState copyWith({
    int? count,
    CounterStatus? status,
    String? errorMessage,
  }) {
    return CounterState(
      count: count ?? this.count,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [count, status, errorMessage];
}
```

### 2. BLoC Implementation
```dart
// presentation/bloc/counter_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState()) {
    on<CounterIncrementPressed>(_onIncrement);
    on<CounterDecrementPressed>(_onDecrement);
  }

  void _onIncrement(CounterIncrementPressed event, Emitter<CounterState> emit) {
    emit(state.copyWith(
      count: state.count + 1,
      status: CounterStatus.success,
    ));
  }

  void _onDecrement(CounterDecrementPressed event, Emitter<CounterState> emit) {
    emit(state.copyWith(
      count: state.count - 1,
      status: CounterStatus.success,
    ));
  }
}
```

### 3. Presentation View
```dart
// presentation/screens/counter_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/counter_bloc.dart';
import '../bloc/counter_event.dart';
import '../bloc/counter_state.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: const _CounterView(),
    );
  }
}

class _CounterView extends StatelessWidget {
  const _CounterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLoC Counter')),
      body: BlocConsumer<CounterBloc, CounterState>(
        listener: (context, state) {
          if (state.status == CounterStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error occurred')),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Text(
              'Count: ${state.count}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterBloc>().add(CounterDecrementPressed()),
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () => context.read<CounterBloc>().add(CounterIncrementPressed()),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
```
