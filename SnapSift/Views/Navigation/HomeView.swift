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
                // Photo page entry point
                Button(action: {
                    appState.syncPermissionsThenNavigate()
                }) {
                    Text("Start Sifting")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.aquamarine.color)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom)
                
            }
        }
        .safeAreaInset(edge: .top) {
            // Privacy Page Entry Point
            HStack {
                Spacer()
                Button("Privacy") {
                    appState.navigate(.privacy)
                }
                .padding(8)
                .background(AppColors.aquamarine.color.opacity(0.1))
                .foregroundColor(AppColors.aquamarine.color)
                .cornerRadius(10)
                .foregroundColor(.secondary)
            }
            .padding()
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
