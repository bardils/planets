//
//  PlanetRestCallTests.swift
//  JpmcCodingExerciseTests
//
//  Created by Sarah Rosie on 15/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import XCTest
@testable import JpmcCodingExercise

class PlanetRestCallTests: XCTestCase {
    
    // MARK: setup
    
    private var mockPlanetListParser: MockPlanetListParser!
    private var mockUrlSession: MockURLSession!
    private var restCall: PlanetRestCall!
    
    override func setUp() {
        mockPlanetListParser = MockPlanetListParser()
        mockUrlSession = MockURLSession()
        restCall = PlanetRestCall(planetListParser: mockPlanetListParser, urlSession: mockUrlSession)
    }
    
    // MARK: tests
    
    func testCancelsExistingDataTaskBeforeResuming() {
        let dataTask = self.mockUrlSession.dataTask
        
        restCall.execute { result in
            self.restCall.execute(onCompletion: { result2 in
                XCTAssertTrue(dataTask.cancelled)
            })
        }
    }
    
    func testFailsWithServerErrorIfNoErrorInDataTaskCompletion(){
        mockUrlSession.error = MockURLSession.fakeError
        restCall.execute { result in
            
            let expected = PlanetRestCall.RestCallResult<PlanetListResponse>.failure(MockURLSession.FakeNetworkError.failed)
            
            guard case PlanetRestCall.RestCallResult<PlanetListResponse>.failure( _) = expected else{XCTFail()}
        }
    }
    
    func testParsesPlanetListResponseIfNoErrorInDataTaskCompletion(){
        restCall.execute { result in
            self.restCall.execute(onCompletion: { result2 in
                let expected = PlanetRestCall.RestCallResult<PlanetListResponse>.success(MockPlanetListParser.fakePlanetListResponse)
                
                guard case PlanetRestCall.RestCallResult<PlanetListResponse>.success( _) = expected else{XCTFail()}
            })
        }
    }
    
    func testFailsWithParseErrorIfParserThrows(){
        let fakeError = PlanetRestCall.PlanetRestCallError.noData
        mockPlanetListParser.error = fakeError
        restCall.execute { result in
            
            let expected = PlanetRestCall.RestCallResult<PlanetListResponse>.failure(PlanetRestCall.PlanetRestCallError.parse(error: fakeError))
            
            guard case PlanetRestCall.RestCallResult<PlanetListResponse>.failure( _) = expected else{XCTFail()}
        }
    }
}
