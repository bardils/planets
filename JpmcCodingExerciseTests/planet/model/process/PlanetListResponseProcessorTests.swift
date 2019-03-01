//
//  PlanetListResponseProcessorTests.swift
//  JpmcCodingExerciseTests
//
//  Created by Sarah Rosie on 16/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import XCTest
import CoreData

@testable import JpmcCodingExercise

class PlanetListResponseProcessorTests: PlanetStoreTestsBase {
    
    private var mockPlanetStore: MockPlanetStore!
    private var mockContext: MockNSManagedObjectContext!
    private var processor: PlanetListResponseProcessor!
    
    private let fakePlanetListResponse = PlanetListResponse(results: [PlanetResponse(name:"Alderaan"), PlanetResponse(name:"Yavin IV")])
    
    override func setUp() {
        super.setUp()
        mockContext = MockNSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mockPlanetStore = MockPlanetStore(persistentContainer: mockPersistentContainer)
        processor = PlanetListResponseProcessor(planetStore: mockPlanetStore, context: mockContext)
    }
    
    // MARK: tests
    
    func testCreatesPlanetsIfRequired() {
        processor.process(planetListResponse: fakePlanetListResponse)
        XCTAssertTrue(mockPlanetStore.planetsCreatedIfRequired)
    }
    
    func testProcessIsSuccessfulIfPlanetStoreDoesNotThrow() {
        let actual = processor.process(planetListResponse: fakePlanetListResponse)
        guard case PlanetListResponseProcessor.ProcessorResult.success() = actual else{ return XCTFail()}
    }
    
    func testProcessSavesPlanetToStore() {
        processor.process(planetListResponse: fakePlanetListResponse)
        XCTAssertTrue(mockPlanetStore.saved)
    }
    
    func testProcessFailsIfCreatingPlanetsThrows(){
        mockPlanetStore.createPlanetsError = MockPlanetStore.FakeError.createPlanet
        let actual = processor.process(planetListResponse: fakePlanetListResponse)
        guard case PlanetListResponseProcessor.ProcessorResult.failure(MockPlanetStore.FakeError.createPlanet) = actual else{ return XCTFail()}
    }
    
    func testProcessFailsIfSavingPlanetsThrows(){
        mockPlanetStore.savePlanetsError = MockPlanetStore.FakeError.save
        let actual = processor.process(planetListResponse: fakePlanetListResponse)
        guard case PlanetListResponseProcessor.ProcessorResult.failure(MockPlanetStore.FakeError.save) = actual else{ return XCTFail()}
    }
    
}
