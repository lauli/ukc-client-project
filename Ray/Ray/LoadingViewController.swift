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
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        
        locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
        }
    }
    
    func stopIndicator() {
        loadingIndicator.stopAnimating()
    }
    
}
