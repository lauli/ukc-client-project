//
//  SavedLocationsViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 15.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

final class SavedLocationsTableViewController: UITableViewController {
    
    private let reuseIdentifier = "savedLocationsCell"
    
    private var locations: [Location] {
        return DataHandler.shared.user?.savedLocations ?? []
    }
    
    private var selectedIndex: IndexPath?
    var selectedLocation: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 135
        tableView.contentInset = UIEdgeInsets(top: -100, left: 0, bottom: 0, right: 0) // bad hack to get rid of space above tableview
        tableView.tableFooterView = UIView(frame: .zero) // set footer so that empty cells aren't shown
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SavedLocationViewCell else {
            print("SavedLocationsViewController > CellType doesn't match.")
            return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        }
        
        if indexPath.row < locations.count {
            cell.location = locations[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SavedLocationViewCell else {
            print("SavedLocationsViewController > CellType doesn't match.")
            return
        }
        
        if let indexPath = selectedIndex {
            guard let cellUnselected = tableView.cellForRow(at: indexPath) as? SavedLocationViewCell else {
                print("SavedLocationsViewController > CellType doesn't match.")
                return
            }
            cellUnselected.deselected()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        cell.selected()
        
        selectedLocation = cell.location
        selectedIndex = indexPath
    }
    
}
