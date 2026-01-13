# SceneColor Setup Instructions

## Opening in Xcode

Since we created the project structure manually, you'll need to create the Xcode project file:

### Option 1: Create New Xcode Project (Recommended)

1. Open Xcode
2. Select **File > New > Project**
3. Choose **iOS > App**
4. Configuration:
   - **Product Name**: SceneColor
   - **Team**: Select your development team
   - **Organization Identifier**: com.yourname (or your identifier)
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Storage**: None
5. **Save location**: Select `/Users/anuragsingh/.gemini/antigravity/scratch/SceneColor` (the existing folder)
6. Xcode will ask "A folder already exists. Would you like to add files?" → Click **Add**
7. Delete the default files Xcode created (SceneColorApp.swift duplicate)
8. In Project Navigator, **Add Files** to project:
   - Right-click on SceneColor folder → Add Files
   - Navigate to `SceneColor/SceneColor/` folder
   - Select all folders (Models, Views, ViewModels, Utils)
   - Check "Create groups" and "Add to targets: SceneColor"
   - Click Add

### Option 2: Use Existing Files

The code is already in place at:
```
/Users/anuragsingh/.gemini/antigravity/scratch/SceneColor/SceneColor/SceneColor/
```

Just create an Xcode project pointing to this location and add the existing files.

## Project Configuration

After opening in Xcode:

1. **Select a Team**: In project settings, select your development team
2. **Bundle Identifier**: Set to `com.yourname.SceneColor` or similar
3. **Deployment Target**: iOS 16.0 or later
4. **Device**: Build for a physical device (camera required)

## Git Repository

The git repo is initialized at:
```
/Users/anuragsingh/.gemini/antigravity/scratch/SceneColor
```

## Files Created

✅ Models: Scene, Freeze, ColorInfo, AppState
✅ Views: LiveScanView, TimelineView, FreezeRow
✅ ViewModels: CameraViewModel
✅ Utils: ColorNamer
✅ Info.plist with camera permissions
✅ README.md and BUILD_SPEC.md

## Next Steps

After setting up the Xcode project:

1. Build and run on simulator to test basic UI
2. Connect a physical device to test camera
3. Implement Phase 2: Color Extraction (see BUILD_SPEC.md)
4. Implement Phase 3: Blob Tracking
5. Continue with remaining phases

## Current Status

- ✅ Git repository initialized
- ✅ Project structure created
- ✅ Base models and views implemented
- ⏳ Need to create `.xcodeproj` file via Xcode
- ⏳ Phase 2-8 implementation pending
