//
//  WhereToWatchController.swift
//  uStream
//
//  Created by stanley phillips on 2/23/21.
//

import Foundation

import UIKit

//base urlhttps://api.themoviedb.org/
//image urlhttp://image.tmdb.org/t/p/w500/(imageEndpoint)
//api_key = 48bcdd5f1ad8e7b88756b97c0c6c3c74
//example URL https://api.themoviedb.org/3/tv/1396/watch/providers?api_key=48bcdd5f1ad8e7b88756b97c0c6c3c74

class WhereToWatchController {
    // MARK: - String Constants
    static let baseURL = URL(string: "https://api.themoviedb.org/")
    static let versionComponent = "3"
    static let tvComponent = "tv"
    static let movieComponent = "movie"
    static let watchComponent = "watch"
    static let providersComponent = "providers"
    static let apiKey = "48bcdd5f1ad8e7b88756b97c0c6c3c74"

    // MARK: - Properties
    static var imageCache = NSCache<NSURL, UIImage>()
    
    // MARK: - Methods
    static func fetchWhereToWatchBy(id: Int, mediaType: String, completion: @escaping (Result<Option, NetworkError>) -> Void) {
        let countryCode = UserDefaults.standard.string(forKey: "countryCode")
        
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let mediaURL = versionURL.appendingPathComponent(mediaType)
        let showURL = mediaURL.appendingPathComponent("\(id)")
        let watchURL = showURL.appendingPathComponent(watchComponent)
        let providersURL = watchURL.appendingPathComponent(providersComponent)
        
        var components = URLComponents(url: providersURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: "api_key", value: apiKey)
        
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if let error = error {
                print("Error: \(error)\nFunction: \(#function)\nDescription: \(error.localizedDescription)")
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("WHERE TO WATCH RESULTS STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            do {
                let whereToWatch = try JSONDecoder().decode(WhereToWatch.self, from: data)
                switch countryCode {
                case "US":
                    guard let results = whereToWatch.results.unitedStates else {return}
                    return completion(.success(results))
                case "PE":
                    guard let results = whereToWatch.results.peru else {return}
                    return completion(.success(results))
                default:
                    guard let results = whereToWatch.results.unitedStates else {return}
                    return completion(.success(results))
                }
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }//end func
}//end class
