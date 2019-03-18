//
//  SharedIssueTableViewCell.swift
//  Ray
//
//  Created by Phoebe Heath-Brown on 16/03/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class SharedIssueTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var locationText: String?
    var descriptionText: String?
    var sharedIssue: Shared? {
        didSet {
            updateLabels()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setupLayout() {
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func updateLabels() {
        dayLabel.text = sharedIssue?.reports?[0].day ?? ""
        monthLabel.text = sharedIssue?.reports?[0].month.uppercased() ?? ""
        titleLabel.text = sharedIssue?.reports?[0].title ?? ""
        
        locationText = sharedIssue?.reports?[0].location.toString() ?? ""
        descriptionText = sharedIssue?.reports?[0].description ?? ""
        infoLabel.text = locationText! + "\n" + descriptionText!
    }

}
