# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run app
flutter run

# Run on specific device
flutter run -d <device-id>
flutter devices  # list available devices

# Build
flutter build apk          # Android
flutter build ios          # iOS
flutter build macos        # macOS

# Test
flutter test                          # all tests
flutter test test/path/to/test.dart   # single test file
flutter test --name "test name"       # single test by name

# Lint & analyze
flutter analyze
dart fix --apply

# Dependencies
flutter pub get
flutter pub add <package>
flutter pub upgrade
```

## Architecture

Flutter app — not yet scaffolded. Run `flutter create .` to initialize in this directory (Apache 2.0 licensed).

Once scaffolded, expected structure:
- `lib/` — Dart source code, `main.dart` is entry point
- `lib/models/` — data models
- `lib/screens/` or `lib/pages/` — UI screens
- `lib/widgets/` — reusable widgets
- `lib/services/` — business logic, data access
- `test/` — unit and widget tests
- `integration_test/` — integration tests

## Flutter conventions

- Use `StatelessWidget` by default; reach for `StatefulWidget` only when local mutable state is needed.
- Prefer composition over inheritance for widgets.
- State management: choose one pattern (Provider, Riverpod, Bloc, etc.) and apply consistently.
- Dart null safety is on — avoid `!` force-unwrap; handle nulls explicitly.
