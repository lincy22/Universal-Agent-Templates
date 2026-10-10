# Flutter Color System & Theming Skill

## Overview
Guidelines and best practices for managing colors, light/dark themes, accessibility, and dynamic styling in Flutter applications.

---

## Color Rules & Principles

### 1. Centralized Color Palette
- Define all application colors centrally in `lib/core/theme/app_colors.dart` (or `lib/core/theme/app_palette.dart`).
- **Never hardcode raw hex values** (e.g. `Color(0xFF1E1E2C)`) directly inside UI Widgets or screens.

### 2. Contextual Theme & ColorScheme Usage
- Access colors dynamically using `Theme.of(context).colorScheme`.
- Standardize on official `ColorScheme` tokens (`primary`, `secondary`, `surface`, `error`, `onPrimary`, `onSurface`, etc.).
- Maintain consistent semantic feedback colors: `success`, `warning`, `error`, and `info`.

### 3. Light & Dark Theme Support
- Always define paired `ColorScheme.light()` and `ColorScheme.dark()` palettes.
- Ensure text and element contrast ratios satisfy **WCAG AA** standards (minimum 4.5:1 contrast ratio for normal text).

### 4. Custom Theme Extensions
- For brand or domain-specific colors not available in standard `ColorScheme`, implement Flutter's `ThemeExtension<T>`.

---

## Reference Implementation

```dart
// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primaryLight = Color(0xFF6200EE);
  static const Color primaryDark = Color(0xFFBB86FC);
  
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF0055);
  static const Color error = Color(0xFFB00020);
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      error: AppColors.error,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      error: AppColors.error,
    ),
  );
}
```
