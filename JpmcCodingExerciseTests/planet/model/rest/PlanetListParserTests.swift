//
//  PlanetListParserTests.swift
//  JpmcCodingExerciseTests
//
//  Created by Sarah Rosie on 15/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import Foundation
import XCTest

@testable import JpmcCodingExercise

class PlanetListParserTests: XCTestCase {
    
    // MARK: tests
    
    func testDecodesDataWhenNotNil() {
        let parser = PlanetRestCall.PlanetListParser(jsonDecoder: MockJsonDecoder())
        let actual = try? parser.parse(data: Data())
        XCTAssertEqual(MockJsonDecoder.decodedData, actual)
    }
    
    func testThrowsNoDataErrorWhenDataIsNil() {
        let parser = PlanetRestCall.PlanetListParser(jsonDecoder: MockJsonDecoder())
        XCTAssertThrowsError(try parser.parse(data: nil)){ error in
            guard case PlanetRestCall.PlanetRestCallError.noData = error else {
                return XCTFail()
            }
        }
    }
    
    func testDecodesValidJsonIntoPlanetResponseList(){
        
        let path = Bundle(for: type(of: self)).path(forResource: "validPlanetResponse", ofType: "json")!
        let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let parser = PlanetRestCall.PlanetListParser()
        let actual = try? parser.parse(data: data)
        let expected = PlanetListResponse(results: [PlanetResponse(name:"Alderaan"), PlanetResponse(name:"Yavin IV")])
        XCTAssertEqual(expected, actual)
    }
    
}
