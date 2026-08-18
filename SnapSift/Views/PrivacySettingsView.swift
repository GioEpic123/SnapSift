import SwiftUI
import UserMessagingPlatform

struct PrivacySettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section("Privacy Settings") {
                    if ConsentInformation.shared.privacyOptionsRequirementStatus == .required {
                        Button("Privacy Choices") {
                            showPrivacyOptions()
                        }
                    }
                }

                Section("About") {
                    Text("SnapSift - Organize your photo library")
                    Text("Version 1.0")
                }
            }
            .navigationTitle("Privacy")
        }
    }

    private func showPrivacyOptions() {
        Task {
            do {
                try await ConsentForm.presentPrivacyOptionsForm(from: nil)
            } catch {
                print("Error presenting privacy options: \(error)")
            }
        }
    }
}

#Preview {
    PrivacySettingsView()
}
