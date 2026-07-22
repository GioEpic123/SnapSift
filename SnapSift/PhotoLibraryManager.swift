//
//  PhotoLibraryManager.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 6/29/26.
//

import Foundation
import PhotosUI
import SwiftUI
import UIKit

class PhotoLibraryManager: NSObject, PHPhotoLibraryChangeObserver {
    
    var onLibraryChanged: (() -> Void)?
    
    private override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        Task {
            self.onLibraryChanged?()
        }
    }
    
    static let shared = PhotoLibraryManager()
    
    func getOldestPhotoDate() -> Date? {
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        options.fetchLimit = 1

        return PHAsset.fetchAssets(with: .image, options: options)
            .firstObject?
            .creationDate
    }

    func fetchPhotos(activeFilter: PhotoFilter?, completion: @escaping (Result<[Photo], Error>) -> Void) {
        // Check authorization status first
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized, .limited:
            fetchAuthorizedPhotos(activeFilter: activeFilter, completion: completion)
        case .denied, .restricted:
            completion(.failure(PhotoLibraryError.permissionDenied))
        default:
            // Not determined - request permission
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    switch newStatus {
                    case .authorized, .limited:
                        self.fetchAuthorizedPhotos(activeFilter: activeFilter,completion: completion)
                    default:
                        completion(.failure(PhotoLibraryError.permissionDenied))
                    }
                }
            }
        }
    }
    
    /// Delete multiple photos from the photo library
    func deletePhotos(assetIds: [String]) async throws {
        // Fetch all assets by their local identifiers
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: assetIds, options: nil)

        // Convert to array of assets
        var assets: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }

        // Delete the assets
        try await withCheckedThrowingContinuation { continuation in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets(assets as NSFastEnumeration)
            }) { success, error in
                if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: error ?? NSError(domain: "PhotoLibraryError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to delete photos"]))
                }
            }
        }
    }

    private func fetchAuthorizedPhotos(activeFilter: PhotoFilter?, completion: @escaping (Result<[Photo], Error>) -> Void) {
        // Create fetch request for photos
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        if let activeFilter{
        
            if let start = activeFilter.startDate, let end = activeFilter.endDate {
                fetchOptions.predicate = NSPredicate(
                    format: "creationDate >= %@ AND creationDate <= %@",
                    start as NSDate,
                    end as NSDate
                )
            } else if let start = activeFilter.startDate {
                fetchOptions.predicate = NSPredicate(
                    format: "creationDate >= %@",
                    start as NSDate
                )
            } else if let end = activeFilter.endDate {
                fetchOptions.predicate = NSPredicate(
                    format: "creationDate <= %@",
                    end as NSDate
                )
            }
        }
        

        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        var photos: [Photo] = []

        // Process assets
        fetchResult.enumerateObjects { asset, _, _ in
            // Create a request for the image
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true

            PHImageManager.default().requestImage(
                for: asset,
                targetSize: CGSize(width: 300, height: 300),
                contentMode: .aspectFill,
                options: requestOptions
            ) { image, _ in
                if let image = image {
                    // Create Photo object with the asset ID for reference
                    let photo = Photo(image: image, assetId: asset.localIdentifier)
                    photos.append(photo)
                }

                // Check if we've processed all assets
                if photos.count == fetchResult.count {
                    DispatchQueue.main.async {
                        completion(.success(photos))
                    }
                }
            }
        }

        // Handle case where no photos are found
        if fetchResult.count == 0 {
            DispatchQueue.main.async {
                completion(.success([]))
            }
        }
    }
}

enum PhotoLibraryError: Error, LocalizedError {
    case permissionDenied

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Photo library access was denied. Please enable it in Settings."
        }
    }
}
