//
//  PlanetListResponseProcessor.swift
//  JpmcCodingExercise
//
//  Created by Sarah Rosie on 15/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//
import Foundation
import CoreData

/// Processes a response to a PlanetRestCall by storing in the PlanetStore
class PlanetListResponseProcessor{
    
    /// The result of the process request
    ///
    /// - success: the storage was successful
    /// - failure: the storage failed with an Error
    enum ProcessorResult{
        case success()
        case failure(Error)
    }
    
    private let planetStore: PlanetStore
    private let context: NSManagedObjectContext
    
    init(planetStore: PlanetStore, context: NSManagedObjectContext? = nil) {
        self.planetStore = planetStore
        self.context = context ??  planetStore.persistentContainer.newBackgroundContext()
    }
    
    /// Process the response and stores in the PlanetStore if possible
    ///
    /// - Parameter planetListResponse:
    /// - Returns: the result of the process
    func process(planetListResponse: PlanetListResponse)-> ProcessorResult {
        
        var result = ProcessorResult.success()
        
        context.performAndWait {
            do{
                try planetStore.createPlanetsIfRequired(withPlanetResponses: planetListResponse.results, inContext: context)
            }
            catch {
                result = .failure(error)
            }
        }
        do{
            try planetStore.save(inContext: context)
        }
        catch {
            result = .failure(error)
        }
        return result
    }
}
