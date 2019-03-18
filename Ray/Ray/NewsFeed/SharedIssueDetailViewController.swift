//
//  SharedIssueDetailViewController.swift
//  Ray
//
//  Created by Phoebe Heath-Brown on 18/03/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class SharedIssueDetailViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var viewedIcon: UIImageView!
    @IBOutlet var viewedLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    var titleText: String?
    var location: String?
    var date: String?
    var month: String?
    var descriptionText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = titleText
        locationLabel.text = location
        dateLabel.text = date
        monthLabel.text = month
        descriptionLabel.text = descriptionText
    }
    

    /*
     
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
