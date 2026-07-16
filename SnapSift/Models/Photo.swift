//
//  Photo.swift
//  SnapSift
//
//  Created by Giovanni Quevedo on 6/29/26.
//

import Foundation
import UIKit

struct Photo: Identifiable, Hashable {
    let id = UUID()
    let image: UIImage
    let assetId: String

    // For comparison purposes
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
