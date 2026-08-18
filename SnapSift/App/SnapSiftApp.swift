import SwiftUI
import GoogleMobileAds

@main
struct SnapSiftApp: App {
    @State private var appState = AppState()
    @State private var consentManager = ConsentManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(consentManager)
                .preferredColorScheme(.light)
                .task {
                    await consentManager.requestConsent()

                    if consentManager.canRequestAds {
                        await MobileAds.shared.start()
                    }
                }
        }
    }
}
