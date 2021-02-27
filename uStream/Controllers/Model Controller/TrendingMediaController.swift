//
//  TrendingController.swift
//  uStream
//
//  Created by stanley phillips on 2/18/21.
//

import UIKit

//base urlhttps://api.themoviedb.org/
//image urlhttp://image.tmdb.org/t/p/w500/(imageEndpoint)
//https://api.themoviedb.org/3/trending/all/day?api_key=48bcdd5f1ad8e7b88756b97c0c6c3c74

class TrendingMediaController {
    // MARK: - String Constants
    static let posterBaseURL = URL(string: "https://image.tmdb.org/t/p/w500/")
    static let baseURL = URL(string: "https://api.themoviedb.org/")
    static let versionComponent = "3"
    static let trendingComponent = "trending"
    static let movieComponent = "movie"
    static let tvComponent = "tv"
    static let personComponent = "person"
    static let dayComponent = "day"
    static let apiKey = "48bcdd5f1ad8e7b88756b97c0c6c3c74"
    
    // MARK: - Properties
    static var imageCache = NSCache<NSURL, UIImage>()
    
    

    // MARK: - API Methods
    static func fetchTrendingResultsFor(mediaType: String, completion: @escaping (Result<TrendingMedia, NetworkError>) -> Void) {
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let trendingURL = versionURL.appendingPathComponent(trendingComponent)
        let mediaTypeURL = trendingURL.appendingPathComponent(mediaType)
        let dayURL = mediaTypeURL.appendingPathComponent(dayComponent)
        
        var components = URLComponents(url: dayURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "api_key", value: apiKey)
        
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("TRENDING MEDIA STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            do {
                let trending = try JSONDecoder().decode(TrendingMedia.self, from: data)
                return completion(.success(trending))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }//end func
    
    /// Function that attempts to get image from cache if not there fetch with api call
    /// - Parameters:
    ///   - media: movie or tv object from the api
    ///   - completion: will contain UIImage or error
    static func fetchPosterFor(media: Media, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let posterBaseURL = posterBaseURL else {return completion(.failure(.invalidURL))}
        guard let posterPath = media.posterPath else {return completion(.failure(.invalidURL))}
        let finalURL = posterBaseURL.appendingPathComponent(posterPath)
        //if image is in cache complete else use datatask to fetch image
        if let poster = imageCache.object(forKey: NSURL(string: finalURL.absoluteString) ?? NSURL()) {
            completion(.success(poster))
        } else {
            URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
                if let error = error {
                    print("======== ERROR ========")
                    print("Function: \(#function)")
                    print("Error: \(error)")
                    print("Description: \(error.localizedDescription)")
                    print("======== ERROR ========")
                    return completion(.failure(.thrownError(error)))
                }
                
                guard let data = data else {return completion(.failure(.noData))}
                guard let poster = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
                //save the poster to the cache
                imageCache.setObject(poster, forKey: NSURL(string: finalURL.absoluteString) ?? NSURL())

                completion(.success(poster))
            }.resume()
        }
    }//end of func
    
    static func fetchBackdropImageFor(media: Media, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let posterBaseURL = posterBaseURL else {return completion(.failure(.invalidURL))}
        guard let posterPath = media.backDropPath else {return completion(.failure(.invalidURL))}
        let finalURL = posterBaseURL.appendingPathComponent(posterPath)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("======== ERROR ========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("======== ERROR ========")
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            guard let poster = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            completion(.success(poster))
        }.resume()
    }//end of func
}//end class
