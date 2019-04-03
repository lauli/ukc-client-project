//
//  NewsFeedDetailsViewController.swift
//  Ray
//
//  Created by Kirsty Samantha Butler on 28/02/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class NewsFeedDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var dateText: String?
    var titleText: String?
    var descText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleText
        dateLabel.text = dateText
        descLabel.text = descText
    }
    
    

}
