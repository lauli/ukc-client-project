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
    
    @IBOutlet weak var issueTitle: UILabel!
    @IBOutlet weak var issueDate: UILabel!
    @IBOutlet weak var issueDesc: UILabel!
    
    var item: RSSItem! {
        didSet {
            issueTitle.text = item.title
            issueDesc.text = item.description
            issueDate.text = item.pubDate
        }
    }
}
