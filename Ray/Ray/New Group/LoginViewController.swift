//
//  LoginViewController.swift
//  Ray
//
//  Created by Phoebe Heath-Brown on 27/02/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginBtnTapped(_ sender: Any) {
        guard let email = self.emailField.text, let password = self.passwordField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let strongSelf = self else { return }
            print("LOGIN")
        }

        
    }


}
