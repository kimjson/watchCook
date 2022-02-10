//
//  DataController.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/08.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    // MARK: static properties
    
    static var shared = DataController()

    static var preview: DataController = {
        var result = DataController(inMemory: true)
        let viewContext = result.container.viewContext
        
        do {
            for i in 0 ..< 10 {
                let newRecipe: Recipe = Recipe.randomInstance(context: viewContext)
            }
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result

    }()
    
    // MARK: instance properties
    
    lazy var container: NSPersistentContainer = {
        let container = inMemory ? NSPersistentContainer(name: "Model") : NSPersistentCloudKitContainer(name: "Model")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        
        if inMemory {
            description.type = NSInMemoryStoreType
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        try? container.viewContext.setQueryGenerationFrom(.current)
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    let inMemory: Bool
    
    // MARK: init method
    
    init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }
}
