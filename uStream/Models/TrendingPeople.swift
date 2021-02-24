//
//  TrendingPeople.swift
//  uStream
//
//  Created by stanley phillips on 2/22/21.
//

import Foundation

struct TrendingPeople: Codable {
    let results: [Person]
}

struct Person: Codable {
    let name: String
    let id: Int
    let mediaType: String
    let profilePath: String?
    let knownFor: [Media]?
    let knownForEmpty: Empty?
    
    enum CodingKeys: String, CodingKey {
        case name, id
        case mediaType = "media_type"
        case profilePath = "profile_path"
        case knownFor, knownForEmpty = "known_for"
    }
}

struct Empty: Codable {
}




