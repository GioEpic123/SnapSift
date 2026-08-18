# SnapSift

SnapSift is an iOS app that helps you organize your photo library by allowing you to sift through your photos and delete duplicates or unwanted images.

Made for my lovely wife, Alexis.

## Features

- Swipe left to sift through photos
- Swipe right to skip photos
- Delete selected photos in bulk
- Date filtering for photos
- Privacy controls and ad consent management

## Ad Integration

This app integrates Google Mobile Ads SDK and Google User Messaging Platform (UMP) for handling user consent and ad display.

### Consent Management

The app uses a `ConsentManager` to handle user consent for personalized advertising. The integration includes:

1. **Initialization**: UMP is initialized when the app launches
2. **Consent Form**: Users can manage their ad preferences through the Privacy Settings screen
3. **Ad Display**: Ads are only shown when users have given consent

### Implementation Details

- **ConsentManager.swift**: Manages user consent state and interacts with Google's UMP
- **SnapSiftApp.swift**: Initializes GADMobileAds and UMP when the app launches
- **ContentView.swift**: Displays AdBanner at the top of the screen
- **PrivacySettingsView.swift**: Provides interface for users to manage ad preferences

### Testing

For development:

- Test ads are used with test device identifiers
- Consent forms can be reset using `resetConsent()` method
- The app respects user consent decisions and only displays ads when appropriate

## Getting Started

1. Clone the repository
2. Open in Xcode
3. Build and run on a simulator or physical device

## License

This project is licensed under the MIT License.
