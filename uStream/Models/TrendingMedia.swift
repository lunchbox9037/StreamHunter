//
//  Trending.swift
//  uStream
//
//  Created by stanley phillips on 2/18/21.
//

import Foundation

struct TrendingMedia: Codable {
    let page: Int
    let totalPages: Int
    let results: [Media]
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}

