//
//  MediaService+ProvidersByCountryCode.swift
//  uStream
//
//  Created by stanley phillips on 4/13/21.
//

import Foundation

extension MediaService {
    func getProvidersByCountryCode(providers: WhereToWatch) -> Option? {
        let countryCode = UserDefaults.standard.string(forKey: "countryCode")
        
        switch countryCode {
        case "US":
            guard let results = providers.results.unitedStates else {return nil}
            return results
        case "CA":
            guard let results = providers.results.canada else {return nil}
            return results
        case "MX":
            guard let results = providers.results.mexico else {return nil}
            return results
        case "PE":
            guard let results = providers.results.peru else {return nil}
            return results
        case "CL":
            guard let results = providers.results.chile else {return nil}
            return results
        case "AR":
            guard let results = providers.results.argentina else {return nil}
            return results
        case "BR":
            guard let results = providers.results.brazil else {return nil}
            return results
        case "CO":
            guard let results = providers.results.colombia else {return nil}
            return results
        case "JP":
            guard let results = providers.results.japan else {return nil}
            return results
        case "TH":
            guard let results = providers.results.thailand else {return nil}
            return results
        case "KR":
            guard let results = providers.results.southKorea else {return nil}
            return results
        case "IN":
            guard let results = providers.results.india else {return nil}
            return results
        case "GB":
            guard let results = providers.results.unitedKingdom else {return nil}
            return results
        case "ES":
            guard let results = providers.results.spain else {return nil}
            return results
        case "FR":
            guard let results = providers.results.france else {return nil}
            return results
        case "BE":
            guard let results = providers.results.belgium else {return nil}
            return results
        case "DE":
            guard let results = providers.results.germany else {return nil}
            return results
        case "ZA":
            guard let results = providers.results.southAfrica else {return nil}
            return results
        case "AU":
            guard let results = providers.results.australia else {return nil}
            return results
        case "NZ":
            guard let results = providers.results.newZealand else {return nil}
            return results
        default:
            guard let results = providers.results.unitedStates else {return nil}
            return results
        }
    }
}
