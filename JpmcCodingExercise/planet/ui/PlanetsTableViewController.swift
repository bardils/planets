//
//  PlanetsTableViewController.swift
//  JpmcCodingExercise
//
//  Created by Sarah Rosie on 15/12/2018.
//  Copyright © 2018 Sarah Rosie. All rights reserved.
//

import UIKit
import CoreData

protocol PlanetTableView{
    func display(error: Error)
    func reloadData()
}

/// TableViewController that displays a list Planets from the PlanetStore in alphabetical order.
/// Planets are refreshed when the table view loads
class PlanetsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, PlanetTableView {
    
    private let fetchedResultsController = PlanetModelProvider.shared.planetStore.allPlanetsOrderedByNameFetchedResultsController(inContext: PlanetModelProvider.shared.planetStore.persistentContainer.viewContext)

    private var planetTableViewPresenter: PlanetTableViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planetTableViewPresenter = PlanetTableViewPresenter(planetTableView: self, planetDownloader: PlanetModelProvider.shared.planetDownloader, fetchedResultsController: fetchedResultsController)
        planetTableViewPresenter.viewLoaded()

    }
    
    // MARK: PlanetTableView
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func display(error: Error){
        // TODO: localise strings
        DispatchQueue.main.async {
            [weak self] in
            let alertController = UIAlertController(title: nil, message: "Unable to update planets.\n\(error.localizedDescription)", preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { _ in
                alertController.dismiss(animated: true, completion: nil)
            }))
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanetTableViewCell", for: indexPath)
        cell.textLabel?.text = fetchedResultsController.fetchedObjects?[indexPath.row].name
        return cell
    }
}


