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
    
    //    let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpID") as! PopUpViewController
    //    self.addChild (popOverVC)
    //    popOverVC.view.frame = self.view.frame
    //    self.view.addSubview(popOverVC.view)
    //    popOverVC.didMove(toParent: self)
    
    
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
