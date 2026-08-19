import SwiftUI
import GoogleMobileAds

@main
struct SnapSiftApp: App {
    @State private var appState = AppState()
    @State private var adsConsentManager = AdsConsentManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(adsConsentManager)
                .preferredColorScheme(.light)
                .task {
                    await adsConsentManager.requestConsent()

                    if adsConsentManager.canRequestAds {
                        await MobileAds.shared.start()
                    }
                }
        }
    }
}
