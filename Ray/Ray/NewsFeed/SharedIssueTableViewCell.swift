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
        dayLabel.text = "17"
        monthLabel.text = "SEP"
        titleLabel.text = sharedIssue?.reports?[0].title
        
        let location = sharedIssue?.reports?[0].location.toString() ?? ""
        let description = sharedIssue?.reports?[0].description ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
        infoLabel.text = location + "\n" + description
    }

}
