import Foundation
import Observation
import UserMessagingPlatform

@MainActor
@Observable
final class ConsentManager {
    private(set) var canRequestAds = false

    func requestConsent() async {
        let consentInformation = ConsentInformation.shared

        do {
            try await consentInformation.requestConsentInfoUpdate(
                with: RequestParameters()
            )

            try await ConsentForm.loadAndPresentIfRequired(
                from: nil
            )

            canRequestAds = consentInformation.canRequestAds
        } catch {
            print("UMP error: \(error)")
            canRequestAds = consentInformation.canRequestAds
        }
    }

    func reset() {
        ConsentInformation.shared.reset()
        canRequestAds = false
    }
}
