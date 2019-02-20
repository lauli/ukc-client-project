//
//  ReportAttachmentsViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 20.02.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class ReportAttachmentsViewController: ReportPageViewController {

    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendButton.backgroundColor = .charcoal
        sendButton.layer.cornerRadius = 5
    }
    

    @IBAction func sendReport(_ sender: Any) {
        
    }
    
}
