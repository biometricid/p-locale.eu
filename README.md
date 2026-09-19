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
3. Select **Up to Next Major Version** (1.1.0)
4. Click **Add Package**

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/biometricid/p-locale.eu", from: "1.1.0")
]
```

Then add the dependency to your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "ProjectLocale", package: "p-locale.eu")
    ]
)
```

### Manual Installation

Download [ProjectLocale.xcframework.zip](https://p-locale.eu/media/sdk/ProjectLocale.xcframework.zip), unzip, and drag it into your Xcode project.

## Quick Start

```swift
import ProjectLocale

// Configure once at app launch
try L10n.configure(
    apiKey: "pl_...",
    serverURL: URL(string: "https://your-server.com")!,
    realtimeEnabled: true
)

// Fetch all translations
let synced = try await L10n.syncAll()

// Use in SwiftUI
L10nText("welcome_title", default: "Welcome")

// Use programmatically
let title = L10n.string("welcome_title", default: "Welcome")
```

## Configuration

| Parameter | Default | Description |
|---|---|---|
| `apiKey` | required | Project API key from the dashboard (`pl_...`) |
| `serverURL` | required | Your Project Locale server URL |
| `environment` | `"prod"` | Target environment (dev, qa, prod) |
| `appVersion` | from Info.plist | App version for per-version translations |
| `fallbackBundle` | `.main` | Bundle containing fallback `.strings` files |
| `logLevel` | `.warning` | Logging verbosity: `.debug`, `.info`, `.warning`, `.error` |
| `realtimeEnabled` | `false` | Enable WebSocket for real-time translation updates |

## API Reference

### Translation

```swift
// Single string lookup
L10n.string("namespace/key", default: "Fallback")

// SwiftUI view with auto-refresh
L10nText("namespace/key", default: "Fallback")

// Current language
L10n.currentLanguage  // "en", "uk", "de", ...

// Switch language
L10n.setLanguage("uk")

// Available cached languages
L10n.availableLanguages  // ["en", "uk", "de"]
```

### Sync

```swift
// Sync all languages (recommended on first launch)
let synced = try await L10n.syncAll()  // ["de", "en", "uk"]

// Sync single language
let updated = try await L10n.checkForUpdate(locale: "uk")

// Project metadata
let info = try await L10n.projectInfo()
// info.name, info.sourceLanguage, info.languages, info.environments

// Check if cached translations exist (from previous session)
L10n.hasCachedTranslations  // true/false

// Revision snapshot for debugging
L10n.revisionSnapshot()  // ["en": (appVersion: "1.2.0", revision: 5), ...]
```

### Reactivity (Combine)

The SDK exposes `L10n.observer` — an `ObservableObject` with a `@Published revision` counter. It increments on every translation change (sync, language switch, or real-time WebSocket push).

```swift
struct MyView: View {
    @ObservedObject private var observer = L10n.observer

    var body: some View {
        let _ = observer.revision
        Text(L10n.string("greeting", default: "Hello"))
    }
}
```

UIKit apps can subscribe via Combine:

```swift
L10n.observer.$revision
    .sink { _ in self.updateLabels() }
    .store(in: &cancellables)
```

### Real-Time Updates (WebSocket)

When `realtimeEnabled: true`, the SDK opens a WebSocket connection to the server. Translation changes made in the web UI are pushed to the device instantly.

- Auto-reconnect with exponential backoff (3s → 30s max)
- Language additions/removals trigger automatic re-sync
- Updates flow through the same `L10n.observer` pipeline

### Offline Behavior

- On first launch, the SDK fetches all translations and caches them locally
- On subsequent launches, delta sync downloads only changed keys
- If the server is unreachable, cached translations are used automatically
- `L10n.hasCachedTranslations` tells you if a cache exists from a previous session

## Features

- **Over-the-air translations** — update strings without App Store releases
- **Offline-first** — cached translations work without network
- **Delta sync** — only changed keys are downloaded after first sync
- **Real-time updates** — WebSocket push for instant translation delivery
- **Combine integration** — `L10n.observer` for reactive SwiftUI/UIKit updates
- **Multi-environment** — dev, qa, prod with per-version language control
- **Lightweight** — static library, no external dependencies

## Requirements

- iOS 15.0+
- macOS 13.0+
- Swift 5.9+

## Sample App

A complete sample app demonstrating all SDK features is available at [github.com/biometricid/p-locale.eu-](https://github.com/biometricid/p-locale.eu-)

## Documentation

Full platform documentation: [p-locale.eu/docs](https://p-locale.eu/docs/)

## License

See [LICENSE](LICENSE) for details.
