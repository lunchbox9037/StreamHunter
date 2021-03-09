//
//  CoreDataStack.swift
//  uStream
//
//  Created by stanley phillips on 2/18/21.
//

import CoreData

enum CoreDataStack {
    static let container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "uStream")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error loading persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    static var context: NSManagedObjectContext {container.viewContext}
    
    static func saveContext() {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}
