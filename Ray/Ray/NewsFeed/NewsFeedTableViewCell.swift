//
//  NewsFeedTableViewCell.swift
//  Ray
//
//  Created by Kirsty Samantha Butler on 17/02/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

enum CellState {
    case expanded
    case collapsed
}

class NewsFeedTableViewCell: UITableViewCell {
    
    var fullDescriptionText: String?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet {
        descriptionLabel.numberOfLines = 3
        }
    }
    
    var item: RSSItem! {
        didSet {
            titleLabel.text = item.title
            descriptionLabel.text = item.description
            fullDescriptionText = item.description
            dateLabel.text = item.pubDate
        }
    }
}
