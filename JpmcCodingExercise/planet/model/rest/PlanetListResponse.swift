//
//  PlanetListResponse.swift
//  JpmcCodingExercise
//
//  Created by Sarah Rosie on 15/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import Foundation

/// Represents the list of Planets in the response ot a PlanetRestCall
///  - Important: for efficiency, only fields required for this app are included. Please refer to PlanetRestCall api for a full list of fields if needed
struct PlanetListResponse : Codable, Equatable{
    let results : Array<PlanetResponse>
}

struct PlanetResponse: Codable, Equatable{
    let name: String
}
