# SceneColor

A camera-based iOS color extraction app with real-time blob tracking and playful interactions.

## Features

- 🎨 Real-time color extraction (5 dominant colors)
- 👁️ Live blob tracking showing where colors appear
- 💾 Liquid sidebar drag-to-save interaction
- 📅 Day-based timeline with month filters
- 🏷️ Color names + hex codes
- ⚡ Playful micro-animations throughout

## Requirements

- iOS 16.0+
- Xcode 14.0+
- iPhone with camera

## Getting Started

1. Open `SceneColor.xcodeproj` in Xcode
2. Select a development team in project settings
3. Build and run on a physical device (camera required)

## Architecture

See `BUILD_SPEC.md` for complete technical specification.

## Project Structure

```
SceneColor/
├── Models/          # Data models (Scene, Freeze, ColorInfo)
├── ViewModels/      # View models for business logic
├── Views/           # SwiftUI views
│   └── Components/  # Reusable UI components
├── Utils/           # Color extraction, blob tracking
└── Storage/         # Persistence layer
```

## Build Status

🚧 In Development
