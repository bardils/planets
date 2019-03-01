//
//  ModelMockProvider.swift
//  JpmcCodingExerciseTests
//
//  Created by Sarah Rosie on 16/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import Foundation
import CoreData

@testable import JpmcCodingExercise

class MockJsonDecoder : JSONDecoder{
    
    static let decodedData = PlanetListResponse(results: [PlanetResponse(name: "Planet1")])
    
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        return MockJsonDecoder.decodedData as! T
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    private let onResume: () -> Void
    private (set) var cancelled = false
    
    init(onResume: @escaping () -> Void) {
        self.onResume = onResume
    }
    
    override func cancel() {
        cancelled = true
    }
    
    override func resume() {
        onResume()
    }
}

class MockURLSession: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    var data: Data?
    var error: Error?
    var completionHandler: CompletionHandler? = nil
    
    enum FakeNetworkError: Error{
        case failed
    }
    
    static let fakeError = FakeNetworkError.failed
    
    lazy var dataTask: MockURLSessionDataTask = {
        return MockURLSessionDataTask {
            self.completionHandler!(self.data, nil, self.error)
        }
    }()
    
    override func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        self.completionHandler = completionHandler
        return dataTask
    }
}

class MockPlanetListParser: PlanetRestCall.PlanetListParser{
    var error: Error?
    var parsed = false
    
    static let fakePlanetListResponse = PlanetListResponse(results: [PlanetResponse(name: "Planet1"), PlanetResponse(name: "Planet2")])
    
    var planetListResponse: PlanetListResponse
        = MockPlanetListParser.fakePlanetListResponse
    
    override func parse(data: Data?) throws -> PlanetListResponse {
        if (error == nil){
            parsed = true
            return planetListResponse
        }
        else {
            throw error!
            
        }
    }
}


class MockNSManagedObjectContext: NSManagedObjectContext{
    override func performAndWait(_ block: () -> Void) {
        block()
    }
}

class MockPlanetStore: PlanetStore{
    
    enum FakeError: Error{
        case createPlanet
        case save
    }
    
    var saved = false
    var planetsCreatedIfRequired = false
    var createPlanetsError : Error? = nil
    var savePlanetsError: Error? = nil
    
    override func save(inContext context: NSManagedObjectContext) throws {
        if (savePlanetsError == nil){
            saved = true
        } else{
            throw savePlanetsError!
        }
    }
    
    override func createPlanetsIfRequired(withPlanetResponses planetResponses: [PlanetResponse], inContext context: NSManagedObjectContext) throws {
        if (createPlanetsError == nil){
            planetsCreatedIfRequired = true
        } else {
            throw createPlanetsError!
        }
    }
}

class MockPlanetRestCall: PlanetRestCall{
    static let fakePlanetListResponse = PlanetListResponse(results: [PlanetResponse(name: "Planet1"), PlanetResponse(name: "Planet2")])
    var restResult =  RestCallResult<PlanetListResponse>.success(MockPlanetRestCall.fakePlanetListResponse)
    
    override func execute(onCompletion completion: @escaping (PlanetRestCall.RestCallResult<PlanetListResponse>) -> Void) {
        completion(restResult)
    }
}

class MockPlanetListResponseProcessor: PlanetListResponseProcessor{
    
    var processed = false
    
    var processorResult = PlanetListResponseProcessor.ProcessorResult.success()
    
    override func process(planetListResponse: PlanetListResponse) -> PlanetListResponseProcessor.ProcessorResult {
        processed = true
        return processorResult
    }
    
}

class MockPlanetDownloader: PlanetDownloader{
    
    static let fakeError = PlanetRestCall.PlanetRestCallError.noData
    
    var error: Error? = nil
    
    var fetchedAndStored = false
    
    override func fetchAndStorePlanets(onCompletion completion: @escaping (PlanetDownloader.DownloadResult) -> Void) {
        if (error == nil){
            fetchedAndStored = true
        }
        else {
            completion(DownloadResult.failure(error!))
        }
    }
}

class MockFetchedResultsController : NSFetchedResultsController<Planet>{
    
    static let fakeFetchError = PlanetStoreError.invalidData("Fake Error")
    private (set) var performedFetch = false
    var fetchError: Error? = nil
    
    override func performFetch() throws {
        if (fetchError == nil){
            performedFetch = true
        }else {
            throw fetchError!
        }
    }
}
