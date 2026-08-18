//
//  PermissionView.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 6/29/26.
//

import SwiftUI
import PhotosUI

struct PermissionView: View {
    @Environment(AppState.self)
    var appState: AppState
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State fileprivate var permissionsLoading = true

    var body: some View {
        
        Group {
            switch appState.permissionStatus {
            case .authorized, .limited:
                ProgressView("Just a sec! Getting your photos ready...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.spearMint.color)
            case .notDetermined, .denied, .restricted:
                permissionsPage()
            @unknown default:
                permissionsPage()
            }
        }
        .onChange(of: scenePhase) {
            appState.syncPermissionStatus()
        }
        
    }
    
    private func permissionsPage() -> some View {
        VStack(spacing: 20) {
            TitleCard()

            Text("To help clean your photos, we need access to your photo library.")
                .multilineTextAlignment(.center)
                .padding(.vertical)

            Text("""
                First, select which photos we’ll have access to.
                 Then, use our sifting feature to choose which to keep and which to toss!

                 We will never save any of your images, or delete anything you didn’t ask for.
                """)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .foregroundColor(.secondary)
            
            
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.spearMint.color)
        .safeAreaInset(edge: .bottom) {
            permissionButton()
        }
    }
    
    @ViewBuilder
    private func permissionButton() -> some View {
        if appState.permissionStatus != .denied {
            Button(action: requestPermission) {
                Text("Allow Photo Access")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.aquamarine.color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        } else {
            VStack {
                Text("Photos access is disabled. \nYou can enable it in Settings.")
                    .multilineTextAlignment(.center)

                Button(action: launchSettings) {
                    Text("Open Settings...")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.burgundy.color.opacity(0.1))
                        .foregroundColor(AppColors.burgundy.color)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
    
    private func launchSettings(){
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    private func requestPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                print("Asked - response is: \(status)")
                appState.syncPermissionsThenNavigate()
            }
        }
    }
}

#Preview {
    PermissionView()
        .environment(AppState())
}
