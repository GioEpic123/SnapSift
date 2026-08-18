//
//  HomeView.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 6/29/26.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @Environment(AppState.self)
    var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            TitleCard()

            Text("""
                 Sift Away your Photo clutter!

                 Swipe Left to Sift
                 Swipe Right to Skip
                 """)
                .multilineTextAlignment(.center)
                .padding()
                //.padding(.horizontal)
                .foregroundColor(.secondary)


        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.spearMint.color)
        .safeAreaInset(edge:.bottom){

            VStack {
                if appState.permissionStatus == .limited {
                    Button(action: {
                        if let controller = UIApplication.shared.topViewController {
                            PHPhotoLibrary.shared()
                                .presentLimitedLibraryPicker(from: controller)
                        }
                    }) {
                        Text("Change selected photos")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.aquamarine.color.opacity(0.1))
                            .foregroundColor(AppColors.aquamarine.color)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }

                Button(action: {
                    appState.syncPermissionsThenNavigate()
                }) {
                    Text("Start Swiping!")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.aquamarine.color)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
        .safeAreaInset(edge: .top) {
            // Add a privacy settings button at the top
            HStack {
                Spacer()
                Button("Privacy") {
                    // This would navigate to privacy settings in a real implementation
                    // For now, we'll just show a preview of what it would do
                }
                .padding()
                .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(AppState())
}

extension UIApplication {
    var topViewController: UIViewController? {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let root = windowScene.windows.first?.rootViewController else {
            return nil
        }

        var controller = root

        while let presented = controller.presentedViewController {
            controller = presented
        }

        return controller
    }
}