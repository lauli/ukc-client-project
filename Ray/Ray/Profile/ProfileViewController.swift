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
    
    @IBOutlet weak var ukc: UIButton!
    @IBOutlet weak var add: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
    }
    @IBAction func location(_ sender: Any) {
        
    }
    
    @IBAction func ukcBtn(_ sender: UIButton) {
    }
    @IBAction func addBtn(_ sender: UIButton) {
    }
    
    private func setupLayout() {
        addLocation.backgroundColor = .princetonOrange
        addLocation.layer.cornerRadius = 5
        
        ukc.backgroundColor = .princetonOrange
        ukc.layer.cornerRadius = 20
        
        add.backgroundColor = .white
        add.setTitleColor(.weldonBlue, for: .normal)
        add.layer.borderColor = UIColor.weldonBlue.cgColor
        add.layer.borderWidth = 1
        add.layer.cornerRadius = 20
    }
}
