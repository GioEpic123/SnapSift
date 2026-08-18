//
//  SnapSiftApp.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 6/29/26.
//

import SwiftUI
import GoogleMobileAds
import GoogleUserMessagingPlatform

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
                .onAppear {
                    // Initialize Google Mobile Ads and UMP
                    GADMobileAds.sharedInstance.start(completionHandler: nil)

                    // Initialize UMP
                    GADUSConsentInformation.shared.requestConsentInfoUpdate(
                        forPublisherIdentifiers: [Secrets.publisherIdentifier]) { error in
                            if let error = error {
                                print("UMP initialization error: \(error)")
                            }
                        }
                }
        }
    }
}
