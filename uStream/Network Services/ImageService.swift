//
//  MediaController.swift
//  uStream
//
//  Created by stanley phillips on 2/18/21.
//

import UIKit

//base urlhttps://api.themoviedb.org/
//image urlhttp://image.tmdb.org/t/p/w500/(imageEndpoint)

enum ImageEndPoint {
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500/"
    
    case poster(String)
    case backdrop(String)
    case logo(String)
    
    var path: String {
        switch self {
        case .poster(let posterPath):
            return posterPath
        case .backdrop(let backdropPath):
            return backdropPath
        case .logo(let logoPath):
            return logoPath
        }
    }
    
    var url: URL? {
        guard var url = URL(string: ImageEndPoint.imageBaseURL) else { return nil }
        url.appendPathComponent(path)
        return url
    }
}

class ImageCache {
    static var shared = NSCache<NSURL, UIImage>()
}

struct ImageService: NetworkServicing {
    func fetchImage(_ endpoint: ImageEndPoint, completion: @escaping (Result<UIImage, NetError>) -> Void) {
        guard let imageURL = endpoint.url else {
            completion(.failure(.badURL))
            return
        }
        
        if let poster = ImageCache.shared.object(forKey: NSURL(string: imageURL.absoluteString) ?? NSURL()) {
            completion(.success(poster))
        } else {
            perform(urlRequest: URLRequest(url: imageURL)) { (result) in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        completion(.failure(.couldNotUnwrap))
                        return
                    }
                    ImageCache.shared.setObject(image, forKey: NSURL(string: imageURL.absoluteString) ?? NSURL())
                    return completion(.success(image))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }//end func
}//end class
