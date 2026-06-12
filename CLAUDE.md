# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

This project pins its Flutter SDK with **FVM** (`.fvmrc`, currently 3.41.6). Always prefix `flutter` and `dart` commands with `fvm` — bare `flutter`/`dart` may resolve to a stale global SDK. In shells without the `fvm` command (e.g. hooks), use the project symlink `.fvm/flutter_sdk/bin/flutter` / `.fvm/flutter_sdk/bin/dart` instead.

```bash
# Run app
fvm flutter run

# Run on specific device
fvm flutter run -d <device-id>
fvm flutter devices  # list available devices

# Build
fvm flutter build apk          # Android
fvm flutter build ios          # iOS
fvm flutter build macos        # macOS

# Test
fvm flutter test                          # all tests
fvm flutter test test/path/to/test.dart   # single test file
fvm flutter test --name "test name"       # single test by name

# Lint & analyze
fvm flutter analyze
fvm dart fix --apply

# Dependencies
fvm flutter pub get
fvm flutter pub add <package>  # then remove ^ from the version in pubspec.yaml — always pin exact versions
fvm flutter pub upgrade
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
  labelIds: List<String>,  // refs into the labels collection
  createdAt: Timestamp,
  updatedAt: Timestamp,
}
```

### Label data model

```dart
// Firestore collection: users/{userId}/labels/{labelId}
{
  id: String,
  name: String,  // max 30 chars (Label.maxNameLength)
}
```

Collection paths are centralized in `lib/data/firestore_paths.dart`.

## Architecture

Structure:
- `lib/main.dart` — entry point
- `lib/domain/` — models and repository interfaces
  - `models/` — `note.dart`, `note_type.dart`, `label.dart`, `app_user.dart`, typed exceptions (`note_exception.dart`, `label_exception.dart`, `auth_exception.dart`)
  - `repositories/` — `note_repository.dart`, `label_repository.dart`, `auth_repository.dart` (abstract interfaces)
- `lib/data/` — data layer
  - `repositories/` — Firebase implementations: `firebase_note_repository.dart`, `firebase_label_repository.dart`, `firebase_auth_repository.dart`
  - `dtos/` — Firestore mapping: `note_dto.dart`, `label_dto.dart`
  - `firestore_paths.dart` — centralized collection path constants
- `lib/presentation/` — UI layer
  - `screens/` — full screens (`home_screen.dart`, `auth/`, `note/`, `labels/`, `playground/`)
  - `widgets/` — reusable widgets
    - `common/` — app-wide: `AppIcon`, `AppButton`, `AppTextButton`
    - `auth/` — auth-specific widgets
    - `home/` — home screen widgets (`FabNotes`, `FabOptionItem`)
    - `notes/` — note card widget
    - `labels/` — label widgets (`LabelTag`, `LabelEditTile`, `LabelCreateField`)
  - `providers/` — Riverpod providers (`auth`, `labels`, `notes`, `theme`)
- `lib/shared/` — cross-cutting utilities
  - `extensions/` — `BuildContext`, `DateTime` extensions
  - `navigation/` — `go_router` setup (`router.dart`) and route definitions (`app_route.dart`)
  - `theme/` — `AppTheme`, `AppColors`, `AppDimensions`
- `lib/gen/` — generated localization files (do not edit)
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
- Declare fields before constructors in every Dart class.
- Always use the common widgets in `lib/presentation/widgets/common/` instead of Flutter primitives directly: `AppIcon` (not `Icon`), `AppButton.primary` / `AppButton.secondary` (not `FilledButton` / `OutlinedButton`), `AppTextButton` (not `TextButton`). Add new icons/variants there if needed.
