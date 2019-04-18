//
//  ImagesProvider.swift
//  ImageGallery
//
//  Created by STL009 on 14/04/19.
//

import UIKit
let API_KEY = "f9cc014fa76b098f9e82f1c288379ea1"
class ImagesProvider: NSObject {
    
    private var currentPage: Int = 0
    private var totalPages: Int = 0
    private(set) var currentTag = ""
    private var images = [ImageData]()
    
    var startLoading: (() -> Void)?
    var startNextPageLoading: (() -> Void)?
    var newDataAvailable: (() -> Void)?
    var noNewImages: (() -> Void)?
    var errorHandler: ((String) -> Void)?
    
    var imageCount: Int {
        return images.count
    }
    
    func getThumbnailUrlFor(index: Int) -> URL? {
        return images[index].thumbnailUrl
    }
    
    func getLargeImageUrlFor(index: Int) -> URL? {
        return images[index].largeImageUrl
    }
    
    func getImagesFor(tag: String) {
        if currentTag != tag {
            currentPage = 1
            currentTag = tag
            images.removeAll()
            self.startLoading?()
        } else if totalPages > currentPage + 1 {
            currentPage += 1
            self.startNextPageLoading?()
        } else {
            self.noNewImages?()
            return
        }
        
        getImagesWith(tag: currentTag, page: currentPage) { [unowned self] (response) in
            self.currentPage = response.page
            self.totalPages = response.pages
            self.images.append(contentsOf: response.photo)
            self.newDataAvailable?()
        }
    }
    
    private func getImagesWith(tag: String, page: Int = 1, photos: @escaping((ImageList) -> Void)) {
        guard let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&tags=\(tag)&page=\(page)&format=json&nojsoncallback=1".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let error = error {
                self.errorHandler?(error.localizedDescription)
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(PhotosResponse.self, from: data!)
                print(responseModel)
                photos(responseModel.photos)
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
    }
}
