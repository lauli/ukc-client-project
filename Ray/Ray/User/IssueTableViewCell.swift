//
//  IssueTableViewCell.swift
//  Ray
//
//  Created by Laureen Schausberger on 21.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    var report: Report? {
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
        titleLabel.text = report?.title
        
        let location = report?.location.toString() ?? ""
        let description = report?.description ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
        infoLabel.text = location + "\n" + description
    }

}
