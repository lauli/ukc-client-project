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
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundimage.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        // Do any additional setup after loading the view.
        
    }
    

    @IBAction func loginBtnTapped(_ sender: Any) {
        guard let email = self.emailField.text, let password = self.passwordField.text else {
            let alertController = UIAlertController(title: "Alert", message: "Email/Password incorrect.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                //OK Action
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                let alertController = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                    //OK Action
                }))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            else{
                 print("LOGIN")
                
            }
            
            
        }

        
    }


}
