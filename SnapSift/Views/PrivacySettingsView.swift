//
//  PrivacySettingsView.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 6/29/26.
//

import SwiftUI
import GoogleUserMessagingPlatform

struct PrivacySettingsView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Privacy Settings")) {
                    NavigationLink(destination: AdPreferencesView()) {
                        Text("Ad Preferences")
                    }

                    // Add privacy options row if required
                    if shouldShowPrivacyOptions() {
                        Button(action: {
                            showPrivacyOptions()
                        }) {
                            Text("Privacy Choices")
                                .foregroundColor(.blue)
                        }
                    }
                }

                Section(header: Text("About")) {
                    Text("SnapSift - Organize your photo library")
                    Text("Version 1.0")
                }
            }
            .navigationBarTitle("Privacy", displayMode: .large)
        }
    }

    /// Check if privacy options are required based on UMP status
    private func shouldShowPrivacyOptions() -> Bool {
        return GADUSConsentInformation.shared.privacyOptionsRequirementStatus == .required
    }

    /// Present Google's privacy options form
    private func showPrivacyOptions() {
        // Create a presentation controller to present the form from
        let rootViewController = UIApplication.shared.windows.first?.rootViewController

        // Present the privacy options form
        GADUSConsentForm.presentPrivacyOptionsForm(
            from: rootViewController,
            completionHandler: { error in
                if let error = error {
                    print("Error presenting privacy options form: \(error)")
                }
                // Form closed, no action needed
            }
        )
    }
}

struct PrivacySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacySettingsView()
    }
}