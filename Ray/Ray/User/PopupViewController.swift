//
//  PopupViewController.swift
//  Ray
//
//  Created by Kirsty Samantha Butler on 13/03/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    

    @IBOutlet weak var buildingField: UITextField!
    @IBOutlet weak var floorField: UITextField!
    @IBOutlet weak var roomField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildingField.delegate = self
        self.buildingField.becomeFirstResponder()
        floorField.delegate = self
        roomField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   @objc func endEditing() {
        view.endEditing(true)
    }
}

 extension PopupViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
 }
