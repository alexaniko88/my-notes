# My Notes

A Google Keep-inspired notes app built with Flutter. Supports text, image, PDF, and voice notes. Notes display as a list or grid of cards and sync across devices via Firebase.

## Features

- Create notes as text, images, PDFs, or voice recordings
- View notes as list or grid of cards (Google Keep style)
- Pin notes to top
- Color-coded note cards
- Cross-device sync via Firestore (offline-first)
- User authentication via Firebase Auth

## Tech Stack

- **Flutter** — UI framework (iOS, Android, macOS)
- **Riverpod** — state management
- **Firebase Auth** — user identity
- **Cloud Firestore** — note metadata, offline cache + sync
- **Firebase Storage** — binary blobs (images, PDFs, voice files)
- **go_router** — declarative routing

## Data Model

```
Note {
  id: String
  userId: String
  type: 'text' | 'image' | 'pdf' | 'voice'
  title: String?
  body: String?         // text notes
  fileUrl: String?      // Storage download URL for binary notes
  color: int?           // card background color
  isPinned: bool
  createdAt: Timestamp
  updatedAt: Timestamp
}
```

## Getting Started

```bash
flutter pub get
flutter run
```

Requires Firebase project configured — add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS/macOS).
