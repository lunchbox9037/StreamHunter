//
//  LocationController.swift
//  uStream
//
//  Created by stanley phillips on 3/4/21.
//

import CoreData

class LocationController {
    static let shared = LocationController()
    //fix this tomorrow!!
    func updateLocation(countryCode: String) {
        let fetchRequest: NSFetchRequest<Location> = {
            let request = NSFetchRequest<Location>(entityName: "Location")
            request.predicate = NSPredicate(value: true)
            return request
        }()
        
        let currentLocation = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        currentLocation.first?.setValue(countryCode, forKey: "countryCode")
        print(currentLocation.first?.countryCode as Any)
        CoreDataStack.saveContext()
    }
}
