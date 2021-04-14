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
    static let fuboURL = "fuboTV://www.fubo.tv/" // working ✅
    static let fuboID = "id905401434"
    static let hooplaURL = "hoopladigital://www.hoopladigital.com" // working ✅
    static let hooplaID = "id580643740"
    static let funimationURL = "https://www.funimation.com" // working ✅
    static let funimationID = "id1075603018"
    static let vrvURL = "vrv://www.vrv.co" // working ✅
    static let vrvID = "id1165206979"
    static let direcTVURL = "directv://www.directv.com" // working ✅
    static let direcTVID = "id307386350"
    static let slingTVURL = "slingtv://www.sling.com" // working ✅
    static let slingTVID = "id945077360"
    
    static let supportedApps: [String] = ["Netflix", "Hulu", "Disney Plus", "Apple TV Plus", "HBO Max", "Amazon Prime Video", "Crunchyroll", "fuboTV", "Hoopla", "Funimation Now", "VRV", "HiDive", "DIRECTV", "Sling TV"]
    
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
        case "fuboTV":
            return fuboURL
        case "Hoopla":
            return hooplaURL
        case "Funimation Now":
            return funimationURL
        case "VRV":
            return vrvURL
        case "DIRECTV":
            return direcTVURL
        case "Sling TV":
            return slingTVURL
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
        case "fuboTV":
            return fuboID
        case "Hoopla":
            return hooplaID
        case "Funimation Now":
            return funimationID
        case "VRV":
            return vrvID
        case "DIRECTV":
            return direcTVID
        case "Sling TV":
            return slingTVID
        default:
            return "error"
        }
    }
}//end class
