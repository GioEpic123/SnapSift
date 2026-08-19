import SwiftUI
import UserMessagingPlatform

struct PrivacySettingsView: View {
    
    @Environment(AppState.self)
    var appState: AppState
    
    var body: some View {
        VStack(spacing: 20) {
            TitleCard()

            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Settings")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("SnapSift processes your photos locally on your device. Photos are never uploaded to SnapSift.")
                    .font(.body)

                Text("SnapSift uses Google AdMob to display advertisements. Advertising and privacy choices may vary by location.")
                    .font(.body)

                if ConsentInformation.shared.privacyOptionsRequirementStatus == .required {
                    Button(action: {
                        showPrivacyOptions()
                    }) {
                        Text("Privacy Choices")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.aquamarine.color)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }

                Link(
                    "Read Full Privacy Policy",
                    destination: URL(string: "https://gioepic123.github.io/src/privacy.html")!
                )
                .frame(maxWidth: .infinity)
                .padding()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal)

            VStack(spacing: 4) {
                Text("SnapSift - Organize your photo library")
                Text("Version 1.0")
            }
            .font(.footnote)
            .foregroundColor(.secondary)
            .padding()
        }
        .padding(.top)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.spearMint.color)
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    print("Tapped Back")
                    appState.navigate(.home)
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
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
    NavigationStack {
        PrivacySettingsView()
    }
}
