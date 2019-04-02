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

    var locationText: String?
    var descriptionText: String?
    var attachment1Url: String?
    var attachment2Url: String?
    var attachment3Url: String?
    var attachment4Url: String?
    var viewedText: String?
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
        dayLabel.text = report?.day ?? ""
        monthLabel.text = report?.month.uppercased() ?? ""
        titleLabel.text = report?.title ?? ""
        viewedText = report?.viewed ?? ""
        attachment1Url = report?.attachment.attachment1 ?? ""
        attachment2Url = report?.attachment.attachment2 ?? ""
        attachment3Url = report?.attachment.attachment3 ?? ""
        attachment4Url = report?.attachment.attachment4 ?? ""
        locationText = report?.location.toString() ?? ""
        descriptionText = report?.description ?? ""
        infoLabel.text = locationText! + "\n" + descriptionText!
    }

}
