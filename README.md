# ProjectLocale SDK

iOS SDK for [Project Locale](https://p-locale.eu) — over-the-air localization updates without App Store releases.

## Installation

### Swift Package Manager

Add this package to your Xcode project:

1. **File → Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/biometricid/p-locale.eu
   ```
3. Select **Up to Next Major Version**
4. Click **Add Package**

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/biometricid/p-locale.eu", from: "1.0.0")
]
```

## Quick Start

```swift
import ProjectLocale

// Configure once at app launch
try L10n.configure(
    apiKey: "pl_...",
    serverURL: URL(string: "https://p-locale.eu")!,
    realtimeEnabled: true
)

// Fetch translations
let synced = try await L10n.syncAll()

// Use in SwiftUI
L10nText("welcome_title", default: "Welcome")

// Use programmatically
let title = L10n.string("welcome_title", default: "Welcome")
```

## Features

- **Over-the-air translations** — update strings without App Store releases
- **Offline-first** — cached translations work without network
- **Real-time updates** — WebSocket push for instant translation delivery
- **Combine integration** — `L10n.observer` (`ObservableObject`) for reactive SwiftUI updates
- **Multi-environment** — dev, qa, prod with per-version language control

## Requirements

- iOS 15.0+
- macOS 13.0+
- Swift 5.9+

## Documentation

Full API reference: [p-locale.eu/docs](https://p-locale.eu/docs/)
