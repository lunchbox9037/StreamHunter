//
//  Media.swift
//  uStream
//
//  Created by stanley phillips on 3/2/21.
//

import Foundation

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
    let backdropPath: String?
    let id: Int?
 
    enum CodingKeys: String, CodingKey {
        case overview, id, title, popularity, name
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case mediaType = "media_type"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
    }
}
