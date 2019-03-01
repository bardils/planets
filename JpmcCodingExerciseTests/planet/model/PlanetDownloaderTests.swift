//
//  PlanetDownloaderTests.swift
//  JpmcCodingExerciseTests
//
//  Created by Sarah Rosie on 16/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import XCTest
@testable import JpmcCodingExercise

class PlanetDownloaderTests: PlanetStoreTestsBase {
    
    private var mockPlanetRestCall: MockPlanetRestCall!
    private var mockPlanetProcessor: MockPlanetListResponseProcessor!
    private var mockPlanetStore: MockPlanetStore!
    private var mockPlanetListParser: MockPlanetListParser!
    
    private var planetDownloader: PlanetDownloader!
    
    override func setUp() {
        mockPlanetListParser = MockPlanetListParser()
        mockPlanetRestCall = MockPlanetRestCall(planetListParser: mockPlanetListParser)
        mockPlanetStore = MockPlanetStore(persistentContainer: mockPersistentContainer)
        mockPlanetProcessor = MockPlanetListResponseProcessor(planetStore: mockPlanetStore)
        planetDownloader = PlanetDownloader(planetRestCall: mockPlanetRestCall, planetProcessor: mockPlanetProcessor)
    }
    
    // MARK: tests
    
    func testProcessesASuccessfulRestCall() {
        mockPlanetRestCall.restResult = PlanetRestCall.RestCallResult.success(MockPlanetListParser.fakePlanetListResponse)
        planetDownloader.fetchAndStorePlanets {  result in
            XCTAssertTrue(self.mockPlanetProcessor.processed)
        }
    }
    
    func testDownloadFailsIfRestCallFails() {
        mockPlanetRestCall.restResult = PlanetRestCall.RestCallResult.failure(PlanetRestCall.PlanetRestCallError.noData)
        planetDownloader.fetchAndStorePlanets {  result in
            XCTAssertFalse(self.mockPlanetProcessor.processed)
        }
    }
    
    func testDownloadIsSuccessfulIfProcessingIsSuccessful() {
        mockPlanetRestCall.restResult = PlanetRestCall.RestCallResult.success(MockPlanetListParser.fakePlanetListResponse)
        planetDownloader.fetchAndStorePlanets {  result in
            guard case PlanetDownloader.DownloadResult.success() = result else {return XCTFail()}
        }
    }
    
    func testDownloadIsFailureIfProcessingFails() {
        mockPlanetRestCall.restResult = PlanetRestCall.RestCallResult.success(MockPlanetListParser.fakePlanetListResponse)
        mockPlanetProcessor.processorResult = PlanetListResponseProcessor.ProcessorResult.failure(PlanetRestCall.PlanetRestCallError.noData)
        planetDownloader.fetchAndStorePlanets {  result in
            guard case PlanetDownloader.DownloadResult.failure(PlanetRestCall.PlanetRestCallError.noData) = result else {return XCTFail()}
        }
    }
}
