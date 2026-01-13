# SceneColor - Final Build Specification

**Native iOS color extraction app using only Apple UI Kit components.**

---

## Overview

Camera-based app that extracts dominant colors from the real world, displays them with blob overlays and color names, and organizes saved moments in a clean timeline.

**Design Philosophy:** Native iOS. Clean. Simple. Use standard Apple components everywhere.

---

## Core Features

1. **Live Scan** - Real-time camera with color extraction and blob tracking
2. **Freeze & Save** - Tap to freeze, swipe to save with haptic feedback
3. **Timeline** - Day-based list with month filters showing all saved palettes
4. **Palette Detail** - View saved images with color info

---

## Screen Designs (Native iOS)

### 1. Live Scan Screen

**Layout:**
```
┌─────────────────────────────────┐
│  [Camera Feed - Full Screen]    │
│                                  │
│  [Blob Overlays - translucent]  │
│                                  │
│                                  │
│  ┌─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┐  │
│  │ Color Palette (5 tiles)  │   │ ← Standard rounded rectangles
│  └─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┘  │
│  [Timeline Button]               │ ← Standard iOS button
└─────────────────────────────────┘
```

**Components:**
- `UIViewControllerRepresentable` for camera (AVCaptureSession)
- `Canvas` for blob overlays
- `HStack` of colored `RoundedRectangle` views for palette (with drag gesture)
- **Custom `LiquidSidebar` view** (animated Shape with spring physics)
- Standard SF Symbols icons
- `.toolbar` for timeline button

**Playful Interactions:**
- **Tap anywhere** → freeze with scale animation + haptic
- **Blob morphing** → blobs gently pulse and morph while live
- **Palette reordering** → tiles smoothly animate when colors change dominance
- **Tap color tile** → copy hex with success haptic + bounce animation
- **Long press color** → enlarged preview with color name
- **Drag palette right** → liquid sidebar emerges with elastic animation
- **Tap timeline icon** → navigate with custom transition

---

### 2. Freeze State

**Same screen, but:**
- Camera feed frozen (with subtle scale animation)
- Blobs static showing hex codes + color names
- **Palette dock glows** subtly to indicate it's draggable
- Haptic feedback on freeze

**Save Interaction - Liquid Sidebar:**
- **Drag palette tiles to the right** → liquid sidebar emerges from edge
- Sidebar shows small dots of previously saved freezes
- **Release drag over sidebar** → save with haptic + animation
- **Drag away** → sidebar melts back, nothing saved
- Success animation: palette tiles "fly" into sidebar with spring physics

**Alternative dismiss:**
- Tap anywhere outside palette → unfreeze, return to live

---

### 3. Timeline Screen

**Layout:**
```
┌─────────────────────────────────┐
│ SceneColor        [Close]        │ ← Navigation bar
├─────────────────────────────────┤
│ [JAN] [FEB] [MAR] ...           │ ← ScrollView with Picker style
├─────────────────────────────────┤
│ List {                           │
│   MON 13  Morning Cafe  ●●●●●   │ ← Standard List rows
│   TUE 14  Sunset Walk   ●●●●●   │
│   WED 15  Garden View   ●●●●●   │
│   ...                            │
│ }                                │
└─────────────────────────────────┘
```

**Components:**
- `NavigationStack` with standard navigation bar
- `ScrollView` + `HStack` for month filter pills (or `Picker` in segmented style)
- Standard `List` with `ForEach`
- SF Pro font (system default)
- Color dots as small `Circle` views

**Interactions:**
- Tap month → filter list
- Tap row → navigate to detail
- Swipe row left → delete action
- Pull to refresh (optional)

---

### 4. Palette Detail Screen

**Layout:**
```
┌─────────────────────────────────┐
│ Cafe Morning      [✕]           │ ← Navigation bar
├─────────────────────────────────┤
│                                  │
│  [Saved Image with Blobs]       │ ← Image view
│                                  │
├─────────────────────────────────┤
│  Color Palette                   │
│  ┌────┐ ┌────┐ ┌────┐          │
│  │ ██ │ │ ██ │ │ ██ │ ...     │ ← Color tiles
│  └────┘ └────┘ └────┘          │
│  #FF5733        #3498DB         │ ← Hex codes
│  Burnt Sienna   Sky Blue        │ ← Names
└─────────────────────────────────┘
```

**Components:**
- `NavigationStack` presentation
- Standard `Image` view
- `LazyVGrid` for color tiles
- System fonts throughout
- Standard dismiss button

---

## Data Models

```swift
struct Scene: Identifiable, Codable {
    let id: UUID
    var name: String
    var date: Date
    var freezes: [Freeze]
}

struct Freeze: Identifiable, Codable {
    let id: UUID
    let image: Data // UIImage as Data
    let palette: [ColorInfo]
    let date: Date
}

struct ColorInfo: Codable {
    let hex: String
    let name: String
    let rgb: (r: Int, g: Int, b: Int)
}
```

---

## Technical Architecture

### Color Extraction
**K-means clustering** on background thread
- Sample frame at 100×100
- Extract 5 dominant colors
- Sort by frequency

### Color Naming
**Database lookup** (no AI)
- CSS/X11 color names (~140 colors)
- Nearest color via Euclidean distance
- Fallback to hex only

