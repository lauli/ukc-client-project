//
//  ProfileViewController.swift
//  Ray
//
//  Created by Kirsty Samantha Butler on 26/02/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var noField: UITextField!
    
    @IBOutlet weak var chooseLocation: UITextField!
    @IBOutlet weak var chosenLocation: UITextField!
    
    @IBOutlet weak var addLocation: UIButton!
    
    @IBAction func ukcBtn(_ sender: UIButton) {
    }
    @IBAction func addBtn(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout(){
        
    }
}
