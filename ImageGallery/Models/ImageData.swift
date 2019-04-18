//
//  ImageData.swift
//  ImageGallery
//
//  Created by STL009 on 14/04/19.
//

import Foundation
struct ImageData: Codable {
    let id: String
    let secret: String
    let title: String
    let server: String
    let farm: Int
    var thumbnailUrl: URL? {
        get {
            return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg")
        }
    }
    var largeImageUrl: URL? {
        get {
            return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg")
        }
    }
}
