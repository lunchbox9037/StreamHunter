//
//  AppLinks.swift
//  uStream
//
//  Created by stanley phillips on 3/3/21.
//

import UIKit

class AppLinks {
    static let netflixURL = "nflx://www.netflix.com/browse" //working ✅
    static let huluURL = "hulu://hulu.com" //working ✅
    static let hboMaxURL = "hbomax://www.hbomax.com/" //working ✅
    static let amazonPrimeVideoURL = "primevideo://www.primevideo.com/" //working ✅
    static let disneyPlusURL = "disneyplus://disneyplus.com/" //working ✅
    static let appleTVPlusURL = "https://tv.apple.com" //working ✅
    static let crunchyRollURL = "crunchyroll://www.crunchyroll.com" // working ✅

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
    
    static func launchApp(provider: Provider) {
        print("made it")
        guard let providerName = provider.providerName else {return}
        print(providerName)
        let url = AppLinks.getURLFor(providerName: providerName)
        print(url)
        if let appURL = URL(string: url) {
            UIApplication.shared.open(appURL) { success in
                if success {
                    print("The URL was delivered successfully.")
                } else {
                    print("The URL failed to open.")
                }
            }
        } else {
            print("Invalid URL specified.")
        }
    }
}//end class
