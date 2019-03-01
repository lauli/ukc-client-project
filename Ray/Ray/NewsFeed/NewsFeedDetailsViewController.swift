//
//  NewsFeedDetailsViewController.swift
//  Ray
//
//  Created by Kirsty Samantha Butler on 28/02/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class NewsFeedDetailsViewController: UIViewController {
    
    @IBOutlet weak var furtherDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate var imageView = UIImageView()
    
    fileprivate var desc: UILabel? {
        get {
            return furtherDesc
        }
        set {
            furtherDesc = newValue
        }
    }
}
