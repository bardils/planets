//
//  PlanetModelProvider.swift
//  JpmcCodingExercise
//
//  Created by Sarah Rosie on 15/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import Foundation
import UIKit


/// Singleton provider of model objects
class PlanetModelProvider{
    
    static let shared = PlanetModelProvider()
    
    let planetStore: PlanetStore
    let planetDownloader: PlanetDownloader
    
    init() {
        planetStore = PlanetStore(persistentContainer: CoreDataProvider.shared.persistentContainer)
        
        let planetRestCall = PlanetRestCall(planetListParser:PlanetRestCall.PlanetListParser())
        planetDownloader = PlanetDownloader(planetRestCall: planetRestCall,
                                            planetProcessor: PlanetListResponseProcessor(planetStore: planetStore))
    }
}
