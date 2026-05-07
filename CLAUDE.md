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

## App Overview

Google Keep-inspired notes app. Users create notes (text, image, PDF, voice), view them as list or grid of cards, pin notes, and color-code cards. Notes sync across devices.

## Storage Architecture

- **Cloud Firestore** — note metadata (title, body, type, color, isPinned, timestamps). Offline-first: SDK caches locally, syncs when online.
- **Firebase Storage** — binary blobs: images, PDFs, voice recordings. Store download URL in Firestore doc.
- **Firebase Auth** — user identity; Firestore rules scope notes per `userId`.

### Note data model

```dart
// Firestore collection: users/{userId}/notes/{noteId}
{
  id: String,
  userId: String,
  type: 'text' | 'image' | 'pdf' | 'voice',
  title: String?,
  body: String?,        // text notes only
  fileUrl: String?,     // Firebase Storage download URL
  color: int?,          // card background color (ARGB)
  isPinned: bool,
  createdAt: Timestamp,
  updatedAt: Timestamp,
}
```

## Architecture

Project scaffolded. Structure:
- `lib/` — Dart source, `main.dart` entry point
- `lib/models/` — data models
- `lib/screens/` — UI screens
- `lib/widgets/` — reusable widgets
- `lib/services/` — business logic, data access (Firestore, Storage, Auth)
- `lib/providers/` — Riverpod providers
- `test/` — unit and widget tests
- `integration_test/` — integration tests

## Tech Stack

- **Riverpod** — state management (already configured)
- **go_router** — declarative routing (already configured)
- **Firebase Auth** — authentication
- **Cloud Firestore** — note metadata + offline sync
- **Firebase Storage** — binary note files

## Flutter conventions

- Use `StatelessWidget` by default; reach for `StatefulWidget` only when local mutable state is needed.
- Prefer composition over inheritance for widgets.
- State management: Riverpod — apply consistently throughout.
- Dart null safety is on — avoid `!` force-unwrap; handle nulls explicitly.
