//
//  ImageListResponse.swift
//  ImageGallery
//
//  Created by STL009 on 14/04/19.
//

import Foundation

struct PhotosResponse: Codable {
    let photos: ImageList
}

struct ImageList: Codable {
    let page: Int
    let pages: Int
    let photo: [ImageData]
}
