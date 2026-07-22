//
//  PhotoStackView.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 6/29/26.
//

import SwiftUI
import PhotosUI

struct PhotoStackView: View {
    @Environment(AppState.self)
    var appState: AppState
    
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var isLoading = false
    @State private var showingDateFilter = false

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading photos...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }else{
                if appState.photos.isEmpty {
                    emptyStateView()
                }else{
                    ZStack {
                        // Illusion of infinite stack
                        colorHints()
                        nextPhotoStackView()
                        photoStackView()
                    }
                    .padding()
                }
            }
            
            // 'Finish' action button always visible
        }
        // Additional UI elements
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingDateFilter = true
                } label: {
                    Image(systemName: "calendar")
                }
            }
            
        }
        .sheet(isPresented: $showingDateFilter) {
            DateFilterView().presentationDetents([.medium])
        }
        .safeAreaInset(edge:.bottom){
            Button(action: finishSelection) {
                Text(appState.selectedPhotos.isEmpty ? "No photos selected!" : "Finish")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.aquamarine.color)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(AppColors.aquamarine.color.opacity(0.1))
                    .cornerRadius(10)
            }
            .disabled(appState.selectedPhotos.isEmpty) // can't finish if none are selected
            .padding()
        }
        // Logic
        .onAppear {
            appState.refreshPhotos()
        }
        .onChange(of: appState.photos) {
            currentIndex = 0
            dragOffset = 0
        }
        // Style
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.spearMint.color)

    }

    private func photoStackView() -> some View {
        ZStack {
            if currentIndex < appState.photos.count {
                PhotoCardView(photo: appState.photos[currentIndex])
                    .offset(x: dragOffset, y: 0)
                    .rotationEffect(.degrees(dragOffset / 20))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                handleSwipe(value)
                            }
                    )
            }else{
                emptyStateView()
            }
        }
    }
    
    // For peeking
    private func nextPhotoStackView() -> some View {
        ZStack {
            if currentIndex < appState.photos.count - 1{
                PhotoCardView(photo: appState.photos[currentIndex + 1])
            }else{
                emptyStateView()
            }
        }
    }
    
    // Show red if they swipe to the left, green to the right
    private func colorHints() -> some View {
        HStack {
            
            // Only show the color that represents current action (keep/delete)
            
            Color.red.ignoresSafeArea().opacity(dragOffset < 0 ? abs(CGFloat(dragOffset) / 200) : 0)
                .cornerRadius(15)
            Color.green.ignoresSafeArea().opacity(dragOffset > 0 ? abs(CGFloat(dragOffset) / 200) : 0)
                .cornerRadius(15)
            
            //Color.green.ignoresSafeArea()
        }
    }

    private func emptyStateView() -> some View {
        VStack(spacing: 20) {
            
            Image(systemName: "checkmark.circle")
                .font(.system(size: 50))
                .foregroundColor(AppColors.aquamarine.color)

            Text("Well Done! 🎉")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("""
                    That's all the pics we have access to! 😁
                
                    If you selected any for deletion, 
                hit 'Finish' to finalize your choices!
                    
                    ...or hit 'Start Over' to clear you selection!
                """)
                .multilineTextAlignment(.center)
//                .padding(.horizontal)
                .foregroundColor(.secondary)

            Button(action: {
                // Go back to permission screen
                appState.reset()
            }) {
                Text("Start Over")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.burgundy.color)
                    .frame(width: 200, height: 50)
                    .background(AppColors.burgundy.color.opacity(0.1))
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    

    private func handleSwipe(_ value: DragGesture.Value) {
        // Determine swipe direction
        if value.translation.width > 100 {
            // Swipe right - keep photo (untouched)
            keepCurrentPhoto()
            advancePhotoStackAfterDelay()
        } else if value.translation.width < -100 {
            // Swipe left - delete photo (select for deletion)
            markPhotoForDeletion()
            advancePhotoStackAfterDelay()
        } else {
            // Return to center without action
            withAnimation {
                dragOffset = 0
            }
        }
    }

    private func keepCurrentPhoto() {
        guard currentIndex < appState.photos.count else { return }

        withAnimation {
            dragOffset = 200
        }
    }

    private func markPhotoForDeletion() {
        guard currentIndex < appState.photos.count else { return }

        withAnimation {
            dragOffset = -200
        }
        // Mark photo as selected for deletion
        let photo = appState.photos[currentIndex]
        appState.selectPhoto(photo)
    }
    
    // Triggered when a selection is made
    private func advancePhotoStackAfterDelay(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            currentIndex += 1
            dragOffset = 0
        }
    }

    private func finishSelection() {
        if !appState.selectedPhotos.isEmpty {
            appState.currentView = .selectionGrid
        } else {
            // If no photos selected, go back to permission screen
            appState.reset()
        }
    }
}

struct PhotoCardView: View {
    let photo: Photo

    var body: some View {
        ZStack {
            Rectangle()
                .fill(AppColors.aquamarine.color)

            Image(uiImage: photo.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 10)
        }
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

#Preview {
    PhotoStackView()
        .environment(AppState())
}