### Blob Tracking
**Pixel-based region detection**
- For each extracted color, find matching pixels
- Group into connected regions
- Apply Gaussian blur for smooth organic shapes
- Draw as overlay with `Canvas`

### Persistence
**FileManager + JSON**
- Scenes saved to Documents directory
- Images saved separately
- Lazy loading for performance

---

## File Structure

```
SceneColor/
├── SceneColorApp.swift
├── Models/
│   ├── Scene.swift
│   ├── Freeze.swift
│   └── ColorInfo.swift
├── ViewModels/
│   ├── CameraViewModel.swift
│   └── TimelineViewModel.swift
├── Views/
│   ├── LiveScanView.swift
│   ├── TimelineView.swift
│   ├── PaletteDetailView.swift
│   └── Components/
│       ├── PaletteDock.swift
│       ├── BlobOverlay.swift
│       ├── LiquidSidebar.swift          ← Custom animated component
│       ├── FreezeRow.swift
│       └── MonthFilterBar.swift
├── Utils/
│   ├── CameraManager.swift
│   ├── ColorExtractor.swift
│   ├── ColorNamer.swift
│   └── BlobTracker.swift
└── Storage/
    └── SceneStore.swift
```

---

## Implementation Steps

### Phase 1: Camera Foundation
1. Set up Xcode project (iOS 16+)
2. Add camera permissions to Info.plist
3. Create `CameraManager` with AVFoundation
4. Build `LiveScanView` with camera preview
5. Test on device

### Phase 2: Color Extraction
6. Implement k-means clustering in `ColorExtractor`
7. Create color name database in `ColorNamer`
8. Build palette dock UI (5 color tiles)
9. Test live color updates

### Phase 3: Blob Tracking
10. Implement pixel region detection in `BlobTracker`
11. Create blob overlay with `Canvas`
12. Add hex + name labels on blobs
13. Toggle blob visibility

### Phase 4: Freeze & Save (Playful!)
14. Add tap gesture to freeze with scale animation
15. Implement `LiquidSidebar` with animated Shape
16. Add drag gesture on palette dock
17. Sidebar emerges/melts with spring physics
18. Save freeze on release over sidebar
19. Add haptic feedback throughout
20. Implement "fly to sidebar" save animation

### Phase 5: Timeline
19. Build `TimelineView` with standard List
20. Add month filter bar (ScrollView + HStack)
21. Create `FreezeRow` component
22. Implement filtering logic
23. Add navigation

### Phase 6: Detail View
24. Build `PaletteDetailView`
25. Display saved image with blobs
26. Show color grid with hex + names
27. Add edit/delete actions

### Phase 7: Persistence
28. Implement `SceneStore` with FileManager
29. Save/load scenes from disk
30. Handle image storage
31. Add error handling

### Phase 8: Polish
32. Add loading states
33. Improve animations (standard iOS transitions)
34. Test on multiple devices
35. Fix bugs and edge cases

---

## UI Components (Mostly Native + One Custom)

**Native SwiftUI:**
- `NavigationStack` - Navigation
- `List` - Timeline
- `ScrollView` + `HStack` - Month filters  
- `Canvas` - Blob overlays
- `RoundedRectangle` - Color tiles
- `Image` - Camera feed, saved photos
- `Text` - All text (SF Pro font)
- `Button` - Standard iOS buttons
- `.toolbar` - Navigation items
- `.swipeActions` - Delete gestures
- `.gesture(DragGesture())` - Liquid sidebar drag
- `.hapticFeedback` - Haptics throughout

**One Custom Component:**
- `LiquidSidebar.swift` - Animated sidebar using `Shape` protocol, spring animations, and glassmorphism blur

**Everything else is standard SwiftUI.**

---

## Color Scheme

Use iOS system colors:
- `.background` for backgrounds
- `.secondaryBackground` for cards
- `.label` for text
- `.secondaryLabel` for metadata
- Dynamic colors (light/dark mode support)

---

## Typography

**System font (SF Pro) everywhere:**
- `.largeTitle` - Screen titles
- `.title3` - Scene names
- `.body` - Default text
- `.caption` - Dates, metadata
- `.caption2` - Hex codes

---

## Gestures & Interactions (Playful!)

**Live Scan:**
- **Tap anywhere** - Freeze with scale animation + haptic
- **Tap color tile** - Copy hex with bounce + haptic
- **Long press tile** - Show enlarged color preview
- **Drag palette right** - Liquid sidebar emerges
- **Release over sidebar** - Save with spring animation

**Timeline:**
- **Tap row** - Navigate with custom transition
- **Swipe left** - Delete with haptic
- **Tap month pill** - Filter with fade animation
- **Pull to refresh** - Reload timeline (standard)

**Detail View:**
- **Pinch zoom** - Zoom into saved image
- **Double tap color** - Copy hex + name
- **Pull down** - Dismiss with spring

**Micro-animations everywhere for delight!**

---

## Ready to Build

This spec uses **only native iOS components** for quick, clean implementation. No custom design system needed. Just SwiftUI and UIKit fundamentals.

Start with Phase 1 and build incrementally. Test frequently on device (camera required).

---

**End of Specification**
