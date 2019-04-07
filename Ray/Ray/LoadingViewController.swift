//
//  LoadingViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 02.04.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

final class LoadingViewController: UIViewController {
    
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
    }
    
    func stopIndicator() {
        loadingIndicator.stopAnimating()
    }
    
}
