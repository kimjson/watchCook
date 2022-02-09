//
//  DataController.swift
//  watchCook
//
//  Created by jaeseong on 2022/02/08.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentCloudKitContainer(name: "Model")
    
    init() {
        // Only initialize the schema when building the app with the
        // Debug build configuration.
        #if DEBUG
        do {
            // Use the container to initialize the development schema.
            try container.initializeCloudKitSchema(options: [])
        } catch {
            // Handle any errors.
        }
        #endif
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        try? container.viewContext.setQueryGenerationFrom(.current)
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
