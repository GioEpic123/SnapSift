//
//  AppState.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 6/29/26.
//

import Foundation
import Combine
import PhotosUI

@Observable
class AppState {
    var photos: [Photo] = [] // Pics we have access to from photo lib
    var selectedPhotos: [Photo] = [] // user 'selected' marked for deletion
    var currentView: AppView = .home
    var permissionStatus: PHAuthorizationStatus = .notDetermined

    // Active filter, modified by DateFilterView
    var activeFilter: PhotoFilter? = nil

    var oldestPhotoDate: Date? = .distantPast

    init() {
        PhotoLibraryManager.shared.onLibraryChanged = {
            self.refreshPhotos()
        }
    }

    enum AppView {
        case permission
        case photoStack
        case selectionGrid
        case success(count: Int)
        case home
    }

    func navigate(_ newView: AppView){
        currentView = newView
    }

    func reset() {
        photos.removeAll()
        selectedPhotos.removeAll()
        currentView = .home
    }

    func refreshPhotos() {
        PhotoLibraryManager.shared.fetchPhotos(activeFilter: activeFilter) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let photos):
                    self.photos = photos
                case .failure:
                    break
                }
            }
        }
        oldestPhotoDate = PhotoLibraryManager.shared.getOldestPhotoDate()
        clearSelection()
    }

    // User actions

    func selectPhoto(_ photo: Photo) {
        selectedPhotos.append(photo)
    }

    func clearSelectedPhoto(_ photo: Photo) {
        selectedPhotos.removeAll { $0.id == photo.id }
    }

    func clearSelection() {
        selectedPhotos.removeAll()
    }

    func deleteSelectedPhotos() async throws -> Int {
        let count = selectedPhotos.count

        // Get asset IDs of selected photos
        let assetIds = selectedPhotos.compactMap { $0.assetId }

        if !assetIds.isEmpty {
            try await PhotoLibraryManager.shared.deletePhotos(assetIds: assetIds)
        }

        clearSelection()
        return count
    }

    // Permissions

    func syncPermissionStatus() {
        permissionStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }

    func syncPermissionsThenNavigate() {
        syncPermissionStatus()
        if permissionStatus == .authorized || permissionStatus == .limited {
            navigate(.photoStack)
        }else{
            navigate(.permission)
        }
    }

    func requestPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                self.permissionStatus = status

                if status == .authorized || status == .limited {
                    self.currentView = .photoStack
                }
            }
        }
    }

    // Navigation methods
    func navigateToPrivacySettings() {
        // This will be handled by the view that presents privacy settings
        // We can add logic here to handle specific privacy-related navigation if needed
    }

    // Ads

    enum UserAdType {
        case undefined
        case free
        case premium
    }
}
