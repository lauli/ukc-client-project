//
//  ReportingViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 31.01.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class ReportingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem = UITabBarItem(title: "Report",
                     image: UIImage.init(named: "icon-report-outline"),
                     selectedImage: UIImage.init(named: "icon-report"))
        
        title = "Report a new Issue"
    }

}
