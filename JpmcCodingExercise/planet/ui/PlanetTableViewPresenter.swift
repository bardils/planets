//
//  PlanetTableViewPresenter.swift
//  JpmcCodingExercise
//
//  Created by Sarah Rosie on 16/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import Foundation
import CoreData

/// Presenter which manages the view logic for the PlanetsTableViewControlelr
class PlanetTableViewPresenter : NSObject, NSFetchedResultsControllerDelegate {
    
    private let planetTableView: PlanetTableView
    private let planetDownloader: PlanetDownloader
    private let fetchedResultsController: NSFetchedResultsController<Planet>
    
    init(planetTableView: PlanetTableView, planetDownloader: PlanetDownloader, fetchedResultsController: NSFetchedResultsController<Planet>){
        self.planetTableView = planetTableView
        self.planetDownloader = planetDownloader
        self.fetchedResultsController = fetchedResultsController
    }
    
    /// Call when the view is loaded. Refreshes the planets and sets up the fetched results controller, handling any errors which occur
    func viewLoaded(){
        planetDownloader.fetchAndStorePlanets {
            [weak self] result in
            if case .failure(let error) = result {
                self?.planetTableView.display(error: error)
            }
        }
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch{
            planetTableView.display(error: error)
        }
    }
}

extension PlanetTableViewPresenter {
    
    /// Called when the fetched results controller content changes. Requests that the view reloads its data.
    ///
    /// - Parameter controller: the fetched results controller whose content changed
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        planetTableView.reloadData()
    }
}
