//
//  TrendingPeopleController.swift
//  uStream
//
//  Created by stanley phillips on 2/22/21.
//

import UIKit

//base urlhttps://api.themoviedb.org/
//image urlhttp://image.tmdb.org/t/p/w500/(imageEndpoint)
//https://api.themoviedb.org/3/trending/all/day?api_key=48bcdd5f1ad8e7b88756b97c0c6c3c74

class TrendingPeopleController {
    // MARK: - String Constants
    static let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w500/")
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
    static func fetchTrendingPeople(completion: @escaping (Result<[Person], NetworkError>) -> Void) {
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let trendingURL = versionURL.appendingPathComponent(trendingComponent)
        let peopleURL = trendingURL.appendingPathComponent(personComponent)
        let dayURL = peopleURL.appendingPathComponent(dayComponent)
        
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
                print("TRENDING PEOPLE STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            do {
                let trending = try JSONDecoder().decode(TrendingPeople.self, from: data)
                var people: [Person] = []
                
                for person in trending.results {
                    people.append(person)
                }
                return completion(.success(people))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }//end func
    
    static func fetchPosterFor(person: Person, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let imageBaseURL = imageBaseURL else {return completion(.failure(.invalidURL))}
        guard let profilePath = person.profilePath else {return completion(.failure(.invalidURL))}
        let finalURL = imageBaseURL.appendingPathComponent(profilePath)
        
        if let image = imageCache.object(forKey: NSURL(string: finalURL.absoluteString) ?? NSURL()) {
            print("cached")
            completion(.success(image))
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
                guard let profileImage = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
                //save image to cache
                imageCache.setObject(profileImage, forKey: NSURL(string: finalURL.absoluteString) ?? NSURL())

                completion(.success(profileImage))
            }.resume()
        }
    }//end of func
}//end class
