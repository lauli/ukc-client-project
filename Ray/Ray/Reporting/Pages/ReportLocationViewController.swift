//
//  ReportLocationViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 20.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

final class ReportLocationViewController: ReportPageViewController {

    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var segment: UISegmentedControl!
    
    @IBOutlet private weak var containerManual: UIView!
    @IBOutlet private weak var containerSaved: UIView!
    @IBOutlet private weak var containerMap: UIView!
    
    private var suggestedVC: SuggestedInputViewController?
    private var savedLocationsVC: SavedLocationsTableViewController?
    private var mapVC: MapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segment.selectedSegmentIndex = 0
        showContainer(inside: true)
    }
    private func setupLayout() {
        nextButton.backgroundColor = .princetonOrange
        nextButton.layer.cornerRadius = 5
        
        segment.tintColor = .princetonOrange
        segment.layer.borderColor = UIColor.princetonOrange.cgColor
        
        showContainer(inside: true)
    }
    
    private func showContainer(inside: Bool = false, outside: Bool = false, saved: Bool = false) {
        containerManual.isHidden = !inside
        containerMap.isHidden = !outside
        containerSaved.isHidden = !saved
    }
    
    // MARK: - Overrides
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SuggestedInputViewController {
            suggestedVC = viewController
            
        } else if let viewController = segue.destination as? SavedLocationsTableViewController {
            savedLocationsVC = viewController
            
        } else if let viewController = segue.destination as? MapViewController {
            mapVC = viewController
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // inside
            showContainer(inside: true)
        case 1:
            // outside
            showContainer(outside: true)
        case 2:
            // saved
            showContainer(saved: true)
            savedLocationsVC?.shows()
            
        default:
            showContainer(inside: true)
        }
    }
    
    @IBAction func nextPage(_ sender: Any) {
        
        if !containerManual.isHidden, let suggestedVC = suggestedVC {
            if let location = suggestedVC.savedLocation() {
                viewModel.location = location
                
            } else {
                if viewModel.location == nil {
                    let alert = UIAlertController(title: "Missing Input", message: "Please make sure to give us all the information we need to handle your report properly (location).", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }

            
        } else if !containerSaved.isHidden, let savedVC = savedLocationsVC {
            savedVC.shows()
            if let savedLocation = savedVC.selectedLocation {
                viewModel.location = savedLocation
            } else {
                if viewModel.location == nil {
                    let alert = UIAlertController(title: "Missing Input", message: "Please make sure to select one of your saved locations.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            
        } else if !containerMap.isHidden, let mapVC = mapVC {
            let (lat, long) = mapVC.savedLocation()
            viewModel.location = Location(building: lat, floor: long, room: "")
        }
        
        delegate?.nextPage()
    }
}
