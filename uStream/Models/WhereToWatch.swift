//
//  WhereToWatch.swift
//  uStream
//
//  Created by stanley phillips on 2/23/21.
//

import Foundation

struct WhereToWatch: Codable {
    let id: Int
    let results: Country
}

struct Country: Codable {
    let unitedStates: Option?
    let canada: Option?
    let mexico: Option?
    let peru: Option?
    let chile: Option?
    let argentina: Option?
    let brazil: Option?
    let colombia: Option?
    let japan: Option?
    let thailand: Option?
    let southKorea: Option?
    let india: Option?
    let unitedKingdom: Option?
    let spain: Option?
    let france: Option?
    let belgium: Option?
    let germany: Option?
    let southAfrica: Option?
    let australia: Option?
    let newZealand: Option?
    
    enum CodingKeys: String, CodingKey {
        case unitedStates = "US"
        case canada = "CA"
        case mexico = "MX"
        case peru = "PE"
        case chile = "CL"
        case argentina = "AR"
        case brazil = "BR"
        case colombia = "CO"
        case japan = "JP"
        case thailand = "TH"
        case southKorea = "KR"
        case india = "IN"
        case unitedKingdom = "GB"
        case spain = "ES"
        case france = "FR"
        case belgium = "BE"
        case germany = "DE"
        case southAfrica = "ZA"
        case australia = "AU"
        case newZealand = "NZ"
    }
}

struct Option: Codable {
    let deepLink: String
    let streaming: [Provider]?
    
    enum CodingKeys: String, CodingKey {
        case streaming = "flatrate"
        case deepLink = "link"
    }
}

struct Provider: Codable {
    let providerName: String?
    let logo: String?
    
    enum CodingKeys: String, CodingKey {
        case providerName = "provider_name"
        case logo = "logo_path"
    }
}
