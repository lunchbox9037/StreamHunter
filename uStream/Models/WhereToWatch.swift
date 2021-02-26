//
//  WhereToWatch.swift
//  uStream
//
//  Created by stanley phillips on 2/23/21.
//

import Foundation

struct WhereToWatch: Codable {
    let id: Int
    let results: Locale
}

struct Locale: Codable {
    let location: Option
    
    enum CodingKeys: String, CodingKey {
        case location = "US"
    }
}

struct Option: Codable {
    let deepLink: String
    let streaming: [Provider]
    
    enum CodingKeys: String, CodingKey {
        case streaming = "flatrate"
        case deepLink = "link"
    }
}

struct Provider: Codable {
    let providerName: String
    let logo: String?
    
    enum CodingKeys: String, CodingKey {
        case providerName = "provider_name"
        case logo = "logo_path"
    }
}
