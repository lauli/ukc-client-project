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
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var containerManual: UIView!
    @IBOutlet weak var containerSaved: UIView!
    @IBOutlet weak var containerMap: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        nextButton.backgroundColor = .princetonOrange
        nextButton.layer.cornerRadius = 5
        
        segment.tintColor = .princetonOrange
        segment.layer.borderColor = UIColor.princetonOrange.cgColor
        
        showContainer(manual: true)
    }
    
    private func showContainer(manual: Bool = false, saved: Bool = false, map: Bool = false) {
        containerManual.isHidden = !manual
        containerSaved.isHidden = !saved
        containerMap.isHidden = !map
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // manual
            showContainer(manual: true)
        case 1:
            // saved
            showContainer(saved: true)
        case 2:
            // map
            showContainer(map: true)
        default:
            showContainer(manual: true)
        }
    }
    
    @IBAction func nextPage(_ sender: Any) {
        delegate?.nextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let mapViewController = segue.destination as? MapViewController else {
            return
        }
        
        mapViewController.size = containerMap.bounds
    }
}
