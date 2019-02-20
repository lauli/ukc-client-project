//
//  ReportLocationViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 20.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class ReportLocationViewController: ReportPageViewController {

    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        nextButton.backgroundColor = .princetonOrange
        nextButton.layer.cornerRadius = 5
    }
    
    @IBAction func nextPage(_ sender: Any) {
        delegate?.nextPage()
    }
}
