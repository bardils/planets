//
//  PlanetTableViewPresenterTests.swift
//  JpmcCodingExerciseTests
//
//  Created by Sarah Rosie on 16/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import XCTest
import CoreData
@testable import JpmcCodingExercise

class PlanetTableViewPresenterTests: PlanetStoreTestsBase {
    
    private var mockPlanetListParser: MockPlanetListParser!
    private var mockPlanetRestCall: MockPlanetRestCall!
    private var mockPlanetDownloader: MockPlanetDownloader!
    private var mockPlanetListProcessor: MockPlanetListResponseProcessor!
    private var mockPlanetStore: MockPlanetStore!
    private var mockPlanetTableView: MockPlanetTableView!
    private var mockFetchedResultsController: MockFetchedResultsController!
    
    private var planetTableViewPresenter: PlanetTableViewPresenter!
    
    override func setUp() {
        mockPlanetListParser = MockPlanetListParser()
        mockPlanetRestCall = MockPlanetRestCall(planetListParser: mockPlanetListParser)
        mockPlanetStore = MockPlanetStore(persistentContainer: mockPersistentContainer)
        mockPlanetListProcessor = MockPlanetListResponseProcessor(planetStore: mockPlanetStore)
        mockPlanetDownloader = MockPlanetDownloader(planetRestCall: mockPlanetRestCall, planetProcessor: mockPlanetListProcessor)
        mockPlanetTableView = MockPlanetTableView()
        mockFetchedResultsController = MockFetchedResultsController()
        planetTableViewPresenter = PlanetTableViewPresenter(planetTableView: mockPlanetTableView, planetDownloader: mockPlanetDownloader, fetchedResultsController: mockFetchedResultsController)
    }

    // MARK: tests
    
    func testFetchesAndStoresPlanetsWhenViewIsLoaded() {
      planetTableViewPresenter.viewLoaded()
        XCTAssertTrue(mockPlanetDownloader.fetchedAndStored)
    }

    func testFetchesPlanetsFromStoreWhenViewIsLoaded() {
        planetTableViewPresenter.viewLoaded()
        XCTAssertTrue(mockFetchedResultsController.performedFetch)
    }
    
    func testDisplaysErrorIfFetchOfPlanetsFromStoreThrows(){
        mockFetchedResultsController.fetchError = MockFetchedResultsController.fakeFetchError
        planetTableViewPresenter.viewLoaded()
        XCTAssertTrue(mockPlanetTableView.errorDisplayed)
    }
    
    func testDisplaysErrorIfPlanetDownloadFails(){
        mockPlanetDownloader.error = MockPlanetDownloader.fakeError
        planetTableViewPresenter.viewLoaded()
        XCTAssertTrue(mockPlanetTableView.errorDisplayed)
    }
    
}
