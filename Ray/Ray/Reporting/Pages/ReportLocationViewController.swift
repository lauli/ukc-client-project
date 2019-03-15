//
//  ReportLocationViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 20.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class ReportLocationViewController: ReportPageViewController {

    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var segment: UISegmentedControl!
    
    @IBOutlet private weak var containerManual: UIView!
    @IBOutlet private weak var containerSaved: UIView!
    @IBOutlet private weak var containerMap: UIView!
    
    private var suggestedVC: SuggestedInputViewController?
//    private var savedLocationsVC:
    private var mapVC: MapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        nextButton.backgroundColor = .princetonOrange
        nextButton.layer.cornerRadius = 5
        
        segment.tintColor = .princetonOrange
        segment.layer.borderColor = UIColor.princetonOrange.cgColor
        
        showContainer(manual: true)
    }
    
    private func showContainer(manual: Bool = false, saved: Bool = false, map: Bool = false) {
        containerManual.isHidden = !manual
        containerSaved.isHidden = !saved
        containerMap.isHidden = !map
    }
    
    // MARK: - Overrides
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SuggestedInputViewController {
            suggestedVC = viewController
            
        } else if let viewController = segue.destination as? MapViewController {
            mapVC = viewController
        }
        // TODO: make for saved locations
    }
    
    // MARK: - IBActions
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // manual
            showContainer(manual: true)
        case 1:
            // saved
            showContainer(saved: true)
        case 2:
            // map
            showContainer(map: true)
        default:
            showContainer(manual: true)
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

            
        } else if !containerSaved.isHidden {
            
        } else if !containerMap.isHidden, let mapVC = mapVC {
            let (lat, long) = mapVC.savedLocation()
            viewModel.location = Location(building: lat, floor: long, room: "")
        }
        
        delegate?.nextPage()
    }
}
