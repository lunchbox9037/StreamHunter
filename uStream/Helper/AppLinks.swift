//
//  AppLinks.swift
//  uStream
//
//  Created by stanley phillips on 3/3/21.
//

import UIKit

class AppLinks {
    //need to test more when requested app is not installed
    static let netflixURL = "nflx://www.netflix.com/" //working ✅
    static let netflixID =  "id363590051"
    static let appleTVPlusURL = "https://tv.apple.com" //working ✅
    static let appleTVPlusID = "id1174078549"
    static let disneyPlusURL = "disneyplus://disneyplus.com/" //working ✅
    static let disneyPlusID = "id1446075923"
    static let huluURL = "hulu://hulu.com/" //working ✅
    static let huluID = "id376510438"
    static let hboMaxURL = "hbomax://www.hbomax.com/" //working ✅
    static let hboMaxID = "id971265422"
    static let amazonPrimeVideoURL = "primevideo://www.primevideo.com/browse" //working ✅
    static let amazonPrimeVideoID = "id545519333"
    static let crunchyRollURL = "crunchyroll://www.crunchyroll.com" // working ✅
    static let crunchyRollID = "id329913454"

    static let supportedApps: [String] = ["Netflix", "Hulu", "Disney Plus", "Apple TV Plus", "HBO Max", "Amazon Prime Video", "Crunchyroll"]
    
    static func getURLFor(providerName: String) -> String {
        switch providerName {
        case "Netflix":
            return netflixURL
        case "Hulu":
            return huluURL
        case "Disney Plus":
            return disneyPlusURL
        case "Apple TV Plus":
            return appleTVPlusURL
        case "HBO Max":
            return hboMaxURL
        case "Amazon Prime Video":
            return amazonPrimeVideoURL
        case "Crunchyroll":
            return crunchyRollURL
        default:
            return "error"
        }
    }
    
    static func getIDfor(providerName: String) -> String {
        switch providerName {
        case "Netflix":
            return netflixID
        case "Hulu":
            return huluID
        case "Disney Plus":
            return disneyPlusID
        case "Apple TV Plus":
            return appleTVPlusID
        case "HBO Max":
            return hboMaxID
        case "Amazon Prime Video":
            return amazonPrimeVideoID
        case "Crunchyroll":
            return crunchyRollID
        default:
            return "error"
        }
    }
}//end class
