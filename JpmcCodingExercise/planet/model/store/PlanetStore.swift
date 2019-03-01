//
//  PlanetCoreDataStore.swift
//  JpmcCodingExercise
//
//  Created by Sarah Rosie on 15/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//
import CoreData

import Foundation


/// Errors which can occur when using the PlanetStore
///
/// - dataIntegrity: the database is in an invalid state
/// - fetch: an error occurred when fetching data
/// - invalidData: the data being stored is invalid
/// - save: an error occurred when saving the data
enum PlanetStoreError : Error{
    case dataIntegrity(String)
    case fetch(Error)
    case invalidData(String)
    case save(Error)
}

/// A core data store for planets
class PlanetStore{
    
    let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    // MARK: Create
    
    /// Creates planets which do not already exist in the store
    /// - Important: this function does not save the core data context. A separate call to save() should be made to do this.
    ///
    /// - Parameters:
    ///   - planetResponses: the responses from the API used to create Planets in the store
    ///   - context: the managed object context to store the data in
    /// - Throws: a PlanetStoreError if an error occurs when trying to access Planets in the store
    func createPlanetsIfRequired(withPlanetResponses planetResponses: [PlanetResponse], inContext context: NSManagedObjectContext) throws{
        for planetResponse in planetResponses{
            try createPlanetIfRequired(withPlanetResponse: planetResponse, inContext: context)
        }
    }
    
    private func createPlanetIfRequired(withPlanetResponse planetResponse: PlanetResponse, inContext context: NSManagedObjectContext) throws{
        let existingPlanet = try fetchPlanet(withName: planetResponse.name, inContext: context)
        if existingPlanet == nil {
            try createPlanet(withPlanetResponse: planetResponse, inContext: context)
        }
    }
    
    private func createPlanet(withPlanetResponse planetResponse: PlanetResponse, inContext context:NSManagedObjectContext) throws{
        guard !planetResponse.name.isEmpty else {
            throw PlanetStoreError.invalidData("Planet name should not be empty")
        }
        
        let planet = Planet(context: context)
        planet.name = planetResponse.name
    }
    
    // MARK: Read
    
    private static let findPlanetByNamePredicate = NSPredicate(format: "name == $name")
    
    private func fetchPlanet(withName name: String, inContext context:NSManagedObjectContext) throws ->Planet?{
        let fetchRequest : NSFetchRequest<Planet> = Planet.fetchRequest()
        fetchRequest.predicate = PlanetStore.findPlanetByNamePredicate.withSubstitutionVariables(["name": name])
        
        do {
            let results = try  context.fetch(fetchRequest)
            
            guard results.count <= 1 else { throw PlanetStoreError.dataIntegrity("There should only be one planet with this name but instead there are \(results.count)") }
            
            if !results.isEmpty {
                return results.first
            }
        } catch {
            throw PlanetStoreError.fetch(error)
        }
        return nil
    }
    
    // MARK: Save
    
    /// Saves the managed object context if possible
    ///
    /// - Parameter context: the managed object context to save
    /// - Throws: a PlanetStore save error if an error occurs when saving
    func save(inContext context: NSManagedObjectContext) throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw PlanetStoreError.save(error)
            }
        }
    }
    
    // MARK: Fetched Result Controllers
    
    /// A fetched results controller which fetches all planets ordered by name
    ///
    /// - Parameter context: the managed object context to fetch the planets from
    /// - Returns: a FetchedResultsController for the planets
    func allPlanetsOrderedByNameFetchedResultsController(inContext context: NSManagedObjectContext)->NSFetchedResultsController<Planet>{
        
        let fetchRequest : NSFetchRequest<Planet> = Planet.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Planet.name), ascending: true)]
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: context,
                                          sectionNameKeyPath: nil, cacheName: nil)
    }
}

