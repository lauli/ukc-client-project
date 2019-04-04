//
//  CreateAccountViewController.swift
//  Ray
//
//  Created by Phoebe Heath-Brown on 28/02/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundscreen.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func createAccountTapped(_ sender: Any) {
        guard let email = self.emailField.text else {
            let alertController = UIAlertController(title: "Alert", message: "Email can't be empty.", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let password = self.passwordField.text else {
            let alertController = UIAlertController(title: "Alert", message: "Password can't be empty.", preferredStyle: .alert)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let name = self.nameField.text else {
            let alertController = UIAlertController(title: "Alert", message: "Name can't be empty.", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let phone = self.phoneField.text else {
            let alertController = UIAlertController(title: "Alert", message: "Phone can't be empty.", preferredStyle: .alert)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            guard let authResult = authResult, error == nil else {
                let alertController = UIAlertController(title: "Alert", message: error!.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                    //OK Action
                }))
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
            print("\(authResult.user.email!) created")
            
            // retrieve user id for new user
            guard let uid = Auth.auth().currentUser?.uid else {
                print("CreateAccountViewController > Couldn't retrieve user id after saving.")
                return
            }
            
            // make user object for database entry
            var dictionary: [String: Any] = [:]
            dictionary.updateValue(email, forKey: "email")
            dictionary.updateValue(name, forKey: "name")
            dictionary.updateValue(phone, forKey: "phone")
            dictionary.updateValue([], forKey: "locations")
            dictionary.updateValue([], forKey: "issues")
            
            // save user into database
            Database.database().reference().child("Company").child("University Of Kent").child("User").child("User ID").child(uid).setValue(dictionary)
            
            // set user id in user defaults on phone
            UserDefaults.standard.set(uid, forKey: "userID")
            
            // push tabbarcontroller
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.showTabBarController(forUserID: uid)
            }
        }
       
    }
    
}
