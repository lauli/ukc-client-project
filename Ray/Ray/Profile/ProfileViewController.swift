//
//  ProfileViewController.swift
//  Ray
//
//  Creat/Users/ksb36/ukc-client-project/Ray/Ray/Profile/ProfileViewController.swifted by Kirsty Samantha Butler on 26/02/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var noField: UITextField!
    
    @IBOutlet weak var chooseLocation: UITextField!
    @IBOutlet weak var chosenLocation: UITextField!
    
    @IBOutlet weak var addLocation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLocation.backgroundColor = .princetonOrange
        addLocation.layer.cornerRadius = 5
        
    }
    @IBAction func location(_ sender: Any) {
        
    }
    
    @IBAction func ukcBtn(_ sender: UIButton) {
    }
    @IBAction func addBtn(_ sender: UIButton) {
    }
}
