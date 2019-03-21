//
//  SingleSavedLocationViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 15.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class SingleSavedLocationViewController: UIViewController {
    
    @IBOutlet private weak var buildingLabel: UILabel!
    @IBOutlet private weak var floorAndRoomLabel: UILabel!
    @IBOutlet private weak var backgroundView: UIView!
    
    var location: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        updateLabels()
    }
    
    private func setupLayout() {
        backgroundView.layer.cornerRadius = 20
    }
    
    private func updateLabels() {
        buildingLabel.text = location?.building
        floorAndRoomLabel.text = location?.toString()
        buildingLabel.accessibilityIdentifier = buildingLabel.text
        floorAndRoomLabel.accessibilityIdentifier = floorAndRoomLabel.text
    }

}
