//
//  PlanetStoreTestsBase.swift
//  JpmcCodingExerciseTests
//
//  Created by Sarah Rosie on 16/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import XCTest
import CoreData

class PlanetStoreTestsBase: XCTestCase {
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main] )!
        
        let container = NSPersistentContainer(name: "Planets", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )
            
            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    override func tearDown() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Planet")
        let planets = try! mockPersistentContainer.viewContext.fetch(fetchRequest)
        for case let planet as NSManagedObject in planets {
            mockPersistentContainer.viewContext.delete(planet)
        }
        try! mockPersistentContainer.viewContext.save()
    }

}
