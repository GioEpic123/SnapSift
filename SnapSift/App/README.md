# SnapSift - iOS Photo Deletion App

A SwiftUI-based iOS application for selecting and deleting photos from the device library with swipe gestures.

## Features

- **Permission Management**: Requests access to photo library
- **Swipe Interface**: Intuitive left/right swipe gestures to select/deselect photos
- **Selection Grid**: View all selected photos in a grid format
- **Bulk Deletion**: Delete multiple photos at once
- **Success Confirmation**: Shows count of deleted photos
- **Complete Navigation Flow**: Permission → Photo Stack → Selection Grid → Success → Home

## Implementation Details

### Core Components:

1. `AppState.swift` - Manages app state and navigation between views
2. `PhotoStackView.swift` - Swipeable photo selection interface
3. `SelectionGridView.swift` - Grid view of selected photos with delete functionality
4. `SuccessScreen.swift` - Confirmation screen showing deleted photo count
5. `HomeView.swift` - Main navigation screen

### Navigation Flow:

- Permission Screen → Photo Stack View → Selection Grid View → Success Screen → Home View

### Key Features:

- Swipe gestures (left = delete, right = keep)
- Visual feedback for photo status
- Proper state management with environment objects
- Error handling and edge cases
- Clean separation of concerns between UI components

## How to Use

1. Launch the app
2. Grant permission to access photos when prompted
3. Swipe through photos (left to delete, right to keep)
4. When finished selecting, tap "Finish Selection"
5. View selected photos in grid format
6. Tap "Delete Selected" to remove all selected photos
7. See confirmation screen showing number of deleted photos
8. Return to home screen to start over
