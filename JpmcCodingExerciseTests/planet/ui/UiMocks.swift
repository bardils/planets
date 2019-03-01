//
//  UiMocks.swift
//  JpmcCodingExerciseTests
//
//  Created by Sarah Rosie on 16/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import Foundation
@testable import JpmcCodingExercise

class MockPlanetTableView: PlanetTableView{
    
    var errorDisplayed = false
    var dataReloaded = false
    
    func display(error: Error) {
        errorDisplayed = true
    }
    
    func reloadData() {
        dataReloaded = true
    }
}
