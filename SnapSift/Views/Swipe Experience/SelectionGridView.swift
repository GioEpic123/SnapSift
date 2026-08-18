//
//  SelectionGridView.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 6/29/26.
//

import SwiftUI

struct SelectionGridView: View {
    @Environment(AppState.self)
    var appState: AppState
    
    @State private var isEditing = false
    
    var body: some View {
        
        VStack {
            if appState.selectedPhotos.isEmpty {
                emptySelectionView()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(appState.selectedPhotos) { photo in
                            PhotoThumbnailView(photo: photo, showDeleteX: isEditing)
                                .onTapGesture {
                                    if isEditing {
                                        appState.clearSelectedPhoto(photo)
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Selected Photos")
        .toolbar {
            if !appState.selectedPhotos.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Done" : "Edit Selection")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.spearMint.color)
        .safeAreaInset(edge: .bottom){
            // Bottom action buttons
            HStack {
                Button(action: clearSelection) {
                    Text("Clear Selection")
                        .foregroundColor(AppColors.burgundy.color)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.burgundy.color.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Button(action: deleteSelectedPhotos) {
                    Text("Delete Selected")
                        .foregroundColor(AppColors.aquamarine.color)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.aquamarine.color.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    private func emptySelectionView() -> some View {
        VStack(spacing: 20) {
            
            ZStack {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 80))
                    .foregroundColor(Color.black.opacity(0.8))
                
                Image(systemName: "xmark")
                    .font(.system(size: 150))
                    .foregroundColor(AppColors.burgundy.color.opacity(0.3))
            }
            
            Text("No Photos Selected!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("You haven't selected any photos to delete yet.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.secondary)
            
            Button(action: {
                appState.currentView = .photoStack
            }) {
                Text("Start Selecting Photos")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.aquamarine.color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    private func clearSelection() {
        appState.clearSelection()
        appState.currentView = .photoStack
    }
    
    private func deleteSelectedPhotos() {
        if !appState.selectedPhotos.isEmpty {
            Task {
                do {
                    let deletedCount = try await appState.deleteSelectedPhotos()
                    appState.currentView = .success(count: deletedCount)
                } catch {
                    // TODO: Handle error appropriately
                    print("Error deleting photos: \(error)")
                }
            }
        }
    }
}

struct PhotoThumbnailView: View {
    let photo: Photo
    let showDeleteX: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(AppColors.aquamarine.color)

            Image(uiImage: photo.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(5)

            if showDeleteX {
                ZStack {
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 35, height: 35)

                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    SelectionGridView()
        .environment(AppState())
}
