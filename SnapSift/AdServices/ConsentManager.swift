//
//  ConsentManager.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 8/18/26.
//

import Foundation
import Combine
import GoogleMobileAds
import GoogleUserMessagingPlatform

@Observable
class ConsentManager {
    // Whether ads can be requested based on user consent
    var canRequestAds = false

    // Whether UMP is initialized and ready to show forms
    var isConsentFormAvailable = false

    private var form: GADUSConsentForm?

    init() {
        // Check if we already have consent information
        checkConsentStatus()
    }

    /// Check current consent status and update canRequestAds
    func checkConsentStatus() {
        let consentInformation = GADUSConsentInformation.shared
        canRequestAds = consentInformation.canRequestAds

        // Check if form is available (for testing purposes)
        isConsentFormAvailable = true
    }

    /// Request consent form from UMP
    func requestConsentForm() {
        GADUSConsentForm.load { [weak self] form, error in
            guard let self = self else { return }

            if let error = error {
                print("UMP Form loading error: \(error)")
                return
            }

            self.form = form
            self.isConsentFormAvailable = true
        }
    }

    /// Present the consent form to the user
    func presentConsentForm() {
        guard let form = form else {
            print("No consent form available")
            return
        }

        // For development, use test device identifier
        GADUSConsentInformation.shared.testDeviceIdentifiers = [GADUMSTestDeviceIdentifier]

        form.present(from: UIApplication.shared.windows.first?.rootViewController ?? UIViewController()) { [weak self] error in
            if let error = error {
                print("Error presenting consent form: \(error)")
            } else {
                // Consent was obtained, update canRequestAds
                self?.checkConsentStatus()
            }
        }
    }

    /// Reset consent to initial state (for testing)
    func resetConsent() {
        GADUSConsentInformation.shared.reset()
        checkConsentStatus()
    }
}