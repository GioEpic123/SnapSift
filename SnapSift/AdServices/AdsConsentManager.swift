import Foundation
import Observation
import UserMessagingPlatform

@MainActor
@Observable
final class AdsConsentManager {
    private(set) var canRequestAds = false
    
    private enum DebugAdsTestingConfig{
        case none
        case forceEEA
        case forceRegulatedUS
    }

    func requestConsent() async {
        let consentInformation = ConsentInformation.shared
        
        let parameters = RequestParameters()

        #if DEBUG
        let debugSettings = DebugSettings()
        
        // TODO: Currently resets every time
        ConsentInformation.shared.reset()
        
        // TODO: manually adjust this to change test case
        let testCase = DebugAdsTestingConfig.forceRegulatedUS
        
        // TODO: Use when testing off sim
        //debugSettings.testDeviceIdentifiers = ["YOUR_TEST_DEVICE_ID"]
        switch testCase {
            case .none:
            break
            case .forceEEA:
                debugSettings.geography = .EEA
            case .forceRegulatedUS:
                debugSettings.geography = .regulatedUSState
        }
        parameters.debugSettings = debugSettings
        #endif

        do {
            try await consentInformation.requestConsentInfoUpdate(
                with: parameters
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
