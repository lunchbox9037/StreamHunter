//
//  Location+Convenience.swift
//  uStream
//
//  Created by stanley phillips on 3/4/21.
//

import CoreData

extension Location {
    @discardableResult convenience init(countryCode: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.countryCode = countryCode
    }
}
