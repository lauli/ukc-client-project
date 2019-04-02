//
//  SingleSavedLocationViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 15.03.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class SavedLocationViewCell: UITableViewCell {
    
    @IBOutlet private weak var buildingLabel: UILabel!
    @IBOutlet private weak var floorLabel: UILabel!
    @IBOutlet private weak var roomLabel: UILabel!
    
    var location: Location? {
        didSet {
            updateLabels()
            deselected()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func updateLabels() {
        buildingLabel.text = location?.building
        floorLabel.text = location?.floor
        roomLabel.text = location?.room
    }
    
    func selected() {
        buildingLabel.textColor = .weldonBlue
        floorLabel.textColor = .weldonBlue
        roomLabel.textColor = .weldonBlue
    }
    
    func deselected() {
        buildingLabel.textColor = .black
        floorLabel.textColor = .black
        roomLabel.textColor = .black
    }

}
