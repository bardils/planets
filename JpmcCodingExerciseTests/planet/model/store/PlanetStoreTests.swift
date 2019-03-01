//
//  PlanetStoreTests.swift
//  JpmcCodingExerciseTests
//
//  Created by Sarah Rosie on 16/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import XCTest
import CoreData

@testable import JpmcCodingExercise

class PlanetStoreTests: PlanetStoreTestsBase {
    
    private var planetStore: PlanetStore!
    
    override func setUp() {
        super.setUp()
        planetStore = PlanetStore(persistentContainer: mockPersistentContainer)
    }
    
    // MARK: tests
    
    func testCreatesPlanetsFromPopulatedPlanetResponses(){
        let fakePlanetResponses = [PlanetResponse(name:"Planet1"), PlanetResponse(name: "Planet2")]
        
        try? planetStore.createPlanetsIfRequired(withPlanetResponses: fakePlanetResponses, inContext: mockPersistentContainer.viewContext)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Planet")
        let planets = try? mockPersistentContainer.viewContext.fetch(fetchRequest)
        XCTAssertTrue(planets?.count == 2)
    }
    
    func testSavesPlanets(){
        let fakePlanetResponses = [PlanetResponse(name:"Planet1"), PlanetResponse(name: "Planet2")]
        
        try? planetStore.createPlanetsIfRequired(withPlanetResponses: fakePlanetResponses, inContext: mockPersistentContainer.viewContext)
        
        try? planetStore.save(inContext: mockPersistentContainer.viewContext)
        
        XCTAssertFalse(mockPersistentContainer.viewContext.hasChanges)
    }
    
    func testDoesNotCreatePlanetsThatHaveAlreadyBeenCreated(){
        let fakePlanetResponses = [PlanetResponse(name:"Planet1"), PlanetResponse(name: "Planet2")]
        
        try? planetStore.createPlanetsIfRequired(withPlanetResponses: fakePlanetResponses, inContext: mockPersistentContainer.viewContext)
        
        try? planetStore.save(inContext: mockPersistentContainer.viewContext)
        
        try? planetStore.createPlanetsIfRequired(withPlanetResponses: fakePlanetResponses, inContext: mockPersistentContainer.viewContext)
        
        XCTAssertFalse(mockPersistentContainer.viewContext.hasChanges)
    }
    
    func testFetchedResultsControllerReturnsPlanetsOrderedByName(){
        let fakePlanetResponses = [PlanetResponse(name:"Alpha"), PlanetResponse(name:"Charlie"), PlanetResponse(name: "Bravo")]
        
        try? planetStore.createPlanetsIfRequired(withPlanetResponses: fakePlanetResponses, inContext: mockPersistentContainer.viewContext)
        
        try? planetStore.save(inContext: mockPersistentContainer.viewContext)
        
        let frc = planetStore.allPlanetsOrderedByNameFetchedResultsController(inContext: mockPersistentContainer.viewContext)
        
        try? frc.performFetch()
        let planets = frc.fetchedObjects
        
        let actualNames = planets!.map{$0.name}
        let expectedNames = ["Alpha", "Bravo", "Charlie"]
        
        XCTAssertEqual(expectedNames, actualNames)
    }
    
}
