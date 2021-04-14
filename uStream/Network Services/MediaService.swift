//
//  MediaService.swift
//  uStream
//
//  Created by stanley phillips on 4/10/21.
//

import Foundation
//trending urlhttps://api.themoviedb.org/3/trending/all/day?api_key=48bcdd5f1ad8e7b88756b97c0c6c3c74
//upcoming urlhttps://api.themoviedb.org/3/movie/upcoming?api_key=48bcdd5f1ad8e7b88756b97c0c6c3c74&language=en-US&page=1&region=US

//search urlhttps://api.themoviedb.org/3/search/multi?api_key=48bcdd5f1ad8e7b88756b97c0c6c3c74&query=game%20of%20thrones

//similar urlhttps://api.themoviedb.org/3/movie/603/similar?api_key=48bcdd5f1ad8e7b88756b97c0c6c3c74&language=en-US&page=1

//example URL https://api.themoviedb.org/3/tv/1396/watch/providers?api_key=48bcdd5f1ad8e7b88756b97c0c6c3c74

//discover drama https://api.themoviedb.org/3/discover/movie?api_key=48bcdd5f1ad8e7b88756b97c0c6c3c74&with_genres=18&sort_by=vote_average.desc&vote_count.gte=100


enum MediaEndPoint {
    static let baseURL = "https://api.themoviedb.org/3"
    static let apiKey = "48bcdd5f1ad8e7b88756b97c0c6c3c74"

    case trending(String, page: Int)
    case whereToWatch(String, Int)
    case upcomingMovie(page: Int)
    case similar(String, Int)
    case search(String)
    
    var path: String {
        switch self {
        case .trending(let mediaType, _):
            return "trending/\(mediaType)/day"
        case .whereToWatch(let mediaType, let id):
            return "\(mediaType)/\(id)/watch/providers"
        case .upcomingMovie(_):
            return "movie/upcoming"
        case .similar(let mediaType, let id):
            return "\(mediaType)/\(id)/similar"
        case .search(_):
            return "search/multi"
        }
    }
    
    var queryItems: [URLQueryItem] {
        var items = [
            URLQueryItem(name: "api_key", value: MediaEndPoint.apiKey),
        ]
        switch self {
        case .trending(_, let page):
            items.append(URLQueryItem(name: "page", value: String(page)))
            return items
        case .whereToWatch(_, _):
            return items
        case .upcomingMovie(let page):
            items.append(URLQueryItem(name: "language", value: "en-US"))
            items.append(URLQueryItem(name: "region", value: "US"))
            items.append(URLQueryItem(name: "page", value: String(page)))
            return items
        case .similar(_, _):
            return items
        case .search(let searchTerm):
            items.append(URLQueryItem(name: "include_adult", value: "false"))
            items.append(URLQueryItem(name: "query", value: searchTerm))
            return items
        }
    }
    
    var url: URL? {
        guard var url = URL(string: MediaEndPoint.baseURL) else { return nil }
        url.appendPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        return components?.url
    }
}

struct MediaService: NetworkServicing {
    func fetch<T: Decodable>(_ endpoint: MediaEndPoint, completion: @escaping (Result<T, NetError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.badURL))
            return
        }
        print(url.absoluteString)
        perform(urlRequest: URLRequest(url: url)) { result in
            switch result {
            case .success(let data):
                guard let decodedObjects = data.decode(type: T.self) else {
                    completion(.failure(.couldNotUnwrap))
                    return
                }
                completion(.success(decodedObjects))
            case .failure(let error):
                completion(.failure(.badRequest(error)))
            }
        }
    }
    
    func fetchProviders(_ endpoint: MediaEndPoint, completion: @escaping (Result<Option, NetError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.badURL))
            return
        }
        
        print(url.absoluteString)
        perform(urlRequest: URLRequest(url: url)) { result in
            switch result {
            case .success(let data):
                guard let providers = data.decode(type: WhereToWatch.self) else {
                    completion(.failure(.couldNotUnwrap))
                    return
                }
                
                guard let results = getProvidersByCountryCode(providers: providers) else {
                    completion(.failure(.couldNotUnwrap))
                    return
                }
                
                completion(.success(results))

            case .failure(let error):
                completion(.failure(.badRequest(error)))
            }
        }
    }
}
