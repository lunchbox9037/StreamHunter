//
//  Trending.swift
//  uStream
//
//  Created by stanley phillips on 2/18/21.
//

import Foundation

struct TrendingMedia: Codable {
    let results: [Media]
}

struct Media: Codable {
    let title: String?
    let name: String?
    let mediaType: String?
    let overview: String?
    let releaseDate: String?
    let firstAirDate: String?
    let voteAverage: Double?
    let popularity: Double?
    let posterPath: String?
    let backDropPath: String?
    let id: Int?
 
    enum CodingKeys: String, CodingKey {
        case overview, id, title, popularity, name
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case backDropPath = "backdrop_path"
        case mediaType = "media_type"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
    }
}

