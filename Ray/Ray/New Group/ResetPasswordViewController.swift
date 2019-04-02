//
//  ResetPasswordViewController.swift
//  Ray
//
//  Created by Phoebe Heath-Brown on 28/02/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundimage.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func resetPasswordTapped(_ sender: Any) {
    
        guard let email = self.emailField.text else {
            let alertController = UIAlertController(title: "Alert", message: "Email can't be empty.", preferredStyle: .alert)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    
                        if let error = error {
                            let alertController = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                                //OK Action
                            }))
                            
                            self.present(alertController, animated: true, completion: nil)
                            return
                        }
                    let alertController = UIAlertController(title: "Alert", message: "Password reset email sent!", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                        //OK Action
                    }))
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                // [END password_reset]
            }

}
